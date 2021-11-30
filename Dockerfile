#####
# This is a working example of setting up tesseract/gosseract,
# and also works as an example runtime to use gosseract package.
# You can just hit `docker run -it --rm otiai10/gosseract`
# to try and check it out!
#####
FROM golang:latest
LABEL maintainer="Hiromu Ochiai <otiai10@gmail.com>"

# Setup Environment Variables
ENV TESSDATA_PREFIX=/usr/local/share/tessdata/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Install Leptonica + Tesseract-OCR
RUN mkdir /tess && cd /tess && apt-get update -qq && apt-get install -yy g++ autoconf automake libtool pkg-config libpng-dev libjpeg62-turbo-dev libtiff5-dev zlib1g-dev

RUN cd /tess && wget http://www.leptonica.org/source/leptonica-1.82.0.tar.gz \
    && tar -xvf leptonica-1.82.0.tar.gz \
    && cd leptonica-1.82.0 \
    && ./configure \
    && make \
    && make install

RUN cd /tess \
    && wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.0.0-rc3.tar.gz \
    && tar -xvf 5.0.0-rc3.tar.gz \
    && ls -lah /tess \
    && cd /tess/tesseract-5.0.0-rc3/ \
    && ./autogen.sh && ./configure && make && make install

# Install Tesseract-Language Trainings
RUN wget https://github.com/tesseract-ocr/tessdata_best/raw/main/deu.traineddata -O /usr/local/share/tessdata/deu.traineddata
RUN wget https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata -O /usr/local/share/tessdata/eng.traineddata

COPY . /usr/local/go/src/gosseract/

WORKDIR /tmp/
CMD ["go", "run", "main.go"]
