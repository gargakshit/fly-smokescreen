FROM golang:1.22.8-alpine AS builder

ENV CGO_ENABLED=0
RUN go install github.com/stripe/smokescreen@master

# ---
FROM alpine:latest

WORKDIR /app
COPY --from=builder /go/bin/smokescreen /app
COPY config.yaml /app

ENTRYPOINT ["/app/smokescreen", "--config-file", "/app/config.yaml", "--expose-prometheus-metrics"]
