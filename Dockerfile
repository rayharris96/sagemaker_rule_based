# Build an image that can do training and inference in SageMaker
# This is a Python 3 image that uses the packages in requirements.txt to serve a rule-based algorithm for course nat recommender

FROM ubuntu:18.04

LABEL org.opencontainers.image.authors="raymond_harris@ssg.gov.sg"


RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         python3-pip \
         python3-setuptools \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

#Install packages inside requirements 
#Pip install packages without saving cache to save image space, optimizing start up time
COPY src/requirements.txt requirements.txt
RUN pip --no-cache-dir install -U -r requirements.txt

# download the english language model
RUN python -m spacy download en_core_web_sm

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYCODE=TRUE
ENV PATH="/opt/program:${PATH}"

COPY rule_based /opt/program
WORKDIR /opt/program
