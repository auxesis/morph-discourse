# morph-discourse

Standalone [Discourse](https://www.discourse.org/) for [help.morph.io](https://help.morph.io), running on [Digital Ocean](https://www.digitalocean.com/).

 - All changes [built through Travis](https://travis-ci.org/auxesis/morph-discourse)
 - Builds images for Digital Ocean droplets using Packer, shell, and Ansible

## Quickstart

Ensure you have make, Ruby, Packer installed.

Clone the repository and install Ruby dependencies:

```
git clone https://github.com/auxesis/morph-discourse.git
bundle
```

Sign up to [Digital Ocean](https://www.digitalocean.com/), and [generate an API key](https://cloud.digitalocean.com/settings/api/tokens).

Put the API key in `.env`:

```
DO_API_KEY: MY_VERY_LONG_API_KEY
```

Then build the image:

```
dotenv make build
```



## Debugging and troubleshooting changes

When you're making changes, it's likely Packer will fail. By default, Packer will remove the droplet when there's a build failure.

You can get Packer to leave the droplet in place so you can debug by running:

```
dotenv make build_and_abort
```

Find the IP address [of the droplet](https://cloud.digitalocean.com/droplets), then connect using `do_digitalocean.pem`:

```
ssh -i do_digitalocean.pem -l root IP_ADDRESS
```

## Building new images through CI

When your changes are ready, submit a PR.

This will trigger a build of the image on Travis, using the secrets in the repository.

## Secrets

The build of the image requires several secrets:

 - `DO_API_KEY` in `.travis.yml`, the Digital Ocean API key used by Packer to create and destroy instances.
 - `secrets.tar.gz.enc`, an encrypted tarball of files used by Ansible when builting the image.

There are several secrets we encrypt and store in `secrets.tar.gz.enc`:

 - `ansible/group_vars/all` - variables used by Ansible
 - `ansible/roles/discourse/files/sslmate.conf` - SSLMate api key
 - `ansible/roles/discourse/files/dhparam.pem` - Diffie Hellman Ephemeral Parameters
 - `ansible/roles/discourse/files/morph.io.key` - RSA private key for morph.io

### Making changes to secrets

_For most changes you probably don't want to do this._

Whenever you make changes to any of the files above, encrypt them with:

```
make encrypt
```

Whenever CI runs, decrypts the credentials by running the `decrypt` target.

The `decrypt` target will fail on any environment other than Travis.
