FROM golang:1.22.0 AS builder

RUN apt-get update && apt-get install -y gcc make
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main


FROM alpine:latest
RUN apk add --no-cache sqlite-libs

WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/tracker.db .

CMD ["./main"]
