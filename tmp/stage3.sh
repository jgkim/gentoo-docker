#!/bin/busybox sh

die() {
  echo "$@" 1>&2
  exit 1
}

base_url="http://distfiles.gentoo.org/releases/amd64/autobuilds"

latest_stage3=$(busybox wget -qO - "${base_url}/latest-stage3-amd64-nomultilib.txt" 2> /dev/null | busybox grep -v '#' | busybox awk '{print $1}')
stage3=$(busybox basename "${latest_stage3}")

busybox wget "${base_url}/${latest_stage3}" || die "Could not download the stage tarball"

sha512_digests=$(busybox wget -qO - "${base_url}/${latest_stage3}.DIGESTS" 2> /dev/null | busybox grep -A 1 'SHA512' | busybox grep "${stage3}$")
busybox echo "${sha512_digests}" | busybox sha512sum -cs || die "Checksum validation failed"

busybox tar -C / --exclude="./dev/*" --exclude="./etc/hosts" --exclude="./sys/*" --exclude="./proc/*" -xjf "${stage3}"

busybox rm -f "${stage3}"

busybox echo "Done with installing the stage tarball"