FROM ubuntu:latest

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Hack for initctl not being available in Ubuntu
#RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl

# Install Git, NodeJS and MongoDB
RUN apt-get update
RUN apt-get install -y git nodejs npm mongodb-10gen

# Create the MongoDB data directory
RUN mkdir -p /data/db

RUN git clone https://github.com/beesearch/bee-backend.git /bee-backend

# Install app dependencies
RUN cd /bee-backend; npm install

# Add script to run mongo and node
ADD ./start.js ./

EXPOSE 8080
ENTRYPOINT ["./start.js"]
