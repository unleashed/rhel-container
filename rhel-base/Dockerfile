FROM registry.access.redhat.com/rhel

MAINTAINER Alejandro Martinez Ruiz <amr@redhat.com>

# Mandatory arguments are user and password for Red Hat subscription.
ARG RHEL_SUB_USER
ARG RHEL_SUB_PASSWD

# Optional arguments

# If set to any non empty value, it will avoid trying any special handling of
# subscriptions, as it will assume they will be injected into the image (as Red
# Hat's Docker fork does) based on the current entitlements of the host.
ARG ON_RHEL_HOST=

# If set to any non empty value, and ON_RHEL_HOST is empty, it will extract the
# referred to tarball file, which should include the Red Hat's entitlement keys
# including the full path hierarchy (ie. will be extracted to /, and you can
# usually find these under /etc/pki/{entitlement,consumer}). Note that this file
# should live somewhere in the context where this image is being built in,
# typically the same directory as this Dockerfile.
ARG ENTITLEMENTS=

# A one-arg COPY will just send the context over, so we can delete this dir
# unconditionally later on.
COPY ${ENTITLEMENTS} /tmp/entitlements/

RUN if [ "x${ON_RHEL_HOST}" = "x" ] ; then \
      if test "x${ENTITLEMENTS}" != "x"; then \
        tar xvzf "/tmp/entitlements/$(basename ${ENTITLEMENTS})" -C /; \
      else \
        (subscription-manager unregister || true) \
        && subscription-manager clean \
        && echo "Subscribing (takes a while)" \
        && subscription-manager register --auto-attach \
          --username=${RHEL_SUB_USER} --password=${RHEL_SUB_PASSWD} ; \
      fi \
    fi \
 && rm -rf /tmp/entitlements

RUN RHEL_MAJOR=$(set -euo pipefail; cat /etc/redhat-release | \
      sed -E -e 's/.*release\s+([0-9]+).*/\1/') \
 && echo "Enabling repositories for ${RHEL_MAJOR}" \
 && yum repolist --disablerepo=\* 2> /dev/null \
 && yum-config-manager --disable \* &> /dev/null \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-rpms \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-optional-rpms \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-extras-rpms \
 && yum-config-manager --save --setopt=\*.tsflags=nodocs \
 && echo "Installing base packages" \
 && INSTALL_PKGS="bsdtar \
    findutils \
    gettext \
    tar \
    unzip \
    yum-utils" \
 && yum install -y --setopt=tsflags=nodocs ${INSTALL_PKGS} \
 && rpm -V ${INSTALL_PKGS} \
 && yum clean all -y \
 && rm -rf /var/cache/yum

CMD /bin/bash
