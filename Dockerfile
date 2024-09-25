FROM golang:1.23.1-alpine3.20 AS build
WORKDIR /go/src/github.com/jpillora

RUN apk update && apk add --no-cache git

ENV CHISEL_VERSION=v1.10.0
ENV CGO_ENABLED=0

RUN git clone https://github.com/jpillora/chisel.git . && \
    go mod edit -require=golang.org/x/crypto@v0.17.0 && \
    go mod edit -require=golang.org/x/net@v0.23.0 && \
    go mod tidy

RUN go install -ldflags "-X github.com/jpillora/chisel/share.BuildVersion=${CHISEL_VERSION}" github.com/jpillora/chisel@${CHISEL_VERSION}

FROM alpine:3.20.3
COPY --from=build /go/bin/chisel /chisel

USER 1000
ENTRYPOINT ["/chisel"]
