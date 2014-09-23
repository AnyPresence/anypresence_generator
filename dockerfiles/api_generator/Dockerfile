# anypresence/api_generator:0.0.2
# version 0.0.2
FROM anypresence/generator:0.0.2
MAINTAINER Jeff Bozek, jbozek@anypresence.com

# Install database dependencies
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install libdbd-freetds freetds-dev unixodbc-dev \
    libmysqlclient18 libmysqlclient-dev postgresql-client-9.3 \
    postgresql-9.3 postgresql-server-dev-9.3 libpq-dev mongodb \
    alien libaio1 && \
    curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm && \
    curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-sqlplus-12.1.0.1.0-1.x86_64.rpm && \
    curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm && \
    alien -i oracle-instantclient*-basic-*.rpm && alien -i oracle-instantclient*-sqlplus-*.rpm && alien -i oracle-instantclient*-devel-*.rpm && \
    rm -f oracle-instantclient*.rpm && echo '/usr/lib/oracle/12.1/client64/lib' > /etc/ld.so.conf.d/oracle.conf && ldconfig

ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV PATH $PATH:$ORACLE_HOME/bin