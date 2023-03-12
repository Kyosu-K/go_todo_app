FROM golang:1.19.7-alpine3.17

RUN apk update && apk add git

WORKDIR /app

# ホットリロード
RUN go install github.com/cosmtrek/air@latest && \
  go install golang.org/x/tools/gopls@latest && \
  go install github.com/ramya-rao-a/go-outline@latest