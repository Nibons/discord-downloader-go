FROM golang:1.15-alpine AS BUILDER
WORKDIR /build

RUN apk update && apk upgrade && apk --no-cache add ca-certificates

COPY . /build

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app .

FROM scratch
WORKDIR /root/
COPY --from=BUILDER /build/app .
COPY --from=BUILDER /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["./app"]