+++
draft = true
title = "Docker ABC"
subtitle = "A short, fun and explorative tutorial for developers"
date = "2017-03-12"
tags = ["docker", "devops"]
image = "/posts/2017-03-12-docker/container-vessel.jpg"
id = "abcde"
url = "abcde/docker-abc"
aliases = ["abcde"]
+++

- Run scripts in well defined environment
- Starting containers is cheap (in comparison to a VM)

## Install docker

## Hello World

Let’s make our firsts steps and execute the most trivial thing that you probably want to try in every new technology: A “Hello World” programm.[^1]

```bash
$ docker run alpine echo "Hello World"
Hello World
```

The output of this command may not seem very exciting at the first glance, but there are a few interesting things going on under the hood:

1. `docker run` spawns a Docker container
2. `alpine` is the image name that is loaded into the container
3. `echo "Hello World"` is the command that gets executed within the container
4. The output is streamed back to the host system (that’s why you see it in your terminal)

## “Run, Docker, run!”

## Images

An image consists of a filesystem and other configuration that specify the environment for a container. I chose the Alpine Linux image for this tutorial, because it is a very lightweight image that contains everything we need for running simple commands. Of course, we can try and rerun the same command in a other images, for instance in a different Linux distribution:

```bash
$ docker run ubuntu echo "Hello World"
Hello World
$ docker run debian echo "Hello World"
Hello World
```

Every image is configured to have an entrypoint. All arguments are passed to the entrypoint of the container. All the images that we have used so far had the same entrypoint: `sh -c`, which means that the arguments are evaluated by the shell of the container. Of course the image can be configured to have other entrypoints as well.

Images are immutable – they cannot be changed once they have been created. When you want to build your own image, you have the following options:

- Write a **Dockerfile**: The Dockerfile contains instructions to create a new image and also defines the interface for ports and volumes.
- **Commit** a container: With `docker commit` you can extract the state of a container on the fly as new image.

## Containers

A container is the running instance of an image and provides the runtime in which a command or programm is executed. This is the container lifecycle when we call `docker run`:

1. A fresh new container gets created, based on the specified image
2. It gets started and the arguments are passed to the entrypoint
3. 
4. When the execution is finished or gets terminated from outside (with `ctrl+c`) the container is stopped

You can see all your containers with `docker ps`:

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

However, this only lists containers that are currently running, so we need to pass the `-a` option to see all stopped containers as well:

```bash
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                    PORTS               NAMES
1f324e2fb7b5        alpine              "echo 'Hello World'"   2 seconds ago       Exited (0) 1 second ago                       amazing_dubinsky
480c167b2e66        ubuntu              "echo 'Hello World'"   14 seconds ago      Exited (0) 13 seconds ago                     nostalgic_einstein
cc7168e0d60e        debian              "echo 'Hello World'"   27 seconds ago      Exited (0) 28 seconds ago                     gifted_lewin
```

You can remove containers with `docker rm`. You can either pass a single container id or a list of ids:

```bash
$ docker rm 1f324e2fb7b5
1f324e2fb7b5
```

Copy and pasting the container ids may be a bit inconvenient, especially when you want to delete **all** containers. For this case we can use the `docker ps -aq` command and combine them.

```bash
$ docker rm $(docker ps -aq)
480c167b2e66
cc7168e0d60e
```

## Volumes

A volume is a storage that can be attached to a container. It has it’s own lifecycle that is independent from containers and images. Volumes are stateful and mutable

- Folder from host system
- Volumes that other containers expose
- Dedicated volume


[^1]: If you run this for the very first time, the output might look a bit different, because Docker needs to download the image first.
