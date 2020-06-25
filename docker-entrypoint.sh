#!/bin/bash

PUBLIC_KEY_FILE=${PUBLIC_KEY_FILE:-public.key}
SECRET_KEY_FILE=${SECRET_KEY_FILE:-secret.gpg}
PASSWORD_FILE=${PASSWORD_FILE:-password.txt}

if [[ ! -f "keys/$PUBLIC_KEY_FILE" ]]; then
	echo "Public key file does not exist"
	error=1
fi
if [[ ! -f "keys/$SECRET_KEY_FILE" ]]; then
	echo "Secret key file does not exist"
	error=1
fi
if [[ ! -f "keys/$PASSWORD_FILE" ]]; then
	echo "Password file does not exist"
	error=1
fi
if [[ -z "$(ls -A buildroot)" ]]; then
	echo "Buildroot dir is empty"
	error=1
fi
if [[ -n "$error" ]]; then
	exit 1
fi

pushd keys &> /dev/null
	echo -e "\033[1mImporting keys\033[0m"
	gpg --import --batch --pinentry-mode=loopback --passphrase-file=$PASSWORD_FILE $SECRET_KEY_FILE
	key_fingerprint=$( \
		gpg -n --import --import-options import-show --with-colons $PUBLIC_KEY_FILE | \
		grep -E "^fpr" | \
		cut -d: -f10)
popd &> /dev/null

pushd buildroot &> /dev/null
	echo -e "\033[1mSearching\033[0m"
	elf_files=$(find . -type f -exec file --mime-type {} \; | \
		grep -E "application/(x-executable|x-sharedlib)" | \
		cut -d: -f1)

	echo -e "\033[1mSigning\033[0m"
	bsign --sign --nosymlinks --nopass --pgoptions="\
			--batch \
			--pinentry-mode=loopback \
			--passphrase-file=../keys/$PASSWORD_FILE \
			--default-key=$key_fingerprint" \
		$elf_files

	echo -e "\033[1mVerification\033[0m"
	bsign --verify --hide-good-sigs $elf_files
popd &> /dev/null

echo -e "\033[1mDone\033[0m"
exit 0
