FROM golang:1.23.1-alpine3.20 AS build
WORKDIR /go/src/github.com/jpillora

RUN apk update
RUN apk add git

ENV CHISEL_VERSION=v1.10.0
ENV CGO_ENABLED=0

RUN go install -ldflags "-X github.com/jpillora/chisel/share.BuildVersion=${CHISEL_VERSION}" github.com/jpillora/chisel@${CHISEL_VERSION}

FROM alpine:3.20.3
COPY --from=build /go/bin/chisel /chisel

USER 1000

ENTRYPOINT ["/chisel"]
