FROM library/perl

EXPOSE 42

RUN apt-get update && \
    apt-get -y install socat && \
    apt-get clean

CMD socat TCP-LISTEN:42,reuseaddr,fork,pktinfo EXEC:"/usr/local/sbin/memento --",pty

COPY memento.pl /usr/local/sbin/memento
COPY *.memento /usr/local/sbin/
