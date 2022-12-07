# Javascript and CSS in Modern Rails

I know nothing about this.

## esbuild

## Starting from Scratch

```bash
# Get docker-compose.yml and docker-compose.override.yml from somewhere.
docker-compose run shell
gem install rails
rails new -d postgresql --edge -j esbuild -c bootstrap .
# Edit config/database.yml

bin/rails db:prepare
```

In another terminal:

```bash
docker-compose up web
```

## Restarting

If you're running `shell` in one window and the server in another, you can restart the server with the good old:

```bash
bin/rails restart
```

## Bootstrap

- Put the meta line in the application layout, for responsiveness and ???: `<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">` TBC I THINK THIS WAS ALREADY THERE.
- Some Bootstrap features require JavaScript, and aren't enabled by default due to performance considerations (tooltips, toasters). See the Bootstrap documentation, e.g. https://getbootstrap.com/docs/5.1/components/toasts/ or https://getbootstrap.com/docs/5.1/components/tooltips/.
