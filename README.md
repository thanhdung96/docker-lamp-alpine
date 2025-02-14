## Docker with LAP stack based on Alpine Linux

- This docker image contain a LAP (Linux - Apache - PHP) stack installed from scratch and is heavily influenced by https://github.com/j1cs/alpine-lamp.
- The purpose of this image is to run a PHP application on bare minimum cloud compute engine (GCP, AWS, OpenStack, etc...) or even serverless.

## Installation
### Pull from DockerHub

```
docker pull thanhdung96/lap_stack_alpine
```

### Build your own image

```  
git clone git@github.com:thanhdung96/docker-lamp-alpine.git && cd docker-lamp-alpine.git/
```

### Build the image

```
docker build \
--build-arg PHP_VERSION=83 \
--build-arg TIMEZONE="Asia/Ho_Chi_Minh" \
--build-arg DOCUMENTROOT="/public" \
-t=thanhdung96/lap_stack_alpine:latest \
-f ./Dockerfile .
```

### Run it

```
docker run -p "8090:80" -v ${PWD}:/app:Z -d thanhdung96/lap_stack_alpine:latest
```

### Supported build arguments

- PHP_VERSION: the version of php to be installed in the image. No default value.
- TIMEZONE: specify the timezone the container will run with. Default "Asia/Ho_Chi_Minh"
- DOCUMENTROOT: the first directory the web server in the container will look into. Default "/", meaning  "/var/www/localhost/htdocs". The path will be appended after the default value.

### PHP versions

- Please have a quick research on what version of PHP is available on Alpine via https://pkgs.alpinelinux.org/packages
- In case there is an error with a specific package and/or version, please do not hesitate and open an issue at https://github.com/thanhdung96/docker-lamp-alpine/issues (every proposes and questions are welcomed).

## Links and References

- https://github.com/j1cs/alpine-lamp
- https://hub.docker.com/r/thanhdung96/lap_stack_alpine 
- https://github.com/thanhdung96/docker-lamp-alpine
- https://pkgs.alpinelinux.org/packages
