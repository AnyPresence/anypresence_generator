# version 0.0.1
FROM ubuntu:14.04
MAINTAINER Jeff Bozek, jbozek@anypresence.com

# Install library dependencies
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev curl openssl git chrpath git-core libfontconfig1-dev libffi6 libffi-dev

# Install Nodejs
RUN apt-get -y install nodejs npm
RUN ln /usr/bin/nodejs /usr/bin/node

# Install PhantomJS
RUN curl -L -s https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 > phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN tar -xvjf phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN mv phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin
RUN rm -rf phantomjs-1.9.7-linux-x86_64/
RUN rm -f phantomjs-1.9.7-linux-x86_64.tar.bz2

# Install Forego
RUN curl -L -s https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego > /bin/forego
RUN chmod a+x /bin/forego

# Install jemalloc
RUN mkdir /jemalloc
WORKDIR /jemalloc
RUN curl -L -s http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2 > jemalloc-3.6.0.tar.bz2
RUN tar -xvjf jemalloc-3.6.0.tar.bz2
WORKDIR jemalloc-3.6.0
RUN ./configure
RUN make
RUN mv lib/libjemalloc.so.1 /usr/lib
WORKDIR /
RUN rm -rf /jemalloc
RUN echo '#!/bin/sh' > /usr/bin/jemalloc.sh
RUN echo 'export LD_PRELOAD=$LD_PRELOAD:/usr/lib/libjemalloc.so.1' >> /usr/bin/jemalloc.sh
RUN echo 'exec "$@"' >> /usr/bin/jemalloc.sh
RUN chmod a+x /usr/bin/jemalloc.sh

# Install Ruby 2.1.2
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN curl -L ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.bz2 | tar -xj -C /tmp
RUN cd /tmp/ruby-2.1.2 && ./configure --disable-install-doc && make install clean
ENV LC_ALL en_US.UTF-8
RUN gem update --system
RUN rm -r /tmp/ruby-2.1.2
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler