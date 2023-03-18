# デプロイ用コンテナに含めるバイナリを作成するコンテナ
FROM golang:1.18.2-bullseye as deploy-builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimath -ldflags "-w -s" -o app

# -------------------------------------------

# デプロイ用コンテナ
FROM debian:bullseye-slim as deploy

RUN apt-get update
COPY --from=deploy-builder /app/app .

CMD ["./app"]

# -------------------------------------------

# ローカル開発環境で利用するホットリロード環境
FROM golang:1.18.2 as dev
# RUN apk update && apk add alpine-sdk

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/ramya-rao-a/go-outline@latest
CMD ["air"]