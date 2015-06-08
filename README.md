# What is Gentoo?

Gentoo is a free operating system based on either Linux or FreeBSD that can be automatically optimized and customized for just about any application or need. Extreme configurability, performance and a top-notch user and developer community are all hallmarks of the Gentoo experience.

> [wikipedia.org/wiki/Gentoo_Linux](https://en.wikipedia.org/wiki/Gentoo_Linux)

![Gentoo Logo](https://raw.githubusercontent.com/jgkim/gentoo-docker/master/logo.png)

# About this image

Since Gentoo is a rolling release distribution, the `jgkim/gentoo-base` tag will always point the most recently built image. This image lacks build tools such as GCC, Binutils, Libtool, Autotools, etc. Thus, binary packages can only be emerged with this image. To build packages from source, the image tagged with `jgkim/gentoo-build` should be used. For example, you can build a pacakage called `banner` by using `docker run -ti --rm -v $HOME/packages:/usr/portage/packages jgkim/gentoo-build banner`. It is suggested to build packages in seperate containers, and then to emerge those binary packages in the base image for dockerizing.

You can find a reference Dockerfile and build details at [the Github repository](http://github.com/jgkim/gentoo-docker). This image has been built with the [Packer](http://packer.io/) template instead of the Dockerfile.

# Supported Docker versions

This image is officially supported on Docker version 1.6.2.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# User Feedback

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/jgkim/gentoo-docker/issues).
