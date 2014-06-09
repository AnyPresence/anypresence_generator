FROM anypresence/generator:0.0.1
MAINTAINER Jeff Bozek, jbozek@anypresence.com

# Install library dependencies
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install libdbd-freetds freetds-dev unixodbc-dev libmysqlclient18 libmysqlclient-dev postgresql-client-9.3 postgresql-9.3 postgresql-server-dev-9.3 libpq-dev mongodb

# Install Oracle Instant Client
RUN apt-get -y install alien libaio1
RUN curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
RUN curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-sqlplus-12.1.0.1.0-1.x86_64.rpm
RUN curl -O https://s3.amazonaws.com/anypresence-generators/api/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm
RUN alien -i oracle-instantclient*-basic-*.rpm
RUN alien -i oracle-instantclient*-sqlplus-*.rpm
RUN alien -i oracle-instantclient*-devel-*.rpm
RUN rm -f oracle-instantclient*.rpm
RUN echo '/usr/lib/oracle/12.1/client64/lib' > /etc/ld.so.conf.d/oracle.conf
RUN ldconfig
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV PATH $PATH:$ORACLE_HOME/bin