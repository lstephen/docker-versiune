FROM debian:jessie
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

RUN apt-get update && apt-get -y install git

ADD versiune.sh /usr/local/bin/versiune.sh
RUN chmod +x /usr/local/bin/versiune.sh

ENTRYPOINT ["versiune.sh"]
