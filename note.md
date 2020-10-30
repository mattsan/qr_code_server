イメージをビルドする

docker build . -t test/qr-code-server:0.1 --build-arg SECRET_KEY_BASE

タグを設定する

docker tag test/qr-code-server:0.1 registry.heroku.com/qr-code-server/web

ローカルで確認する
docker run --rm -it -p 4000:4000 registry.heroku.com/qr-code-server/web bash
PORT=4000 bin/qr_code_server start_iex

heroku に push する

docker push registry.heroku.com/qr-code-server/web

