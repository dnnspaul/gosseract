FROM debian:latest

RUN apt-get update -qq
RUN apt-get install -y \
  git \
  golang \
  libtesseract-dev \
  tesseract-ocr-eng

ENV GOPATH=/root/go
ENV GO111MODULE=on

ADD . ${GOPATH}/src/github.com/dennispaul/gosseract
WORKDIR ${GOPATH}/src/github.com/dennispaul/gosseract

RUN tesseract --version

CMD ["go", "test", "-v", "./..."]
