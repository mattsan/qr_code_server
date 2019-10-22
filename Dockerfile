# see https://hexdocs.pm/phoenix/releases.html#containers

FROM elixir:1.9-alpine as build

WORKDIR /app

# install build dependencies
RUN apk add --update git build-base nodejs yarn npm

# install hex + rebar
RUN mix local.hex --force && mix local.rebar

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs ./
COPY mix.lock ./
COPY config ./config
RUN mix deps.get --only prod
RUN mix deps.compile

# build assets
COPY assets ./assets
RUN npm install --prefix ./assets && npm run deploy --prefix ./assets
RUN mix phx.digest

# build project
COPY priv ./priv
COPY lib ./lib
RUN mix compile

# build release
# COPY rel ./rel
RUN mix release

# prepare release image

FROM alpine:3.10 as web

RUN apk add --update bash openssl

WORKDIR /app

COPY --from=build /app/_build/prod/rel/qr_code_server ./

RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD bin/qr_code_server start
