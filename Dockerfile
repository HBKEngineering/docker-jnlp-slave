# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM java:8-jdk
MAINTAINER Nicolas De Loof <nicolas.deloof@gmail.com>

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y ruby2.1 ruby2.1-dev
RUN apt-get update && apt-get install -y git python-pip curl zip build-essential rubygems rubygems-integration && rm -rf /var/lib/apt/lists/*
RUN gem install sass
RUN pip install requests

RUN wget https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz
RUN tar -xvzf docker-1.11.2.tgz
RUN cp docker/docker /usr/local/bin/docker

ENV HOME /home/jenkins
RUN useradd -c "Jenkins user" -d $HOME -m jenkins

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar
  
RUN chmod 777 -R /tmp && chmod o+t -R /tmp

COPY jenkins-slave /usr/local/bin/jenkins-slave

VOLUME /home/jenkins
WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT ["jenkins-slave"]
