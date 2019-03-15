FROM rhel-base

MAINTAINER Alejandro Martinez Ruiz <amr@redhat.com>

ARG EPEL_ENABLE=0

RUN RHEL_MAJOR=$(set -euo pipefail; cat /etc/redhat-release | \
      sed -E -e 's/.*release\s+([0-9]+).*/\1/') \
 && echo "Enabling repositories for RHEL ${RHEL_MAJOR}" \
 && yum-config-manager --enable rhel-server-rhscl-${RHEL_MAJOR}-rpms \
 && yum-config-manager --save --setopt=rhel-server-rhscl-${RHEL_MAJOR}-rpms.tsflags=nodocs \
 && if test "x${EPEL_ENABLE}" = "x1"; then \
      curl -s -L -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-${RHEL_MAJOR}.noarch.rpm \
      && rpm -ivh epel-release-latest-${RHEL_MAJOR}.noarch.rpm \
      && yum-config-manager --enable epel \
      && yum-config-manager --save --setopt=epel.tsflags=nodocs \
      && rm -f epel-release-latest-${RHEL_MAJOR}.noarch.rpm ; \
    fi \
 && echo "Installing packages" \
 && INSTALL_PKGS="scl-utils" \
 && yum install -y ${INSTALL_PKGS} \
 && rpm -V ${INSTALL_PKGS} \
 && yum clean all -y \
 && rm -rf /var/cache/yum

CMD /bin/bash
