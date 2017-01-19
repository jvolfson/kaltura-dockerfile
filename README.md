# Dockerized Kaltura server

Docker image(s) containing a pre-configured Kaltura community edition server.


## Usage

1. Add `<your-docker-machine-ip> dockerhost` to `/etc/hosts`
2. Start docker container. You can choose from two images:
```bash
# Either pre-configured Kaltura server running at port 11010...
docker run -d --name kaltura-port-11010 -p 11010:11010 yleisradio/kaltura-dev:port-11010
# ...or running at port 11011...
docker run -d --name kaltura-port-11010 -p 11011:11011 yleisradio/kaltura-dev:port-11011
```

**ATTENTION:** It's very important that you set port forwarding to either
`11010:11010` or `11011:11011` and use `dockerhost` as your docker machine's
hostname. See below for more details.


## Why does this image exist?

In Yleisradio, we need to use Kaltura backend server in our local development
and CI builds. However, the official `kaltura/server` image requires developer to 
run the post-install step every time a new container is created. This leads to
long development environment setups and CI build times.

These images have all post-install steps executed, enabling fast CI builds
and local development environment setup.


## License 

AGPLv3

