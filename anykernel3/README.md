# AnyKernel3 package template

This directory packages the AOSP/LineageOS variant of ikun-NekoMake for the
Xiaomi 11 Pro (`mars`) and Xiaomi 11 Ultra (`star`). The kernel source is based
on LineageOS `lineage-23.2` and keeps the ROM's star QGKI configuration and
vendor-module ABI.

The installer performs a pure kernel swap and keeps the current boot ramdisk.
It caches Recovery-side device properties before `setup_env` mounts Android
partitions, preventing Xiaomi 11 Ultra recoveries from being misidentified as
`venus` after the mount step.

## Build

Build the kernel with the Lineage star configuration fragments, then run:

```sh
IMAGE=/path/to/arch/arm64/boot/Image ./anykernel3/build.sh
```

`IMAGE` may point to either `Image` or `Image.gz`; uncompressed images are
reproducibly compressed with `gzip -n`. The default input and output directory
are `out/arch/arm64/boot/Image` and `out/`. Override `OUT_DIR` or
`PACKAGE_NAME` when needed. Generated images and ZIP files are ignored.
