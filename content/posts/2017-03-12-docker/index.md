+++
title = "Docker ABC"
subtitle = "A short, fun and explorative tutorial for software developers"
date = "2017-03-12"
tags = ["devops"]
image = "/posts/2017-03-12-docker/container-vessel.jpg"
id = "nQ7yq"
url = "nQ7yq/docker-tutorial-for-developers"
aliases = ["nQ7yq"]
+++

I remember me being slighty overwhelmed back in the day when I started to use Docker. Its idea sounded simple and the sales pitch was convincing, but I had difficulties to find a starting point, even though I was already familiar with Vagrant at that time.

This blogpost is a tutorial in which I’ll walk you through the basics of Docker. It is aimed at people who have no or just rudimentary experience with Docker so far. The goal is that you understand the concepts behind it and are able to use Docker for some simple use cases like starting third party services or running scripts.

The thing is, you don’t really have to know *everything* about Docker in order to take advantage of it. Docker is a very powerful tool with an enormous and vibrant ecosystem around it. However, it’s not solely aimed at DevOps engineers. You don’t need to worry about how to orchestrate distributed applications or how to setup sophisticated build and deploy pipelines. It can already be sufficient to just learn about local container management. Once you are into it, you can dive deeper and start to improve your daily development workflow – even if you don’t actually use Docker in production:

- You can run external services like databases or message brokers in encapsulated containers without needing to install all these services on the host machine
- You can work on multiple software projects in parallel without needing to switch language or system library versions
- You can easily maintain and provide a production-like environment for executing your programm locally

Basically, Docker behaves the same way as a virtual machine. But instead of bundling an entire operating system it directly uses the kernel of the host system and encapsulates just the infrastructure that is specific for a particular container. Therefore, both resource usage and startup times are orders of magnitude lower compared to VMs.

