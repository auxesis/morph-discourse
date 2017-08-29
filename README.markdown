## Building an image

1. Sign up to [Digital Ocean](https://www.digitalocean.com/)
2. [Generate an API key](https://cloud.digitalocean.com/settings/api/tokens)
3. Set up `.env`:

   ```
   DO_API_KEY: 347ccc82d612810042fcf6fbc96cf87a9399275cc120013d7a7c86b6987859b4
   ```

4. Then build the image

   ```
   dotenv make
   ```

## Making changes to credentials

Whenever you make changes to credentials at `ansible/group_vars/all`, encrypt them with:

```
make encrypt
```

Whenever CI runs, it will ensure the credentials are decrypted by running

```
make decrypt
```

The `decrypt` target will fail on any environment other than Travis.

## TODO

- Move discourse from /var/docker to /opt/discourse
