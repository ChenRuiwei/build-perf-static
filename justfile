default:
    @just --list

build:
    docker buildx build -t build-perf-static --target export --output . .
