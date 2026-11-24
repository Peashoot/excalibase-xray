# Multi-stage: official xray image has no shell, so copy only the binary into Alpine
FROM ghcr.io/xtls/xray-core:latest AS builder

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/local/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
CMD ["/entrypoint.sh"]
