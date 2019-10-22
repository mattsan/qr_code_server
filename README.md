# QrCodeServer

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# App を Heroku に Docker container でデプロイする

- Phoenix を Docker container でリリースする手順
  - [Containers / Deploying with Releases — Phoenix v1.4.10](https://hexdocs.pm/phoenix/releases.html#containers)
- Heroku に Docker container でデプロイする手順
  - [Container Registry & Runtime (Docker Deploys) | Heroku Dev Center](https://devcenter.heroku.com/articles/container-registry-and-runtime)

## Build and release

ここでは `heroku container:push` コマンドを利用せず、`docker build` コマンドでビルドしています。

コマンド中の `YOUR_IMAGE_TAG` には任意のタグ名で置き換えて実行してください。

同様に `HEROKU_APP_NAME` にはデプロイする Heroku のアプリケーションの名前で置き換えて実行してください。

### イメージをビルドする

```sh
$ docker build . -t YOUR_IMAGE_TAG
```

### タグを設定する

```sh
$ docker tag YOUR_IMAGE_TAG registry.heroku.com/HEROKU_APP_NAME/web
```

### ローカルで確認する

```sh
$ docker run --rm -it -p 4000:4000 registry.heroku.com/HEROKU_APP_NAME/web bash
$ PORT=4000 bin/qr_code_server start_iex
```

### Heroku に push する

```sh
$ docker push registry.heroku.com/HEROKU_APP_NAME/web
```

### リリースする

```sh
$ docker container:release web
```
