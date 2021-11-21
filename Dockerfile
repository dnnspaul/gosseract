#####
# This is a working example of setting up tesseract/gosseract,
# and also works as an example runtime to use gosseract package.
# You can just hit `docker run -it --rm otiai10/gosseract`
# to try and check it out!
#####
FROM golang:latest
LABEL maintainer="Hiromu Ochiai <otiai10@gmail.com>"

RUN apt-get update -qq

# You need librariy files and headers of tesseract and leptonica.
# When you miss these or LD_LIBRARY_PATH is not set to them,
# you would face an error: "tesseract/baseapi.h: No such file or directory"
# RUN apt-get install -y -qq libtesseract-dev libleptonica-dev

# In case you face TESSDATA_PREFIX error, you minght need to set env vars
# to specify the directory where "tessdata" is located.
ENV TESSDATA_PREFIX=/usr/share/tessdata/

# Load languages.
# These {lang}.traineddata would b located under ${TESSDATA_PREFIX}/tessdata.
# RUN apt-get install -y -qq \
#   tesseract-ocr-eng \
#   tesseract-ocr-deu \
#   tesseract-ocr-jpn
RUN mkdir /tess && cd /tess && apt-get install -yy g++ autoconf automake libtool pkg-config libpng-dev libjpeg62-turbo-dev libtiff5-dev zlib1g-dev libleptonica-dev
RUN cd /tess && wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/4.1.3.tar.gz && tar -xvf 4.1.3.tar.gz && cd tesseract-4.1.3 && ./autogen.sh 
RUN cd /tess/tesseract-4.1.3 && ./configure --prefix=/usr/
RUN cd /tess/tesseract-4.1.3 && make
RUN cd /tess/tesseract-4.1.3 && make install
RUN wget https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata -O /usr/share/tessdata/deu.traineddata
RUN wget https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata -O /usr/share/tessdata/eng.traineddata

# See https://github.com/tesseract-ocr/tessdata for the list of available languages.
# If you want to download these traineddata via `wget`, don't forget to locate
# downloaded traineddata under ${TESSDATA_PREFIX}/tessdata.

# RUN go get -t github.com/otiai10/gosseract
# RUN cd ${GOPATH}/src/github.com/otiai10/gosseract && go test

# Now, you've got complete environment to play with "gosseract"!
# For other OS, check https://github.com/otiai10/gosseract/tree/main/test/runtimes
COPY . /usr/local/go/src/gosseract/

WORKDIR /tmp/
CMD ["go", "run", "main.go"]