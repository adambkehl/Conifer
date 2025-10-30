FROM alpine:latest AS builder

RUN apk add --no-cache build-base musl-dev zlib-dev zlib-static

WORKDIR /src
COPY . .

RUN gcc -static -std=c99 -Wall -Wextra -O3 \
    -D_POSIX_C_SOURCE=200809L \
    -I third_party/uthash/src -I . \
    src/utils.c src/kraken_stats.c src/kraken_taxo.c src/main.c \
    -o conifer -lm -lz

FROM scratch
COPY --from=builder /src/conifer /conifer
ENTRYPOINT ["/conifer"]

