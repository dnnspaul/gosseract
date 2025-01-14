FROM alpine:latest

RUN apk update
RUN apk add \
  g++ \
  git \
  musl-dev \
  go \
  tesseract-ocr-dev

ENV GOPATH=/root/go

ADD . ${GOPATH}/src/github.com/dennispaul/gosseract
WORKDIR ${GOPATH}/src/github.com/dennispaul/gosseract

ENV GOSSERACT_CPPSTDERR_NOT_CAPTURED=1
CMD ["go", "test", "-v", "./..."]
