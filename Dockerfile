FROM golang:1.25.7-alpine3.23 AS build
WORKDIR /go/src/

RUN apk --no-cache add git

ENV CHISEL_VERSION=v1.11.3
ENV CGO_ENABLED=0

RUN git clone -b $CHISEL_VERSION https://github.com/jpillora/chisel

WORKDIR /go/src/chisel

RUN go get -u && go mod tidy && go build

FROM alpine:3.23
RUN apk update && apk upgrade
COPY --from=build /go/src/chisel/chisel /chisel

USER 1000

ENTRYPOINT ["/chisel"]
