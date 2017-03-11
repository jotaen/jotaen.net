+++
draft = true
title = "Docker ABC"
subtitle = "A short, fun and explorative tutorial for software developers"
date = "2017-03-12"
tags = ["docker", "devops"]
image = "/posts/2017-03-12-docker/container-vessel.jpg"
id = "nQ7yq"
url = "nQ7yq/docker-tutorial-for-developers"
aliases = ["nQ7yq"]
+++

- Run scripts in well defined environment
- Starting containers is cheap (in comparison to a VM)

If you don’t have Docker installed yet, grab the [latest community edition](https://www.docker.com/get-docker) for the platform that you use.

## Hello World

Let’s make our firsts steps and execute the most trivial thing that you probably want to try in every new technology: A “Hello World” programm.[^1]

```bash
$ docker run alpine echo "Hello World"
Hello World
```

The output of this command may not seem very exciting at the first glance, but there are a few interesting things going on under the hood:

1. `docker run` spawns a Docker container
2. `alpine` is the name of the image that we want to load into the container
3. `echo "Hello World"` is the command that we want to execute
4. The output of the command is streamed back to the host system (that’s why you see it in your terminal)

Although this example is fairly trivial, we already made a breakthrough and got in touch with the most important Docker entities: Images and containers.

# Docker entities

## Images

An image consists of a filesystem and other configuration that specify the environment for a container. I chose the Alpine Linux image for this tutorial, because it is very lightweight and contains everything we need for running simple commands. Of course, we can try and rerun the same command in a other images, for instance in a different Linux distribution:

```bash
$ docker run ubuntu echo "Hello World"
Hello World
$ docker run debian echo "Hello World"
Hello World
```

Docker images have an entrypoint that is invoked when the container is started. All the arguments that we specify in `docker run` after the image name are called “command” and passed to this entrypoint. Unless the image doesn’t specify a particular entrypoint[^2] the default entrypoint is `/bin/sh -c`. That means that our command is evaluated by the shell of the container.

Images are immutable – they cannot be changed once they have been created. When you want to build your own image, you can use the following ways:

- Write a **Dockerfile**: The Dockerfile contains instructions to create a new image and also defines the interface for ports and volumes.
- **Commit** a container: With `docker commit` you can extract the state of a container on the fly as new image.

## Containers

A container is the running instance of an image and provides the runtime in which a command or programm is executed. When we use `docker run`, this is the container lifecycle:

1. A fresh new container gets created, based on the specified image
2. It gets started and the arguments are passed to the entrypoint
3. 
4. When the execution is finished or gets terminated from outside (with `ctrl+c`) the container is stopped

You can see all your containers with `docker ps`:

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

However, this only lists containers that are currently running, so we need to pass the `-a` (“all”) option to see the stopped containers as well:

```bash
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                    PORTS               NAMES
1f324e2fb7b5        debian              "echo 'Hello World'"   2 seconds ago       Exited (0) 1 second ago                       amazing_dubinsky
480c167b2e66        ubuntu              "echo 'Hello World'"   14 seconds ago      Exited (0) 13 seconds ago                     nostalgic_einstein
cc7168e0d60e        alpine              "echo 'Hello World'"   27 seconds ago      Exited (0) 28 seconds ago                     gifted_lewin
```

You can remove containers with `docker rm` and pass it one or multiple ids:

```bash
$ docker rm 1f324e2fb7b5
1f324e2fb7b5
```

However, copy &amp; pasting the container ids may be a bit inconvenient, especially when you want to delete a lot or even all containers. For this case you can combine `docker rm` with `docker ps -q`:

```bash
$ docker rm $(docker ps -aq)
480c167b2e66
cc7168e0d60e
```

You often know upfront that you don’t want to use your container anymore after it has been stopped. Therefore you can instruct Docker to automatically take care of the deletion with the `--rm` option:

```bash
$ docker run --rm alpine echo "Hello World"
Hello World
```

## Volumes

A volume is a storage that can be attached to a container. It has it’s own lifecycle that is independent from containers and images. Volumes are stateful and mutable

- Folder from host system
- Volumes that other containers expose
- Dedicated volume

# “Run, docker, run!”

Now that we learned a 


[^1]: If you run this for the very first time, Docker automatically fetches the images from Docker Hub. You can explicitly do this with `docker pull`.

[^2]: The entrypoint can also be overwritten from the outside with the `--entrypoint` option