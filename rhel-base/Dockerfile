FROM registry.access.redhat.com/rhel

MAINTAINER Alejandro Martinez Ruiz <amr@redhat.com>

# Mandatory arguments are user and password for Red Hat subscription.
ARG RHEL_SUB_USER
ARG RHEL_SUB_PASSWD

RUN (subscription-manager unregister || true) \
 && subscription-manager clean \
 && echo "Subscribing (takes a while)" \
 && subscription-manager register --auto-attach \
    --username=${RHEL_SUB_USER} --password=${RHEL_SUB_PASSWD}

RUN RHEL_MAJOR=$(set -euo pipefail; cat /etc/redhat-release | \
      sed -E -e 's/.*release\s+([0-9]+).*/\1/') \
 && echo "Enabling repositories for ${RHEL_MAJOR}" \
 && yum repolist --disablerepo=\* 2> /dev/null \
 && yum-config-manager --disable \* &> /dev/null \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-rpms \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-optional-rpms \
 && yum-config-manager --enable rhel-${RHEL_MAJOR}-server-extras-rpms \
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
