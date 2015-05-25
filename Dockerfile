FROM scratch
MAINTAINER James G. Kim <jgkim@jayg.org>
ADD . /
RUN /tmp/stage3.sh && rm -f /tmp/stage3.sh
CMD ["/bin/bash"]