FROM python:2.7-alpine

MAINTAINER TDN <ngoctd@ai-t.vn>

RUN apk add --no-cache --virtual .scrapy-builddeps gcc musl-dev libxml2-dev libxslt-dev libffi-dev openssl-dev py-mysqldb mysql-dev \
    && apk add libxml2 libxslt libffi \
    && pip install --upgrade pip \
    && pip install --no-cache-dir scrapy scrapyd scrapy-splash \
    && pip install --no-cache-dir six kafka elasticsearch dpath Scrapy SQLAlchemy pymysql mysql-python \
    && apk del .scrapy-builddeps

# Add the dependencies to the container and install the python dependencies
ADD package.txt /tmp/package.txt
RUN pip install --no-cache-dir -r /tmp/package.txt && rm /tmp/package.txt
RUN mkdir -p /var/lib/scrapyd/ && cd /var/lib/scrapyd/ && mkdir -p eggs items logs dbs

COPY ./scrapyd.conf /etc/scrapyd/
VOLUME /etc/scrapyd/ /var/lib/scrapyd/
EXPOSE 6800

CMD ["scrapyd", "--pidfile="]