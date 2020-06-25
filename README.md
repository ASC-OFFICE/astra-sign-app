# astra-sign-app

## Usage

Example:
```
docker build -t astra-sign-app .
docker run -it \
	-v ./keys:/root/keys \
	-v ./buildroot:/root/buildroot \
	astra-sign-app
```
### Used volumes

- `/root/keys` - for keys, must contain `public.key`, `secret.gpg`, `password.txt`.
- `/root/buildroot` - for ELF files.

### Optional variables

- `PUBLIC_KEY_FILE` - custom filename of public key
- `SECRET_KEY_FILE` - custom filename of secret key
- `PASSWORD_FILE` - custom filename of password
