FROM scratch

MAINTAINER James G. Kim <jgkim@jayg.org>

ADD . /

# Install a stage tarball and the Gentoo base system
RUN /tmp/stage3.sh && /tmp/base.sh && rm --force /tmp/*

# Create a mount point for binary packages
VOLUME ["/usr/portage/packages"]

CMD ["/bin/bash"]