#!/bin/bash

PATH="${PATH}:/usr/sbin"

for blkdev in $( nvme list | awk '/^\/dev/ { print $1 }' ) ; do
  mapping=$(nvme id-ctrl --vendor-specific "${blkdev}"| grep --perl-regexp --only-matching '(sd[b-z]|xvd[b-z])')
  if [[ "/dev/${mapping}" == /dev/* ]]; then
    ( test -b "${blkdev}" && test -L "/dev/${mapping}" ) || ln --symbolic "${blkdev}" "/dev/${mapping}"
  fi
done
