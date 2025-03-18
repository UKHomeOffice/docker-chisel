FROM golang:1.24-alpine3.20 AS build
WORKDIR /go/src/

RUN apk update
RUN apk add git

ENV CHISEL_VERSION=v1.10.1
ENV CGO_ENABLED 0

RUN git clone -b $CHISEL_VERSION https://github.com/jpillora/chisel

WORKDIR /go/src/chisel

RUN go get -u
RUN go mod tidy
RUN go build

FROM alpine:3.21.3
RUN apk update && apk upgrade
COPY --from=build /go/src/chisel/chisel /chisel

USER 1000

ENTRYPOINT ["/chisel"]
