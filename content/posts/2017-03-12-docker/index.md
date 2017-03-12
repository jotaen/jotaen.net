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

I remember me being slighty overwhelmed back in the day when I started to use Docker. Its idea sounded simple and the sales pitch was convincing, but I had difficulties finding a starting point, even though I was already familiar with Vagrant.

The thing is, as a software developer you don’t really have to know *everything* about Docker in order to take advantage of it. Docker is a very powerful tool with an enormous and vibrant ecosystem around it, but it’s important to know that it is not solely aimed at DevOps engineers. You don’t need to worry about how to orchestrate distributed applications with Docker swarm or how to setup sophisticated build and deploy pipelines. When you just focus on understanding the fundamental concepts and learning the basic commands for the CLI, then this can be already sufficient to improve your local development workflow and make your daily life more convenient:

- You can work on multiple software projects without needing to switch language or system library versions
- You can run external services like databases or message brokers in encapsulated containers without needing to install all these services on the host machine

Basically, Docker behaves the same way as a virtual machine. But instead of bundling an entire operating system it directly uses the kernel of the host system and just encapsulates the infrastructure that is specific for a particular container. Therefore, both resource usage and startup times are orders of magnitude lower compared to VMs.

This blogpost provides a starting point for software developers. I wrote it up for people who don’t have any or just very little experience with Docker so far but want to learn how to use it.

One general tip upfront when working with the docker command line: If you get stuck, there is a `--help` option for all cli commands, e.g. `docker images --help`. Other than that, Docker provides excellent [documentation](https://docs.docker.com/engine/reference/commandline/cli/) for the cli with more in-depth explanations.

## Hello World

If you don’t have Docker installed yet, grab the [latest version](https://www.docker.com/get-docker) for the platform that you use – it should work out of the box without further configuration. Let’s make our firsts steps and execute the most trivial thing that you probably want to try out in every new technology: A “Hello World” programm.[^1]

```bash
$ docker run alpine echo "Hello World"
Hello World
```

The output of this command may not seem very exciting at the first glance, but there are a few interesting things going on under the hood:

1. `docker run` spawns a Docker container
2. `alpine` is the name of the image that we want to load into the container
3. `echo "Hello World"` is the command that we want to execute
4. The output of the command is streamed back to the host system (that’s why you see it in your terminal)

Although this example is fairly trivial, we already made a breakthrough and got in touch with the most important Docker entities: images and containers. So, let’s have a deeper look.

# Docker entities

## Images

An image is a template for a container and consists of a filesystem and other configuration that specify the environment for a container. In this tutorial we use the Alpine Linux image, because it is very lightweight and contains everything we need to run our commands. Of course, we can try and rerun the same command in a other images, for instance in a different Linux distribution:

```bash
$ docker run ubuntu echo "Hello World"
Hello World
$ docker run debian echo "Hello World"
Hello World
```

Docker images have an entrypoint that is invoked when the container is started. All the arguments that we specify in `docker run` after the image name are called “command” and passed to this entrypoint. Unless the image doesn’t specify a particular entrypoint it falls back to the default: `/bin/sh -c`. That means our command is evaluated by the shell of the container in the same fashion as when we would run it on our host computer.

Usually you come pretty far with the (official) images provided on [Docker Hub](https://hub.docker.com/)[^2]. However, if you need customization, you need to build your own one. These are the most common ways to do this:

- Write a [**Dockerfile**](https://docs.docker.com/engine/reference/builder/): The Dockerfile contains instructions to create a new image and also defines the interface for ports and volumes.
- **Commit** a container: With `docker commit` you can extract the state of a container on the fly as new image.

## Containers

A container is the running instance of an image and provides the runtime in which a command is executed. Here is the container lifecycle each time we execute `docker run`:

1. A fresh new container gets created, based on the specified image
2. The container is started; the command gets passed to the entrypoint and processed
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

Since starting containers is so cheap and fast, you mostly use them just a single time and throw them away afterwards. In order to remove containers we call `docker rm` and pass it one or multiple ids:

```bash
$ docker rm 1f324e2fb7b5
1f324e2fb7b5
```

However, copy &amp; pasting the container ids may be a bit inconvenient, especially when we want to delete a lot or even all containers. For this case we can combine `docker rm` with `docker ps -q`[^3]:

```bash
$ # This will delete ALL your containers:
$ docker rm $(docker ps -aq)
480c167b2e66
cc7168e0d60e
```

If we know upfront that we don’t want to use our container later on, we can instruct Docker to automatically take care of the deletion with the `--rm` option. That way the container is transient and automatically removed after it is stopped.

```bash
$ docker run --rm alpine echo "Hello World"
Hello World
```

## Volumes

We can use volumes in order to share data between containers or between container and host system. A volume is a storage that can be attached to a container. It has it’s own lifecycle that is independent from containers and images. Volumes are stateful and mutable.

- Folder from host system
- Volumes that other containers expose
- Dedicated volume

# “Run, docker, run!”

- Docker run interactive mode
- Port mapping
- The entrypoint can also be overwritten from the outside with the `--entrypoint` option
- Docker logs


[^1]: If you run this for the very first time, Docker automatically fetches the images from Docker Hub. You can explicitly do this with `docker pull`.

[^2]: One important thing to understand about images is that they are immutable and cannot be changed once they have been created.

[^3]: We could also use `--filter` to search for specific containers