# Gentoo Stage3 Docker Image

This is a docker image that only includes the contents of the stage tarball. The goal is to use this image as a basis to build a minimal Gentoo base image via using tools like [Packer](http://packer.io/). This image should not be layered in the base image to prevent bloating the size of the base image.