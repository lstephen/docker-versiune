FROM debian:jessie
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

ADD versiune.sh /usr/local/bin/versiune.sh
RUN chmod +x /usr/local/bin/versiune.sh

ENTRYPOINT ["versiune.sh"]