One general tip upfront when working with the docker command line: If you get stuck, there is a `--help` option for all subcommands, e.g. `docker images --help`. Other than that, Docker provides excellent [documentation](https://docs.docker.com/engine/reference/commandline/cli/) for the cli with more in-depth explanations.

## Hello World

If you don’t have Docker installed yet, grab the [latest version](https://www.docker.com/get-docker) for the platform that you use – it should work out of the box without further configuration. Let’s make our firsts steps and execute the most trivial thing that you probably want to try out in every new technology: A “Hello World” programm:[^1]

```bash
$ docker run alpine echo "Hello World"
Hello World
```

The output of this command may not seem very exciting at the first glance, but there are a few interesting things going on under the hood:

1. `docker run` spawns a Docker container
2. `alpine` is the name of the image that we want to load into the container
3. `echo "Hello World"` is the command that we want to execute inside of the container
4. The output of the command is streamed back to the host system (that’s why you see it in your terminal)

Although this example is fairly trivial, we already made a breakthrough and got in touch with the most important Docker entities: images and containers. So, let’s have a deeper look.

# Docker entities

## Images

An image is a template for a container and consists of a filesystem and other configuration that specify the environment for a container. In this tutorial we use the [Alpine Linux](https://alpinelinux.org/) image, because it is very lightweight and contains everything we need to run our commands. Of course, we can try and rerun the same command in a other images, for instance in a different Linux distribution:

```bash
$ docker run ubuntu echo "Hello World"
Hello World
$ docker run debian echo "Hello World"
Hello World
```

Docker images have an entrypoint that is invoked when the container is started. All the arguments that we specify in `docker run` after the image name are called “command” and passed to this entrypoint. Unless the image doesn’t specify a particular entrypoint it falls back to the default: `/bin/sh -c`. That means our command is evaluated by the shell of the container in the same fashion as when we would run it on our host computer.

Usually you come pretty far with the (official) images provided on [Docker Hub](https://hub.docker.com/)[^2]. However, if you want customization, you need to build your own one. These are the most common ways to do this:

- Write a [**Dockerfile**](https://docs.docker.com/engine/reference/builder/): The Dockerfile contains instructions to create a new image and also defines the interface for ports and volumes.
- **Commit** a container: With `docker commit` you can capture the state of a container as new image “on the fly”.

## Containers

A container is the running instance of an image and provides the runtime in which a command is executed. Here is the container lifecycle when we execute `docker run`:

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

Since creating containers is usually fast, you often use them just a single time and throw them away afterwards. In order to remove containers we call `docker rm` and pass it one or multiple ids:

```bash
$ docker rm 1f324e2fb7b5
1f324e2fb7b5
```

Copy &amp; pasting the container ids may be a bit inconvenient, especially when we want to delete a lot or even all containers. For this case we can combine `docker rm` with `docker ps -q`[^3]:

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

### Interactive mode

Sometimes it can be handy to establish a ssh-like connection into a container to have a look around there. This is what the interactive mode is for – we can start a new container in the interactive mode or connect to a currently running container:[^4]

```bash
$ docker run -it alpine sh
>
```

When you are done, you can close the session with `exit`.

## Volumes

Data volumes can be mounted into a container in order to persist data independently from the container or image lifecycle. Instead of reusing containers, volumes are the prefered way to share, persist and exchange state.

### Folders from the host system
In order to get files from the host system into a container we can mount folders as data volume with the `-v` option:

```bash
$ # Create new folder + file on host system:
$ mkdir hello && touch hello/world.txt
$ # Mount local `hello` folder to `/example` in container:
$ docker run -v $(pwd)/hello:/example alpine ls /example
world.txt
```

Two things are important when mounting a host system folder:

- Paths must always be absolute (that’s why we use `$(pwd)` here)
- If there is already a folder existing at the mount point, the mounted volume would just “overlay” this container folder. However, this doesn’t apply for the other mounting methods!

### Dedicated volumes
We can also create a Docker volume as a separate entity and attach it to the container by referencing its name or id:[^5]

```bash
$ # Create new volume with name `my-demo-volume`
$ docker volume create my-demo-volume
my-demo-volume
# Mount our new volume and create a file in it:
$ docker run -v my-demo-volume:/home alpine touch /home/hello.txt
# Create new container and list content of volume:
$ docker run -v my-demo-volume:/files alpine ls /files
hello.txt
```

Dedicated volumes have their own lifecycle and can be managed with the `docker volumes` subcommands.

### Volumes from another container
It’s also possible to mount all volumes from another container. This technique is referred to as “data containers”:

```bash
$ # Declare `/home` as volume of a container named `foobar`:
$ docker run -v /home --name foobar alpine touch /home/hello.txt
$ # Mount all volumes from container `foobar` into new container:
$ docker run --volumes-from foobar alpine ls /home
hello.txt
```

# Wrapping it up

The cool thing is: everything we’ve learned so far about Docker empowers us already to achieve useful things. Let’s consider three real world use cases.

## Run a script

Let’s create a simple JavaScript application and run it in a container:

```bash
$ echo 'console.log("Hello NodeJS World")' > index.js
$ docker run --rm -v $(pwd):/app:ro -w /app node:7 node index.js
Hello NodeJS World
```

1. `docker run` starts a new container.
2. `--rm` tells Docker to delete the container afterwards (transient mode)
3. `-v $(pwd):/app:ro` mounts the current host working directory to `/app` in the container. The volume is readonly, because we don’t want anything to be mutated here.
4. `-w /app` sets the working directory inside the container to `/app`.
5. `node:7` uses the image with the name `node` that is tagged with `7` (because we want to use NodeJS version 7 here).
6. `node index.js` is the command that should be executed in the container. It outputs `Hello NodeJS World`.

## Start a third party service

We can start a database that we want to utilize for development purpose:

```bash
$ docker volume create mongodata
mongodata
$ docker run --rm -p 27017:27017 -v mongodata:/data/db -d mongo
80fb1588c7454619b91db7ff59c95f16b5ea230e4182c625d45f45081e7524eb
```

1. `docker run --rm` starts a transient container.
2. `-p 27017:27017` is a port mapping. It binds the host port `27017` to the container port `27017`. If we wouldn’t do this, we couldn’t access the port from outside of the container.
3. `-v mongodata:/data/db` mounts our previously created volume to `/data/db` in the container. (This is the place where MongoDB stores all the data.)
4. `-d` detaches the container, because it is a long running process that we want to run in the background.
5. `mongo` uses the image with name `mongo`. Since we don’t specify a tag, it defaults to `latest`.
6. The default command of the mongo image is `mongod`, which starts the mongo daemon. Because this is exactly what we want, we don’t need to specify our own command.
7. Since the process is detached, Docker returns the container id so that we can interact with the container later. In order to stop it we would use `docker stop`.

The only reason why we created a dedicated volume here is so that all the database content is persisted for later reuse. Of course, this is totally optional.

## Perform a build

I generate my blog with the static website generator Hugo, that’s why I use this command quite a lot:

```bash
$ docker run --rm -v $(pwd):/site -w /site publysher/hugo hugo
```

1. `docker run --rm` starts a transient container.
2. `-v $(pwd):/site` mounts the current host working directory to `/site` in the container.
3. `-w /site` sets the working directory in the container to `/site`
4. `publysher/hugo` uses the image with name `hugo` of the author `publysher` with tag `latest`.
5. `hugo` is the command we execute in the container. It automatically creates the folder `public` in the working directory and generates the static website assets there.

The reason why we didn’t need to specify the author in the previous examples is because `mongo` and `node` are [official repositories](https://docs.docker.com/docker-hub/official_repos/) that fullfill certain standards and security requirements.


[^1]: If you run this for the very first time, Docker automatically fetches the images from Docker Hub. You can also explicitly perform this step with `docker pull`.

[^2]: One important thing to understand about images is that they are immutable and cannot be changed once they have been created.

[^3]: We could also use `--filter` to search for specific containers

[^4]: When you want to connect to an already running container that wasn’t started in interactive mode, you can use `docker exec`.

[^5]: If the destination path is already existing in the image, all its content is copied to the volume when the container is started.
