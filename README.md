# RHEL container

This project builds a **personal** RHEL container image (ie. Docker) for x86-64.

> **Disclaimer**: This is not an endorsed or official Red Hat project. There is
> no guarantee or support. You are very much on your own using this.

If you want to run RHEL images you are encouraged to check [Project
Atomic](https://www.projectatomic.io/).

## Build

Requirements:

  * Docker (any moderately recent release should be ok)
  * A [Red Hat Developers account](https://developers.redhat.com/) for building
    the base RHEL image, or any other RHEL subscription if you have one.

> **Note**: the image you will be building should **NOT** be published, as it contains a subscription to your account.

Please check the section about [build issues](#build-issues) should you find any
problem with the build process.

### Red Hat Enterprise Linux

Fill in the `RHEL_SUB_USER` and `RHEL_SUB_PASSWD` below and run:

```shell
$ make RHEL_SUB_USER=user@example.com RHEL_SUB_PASSWD=mypasswd rhel
```

If you want to build from a RHEL image that is not the latest relase, you will
have to change the `FROM` line in the relevant Dockerfile.

#### Building under RHEL

Note that Red Hat's version of Docker incorporates patches to allow containers
to reuse the host's subscription. If this is the case and you wish to reuse them,
invoke the build process with `ON_RHEL_HOST=1`.

### Software Collections Library

A RHEL image with Red Hat Software Collections Library can also be build atop
the base RHEL image. Build it with:

```shell
$ make RHEL_SUB_USER=user@example.com RHEL_SUB_PASSWD=mypasswd scl
```

You can add the EPEL repo by specifying `EPEL_ENABLE=1` in the command above.

### Build issues

#### Subscription Manager takes a long time to execute and ends up failing

If you have lots of subscriptions the manager can take quite a while to run, and
it could be the case you would even see it failing to subscribe and register to
your RHSM account. Always keep an eye on your RHSM subscription status, and
everything else being ok just try again, as sometimes it will take a few tries
to make it work.

#### Subscription Manager cannot execute inside a container

Unfortunately in some instances the subscription manager will refuse to execute
inside a container (most likely due to the Red Hat Docker fork detecting RHSM is
being used). If this happens you should create a tarball (.tar.gz) of the
contents of /etc/pki/entitlement and /etc/pki/consumer of a successfully
subscribed and registered RHEL machine (you can do this with a RHEL ISO image
and a VM).

Once you have that tarball, you should place it in any subdirectory of
`rhel-base` and invoke the build process setting the variable `ENTITLEMENTS` to
_the relative path from rhel-base to the tarball file_. For example, if you placed
the tarball `entitlements.tar.gz` under `rhel-base`, you'd invoke:

> $ make ENTITLEMENTS=./entitlements.tar.gz build

## Deleting the image

Keep in mind that your RHEL image will have a subscription. In addition to not
sharing the image, removing the subscription is advised before deleting it,
since not doing so will keep the registered host/container in RHSM.

You have a convenience target for this task, `make implode`. This target will
remove containers (losing whatever changes you had there) and the image once it
removes your subscription.

Note that you might have multiple images deriving from a RHEL base, but you only
need to unsubscribe _one_ of the images, since they all have the same
subscription.

## Running

You can use a convenience target for running a container:

```shell
$ make run
```

This will try to reuse an existing container so that your changes remain. If you
want to remove the container, you have other convenience targets such as
`rm-container`, `stop-container` and `kill-container` inside each image's
directory.

You also have `make run-scl` for the Software Collections Library image.
