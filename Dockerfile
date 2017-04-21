FROM library/perl
RUN apt-get update && \
    apt-get -y install socat && \
    apt-get clean
COPY memento.pl /home/memento.pl
EXPOSE 81
CMD socat TCP-LISTEN:7878,reuseaddr,fork,pktinfo EXEC:"/home/memento.pl —",pty