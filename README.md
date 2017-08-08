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
    the base RHEL image.

> **Note**: the image you will be building should **NOT** be published, as it contains a subscription to your account.

### Red Hat Enterprise Linux

Fill in the `RHEL_SUB_USER` and `RHEL_SUB_PASSWD` below and run:

```shell
$ make RHEL_SUB_USER=user@example.com RHEL_SUB_PASSWD=mypasswd rhel
```

If you want to build from a RHEL image that is not the latest relase, you will
have to change the `FROM` line in the relevant Dockerfile.

#### Building under RHEL

Note that Red Hat's version of Docker incorporates patches to allow containers
to reuse the host's subscription. This is not currently supported here, as the
build process will require the RHSM credentials.

### Software Collections Library

A RHEL image with Red Hat Software Collections Library can also be build atop
the base RHEL image. Build it with:

```shell
$ make RHEL_SUB_USER=user@example.com RHEL_SUB_PASSWD=mypasswd scl
```

You can add the EPEL repo by specifying `EPEL_ENABLE=1` in the command above.

### Build issues

The most usual problem is subscription-manager being unable to successfully
register and subscribe to your RHSM account. Just try again and always keep an
eye on your RHSM subscription status.

## Deleting the image

Keep in mind that your RHEL image will have a subscription. In addition to not
sharing the image, removing the subscription is advised before deleting it,
since not doing so will keep the registered host in RHSM.

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
