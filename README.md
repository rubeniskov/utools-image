# utools-image

* __Language__: `Shell`
* __Version__: `1.0.0`
* __OS__: `MacOS`, `Linux`

## Description
Some function tools to handle image sources

## Usage

- __fn_image__
```shell
Usage: image <command> [options ...]
  Commands:
    create                            create image
    mount                             mount a image into a specific path
    umount                            unmount a device from specefic path

  Options:
    -h | --help <volname>             show this message
```
- __fn_image_create__
```shell
Usage: image create <image>
  Options:
    -v | --volname <volname>          name of mount device (Default untitled)
    -s | --size                       size of image (Default 8GB) 
    -t | --type <type>                image type format (Default SPARSE)
    -v | --verbose                    show info messages
    -d | --debug                      show extra info
    -q | --quiet                      silent all messages
```

- __fn_image_mount__
```shell
Usage: image mount  <image>
  Options:
    -m | --mount-point=<path>         mount at <path> instead of inside /Volumes in OSX or /mnt in UNIX
    -v | --verbose
    -d | --debug
    -q | --quiet
```

 - __fn_image_umount__
```shell
Usage: ${__cmd} umount <devname>/<path/volname>
  Options:
    -v | --verbose
    -d | --debug
    -q | --quiet
```

## Style Guide

 [Style guide](https://google.github.io/styleguide/shell.xml)

## Status codes
 - `0` success
 - `1` critical
 - `2` error
 - `3` warning
 - `4` notice
 - `5` info
 - `6` debug

## Authors:
- Rubén López Gómez https://github.com/rubeniskov)

##License 
* Licensed under MIT
* Copyright (c) 2015 rubeniskov <rubeniskov@gmail.com> (https://github.com/rubeniskov)
