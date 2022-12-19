FROM debian:latest

RUN apt update && apt install redis-server nginx python3 openssh-server sudo -y

RUN mkdir -p /root/.ssh && \
      echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOewr+pefZ/T6ao+dpqdigsDqjEWYf3ZB0UAzjUE6P4 deploy" >> /root/.ssh/authorized_keys

COPY startup.sh /
EXPOSE 22
EXPOSE 12000
CMD ["/bin/bash","/startup.sh"]
