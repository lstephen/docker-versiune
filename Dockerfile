FROM alpine:3.6
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

RUN apk add --no-cache bash git

ADD versiune.sh /usr/local/bin/versiune.sh
RUN chmod +x /usr/local/bin/versiune.sh

ENTRYPOINT ["versiune.sh"]
