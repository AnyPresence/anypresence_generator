# anypresence/generator:0.0.5
# version 0.0.5
FROM ubuntu:14.04
MAINTAINER Jeff Bozek, jbozek@anypresence.com

ENV LC_ALL en_US.UTF-8

# Install library dependencies, PhantomJS, Forego, and Ruby 2.3.0
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install build-essential zlib1g-dev libssl-dev \
    libreadline6 libreadline6-dev libyaml-dev curl openssl git \
    chrpath git-core libfontconfig1-dev libffi6 libffi-dev redis-server zip unzip \
    nodejs npm && ln /usr/bin/nodejs /usr/bin/node && \
    curl -L -s https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 > phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
    tar -xvjf phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
    mv phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin && \
    rm -rf phantomjs-1.9.7-linux-x86_64/ && \
    rm -f phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
    curl -L -s https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego > /bin/forego && \
    chmod a+x /bin/forego && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 && \
    curl -L ftp://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.bz2 | tar -xj -C /tmp && \
    cd /tmp/ruby-2.3.0 && ./configure --disable-install-doc && make install clean && cd / && \
    gem update --system && rm -r /tmp/ruby-2.3.0 && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && gem install bundler
