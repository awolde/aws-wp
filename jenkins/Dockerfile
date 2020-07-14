FROM ubuntu:16.04
RUN apt-get update && apt-get install curl wget sudo gnupg2 -y
RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
RUN echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get install apt-transport-https ca-certificates -y
RUN apt-get update && apt-get install default-jre jenkins git jq php7.0-cli pylint -y
EXPOSE 8080
COPY start /usr/local/bin
CMD ["start"]
