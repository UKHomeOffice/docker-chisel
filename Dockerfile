FROM golang:1.25-alpine3.21 AS build
WORKDIR /go/src/

RUN apk --no-cache add git

ENV CHISEL_VERSION=v1.11.0
ENV CGO_ENABLED 0

RUN git clone -b $CHISEL_VERSION https://github.com/jpillora/chisel

WORKDIR /go/src/chisel

RUN go get -u && go mod tidy && go build

FROM alpine:3.21
RUN apk update && apk upgrade
COPY --from=build /go/src/chisel/chisel /chisel

USER 1000

ENTRYPOINT ["/chisel"]
