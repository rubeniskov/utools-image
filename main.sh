#!/bin/bash
# #Image
# 
# * __Language__: `Shell`
# * __Version__: `1.0.0`
# * __OS__: `MacOS`, `Linux`
# 
# ##Description
# Some function tools to handle image sources
# 
# ## Usage
# 
# - __fn_image__
# ```shell
# Usage: image <command> [options ...]
#   Commands:
#     create                            create image
#     mount                             mount a image into a specific path
#     umount                            unmount a device from specefic path
# 
#   Options:
#     -h | --help <volname>             show this message
# ```
# - __fn_image_create__
# ```shell
# Usage: image create <image>
#   Options:
#     -v | --volname <volname>          name of mount device (Default untitled)
#     -s | --size                       size of image (Default 8GB) 
#     -t | --type <type>                image type format (Default SPARSE)
#     -v | --verbose                    show info messages
#     -d | --debug                      show extra info
#     -q | --quiet                      silent all messages
# ```
# 
# - __fn_image_mount__
# ```shell
# Usage: image mount  <image>
#   Options:
#     -m | --mount-point=<path>         mount at <path> instead of inside /Volumes in OSX or /mnt in UNIX
#     -v | --verbose
#     -d | --debug
#     -q | --quiet
# ```
# 
#  - __fn_image_umount__
# ```shell
# Usage: ${__cmd} umount <devname>/<path/volname>
#   Options:
#     -v | --verbose
#     -d | --debug
#     -q | --quiet
# ```
# 
# ##Style Guide
# 
#  [Style guide](https://google.github.io/styleguide/shell.xml)
# 
# ##Status codes
#  - `0` success
#  - `1` critical
#  - `2` error
#  - `3` warning
#  - `4` notice
#  - `5` info
#  - `6` debug
# 
# ##Authors:
# - Rubén López Gómez https://github.com/rubeniskov)
# 
# ##License 
# * Licensed under MIT
# * Copyright (c) 2015 rubeniskov <rubeniskov@gmail.com> (https://github.com/rubeniskov)

__shell="$_"
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__cmd="$(basename "${BASH_SOURCE[0]}")"
__file="${__dir}/${__cmd}"

set -o nounset

read -r -d '' us_image <<-EOF
Usage: ${__cmd} <command> [options ...]
  Commands:
    create                            create image
    mount                             mount a image into a specific path
    umount                            unmount a device from specefic path

  Options:
    -h | --help <volname>             show this message
EOF

function fn_image() {
  local cmd

  while [[ $# > 0 ]]; do
    case $1 in
      create)
        shift
        fn_image_create $@ 
      ;;
      mount)
        shift
        fn_image_mount $@
      ;;
      umount)
        shift
        fn_image_umount $@
      ;;
      -h|--help)
        fn_image_usage "$us_image"
      ;;
      *)
        echo "Unknown option $1" 1>&2
        fn_image_usage "$us_image"
      ;;
    esac
    shift
  done
}

read -r -d '' us_image_create <<-EOF
Usage: ${__cmd} create <image>
  Options:
    -v | --volname <volname>          name of mount device (Default untitled)
    -s | --size                       size of image (Default 8GB) 
    -f | --filesystem <type>          image type format (Default SPARSE)
    -t | --type <type>                image type format (Default SPARSE)
      SPARSEBUNDLE    - disc image dynamic package
      SPARSE          - dynamic disc image
      UDIF            - imagen de disco de lectura/escritura
      UDTO

    -v | --verbose                    show info messages
    -d | --debug                      show extra info
    -q | --quiet                      silent all messages
EOF

function fn_image_create() {
  local image=$1; shift
  local args=$@
  local defaults=(
    "--volname untitled"
    "--size 8GB"
    "--format SPARSE"
    "--format SPARSE"
    -fs JHFS+X
  )
  local args=$@
  local cargs=(
    "-volname untitled"
    "-size 8GB"
    "-format SPARSE"
    "-fs JHFS+X"
  )
    # UDRO - sólo lectura
    # UDCO - comprimido (ADC)
    # UDZO - comprimido
    # UDBZ - comprimido (bzip2)
    # UFBI - todo el dispositivo
    # IPOD - Imagen del iPod
    # UDxx - Fragmento UDIF
    # UDSB - sparsebundle
    # UDSP - dinámica
    # UDRW - lectura/escritura
    # UDTO - DVD/CD maestro
    # DC42 - Disk Copy 4.2
    # RdWr - NDIF lectura/escritura
    # Rdxx - NDIF sólo lectura
    # ROCo - NDIF comprimida
    # Rken - NDIF comprimida (KenCode)
    # UNIV - imagen híbrida (HFS+/ISO/UDF)
    # SPARSEBUNDLE - imagen de disco de paquete dinámico
    # SPARSE - imagen de disco dinámica
    # UDIF - imagen de disco de lectura/escritura
    # UDTO - DVD/CD maestro
  if [ -f "${image}" ]; then
    echo "${__cmd}: Image ${image} already exists" 1>&2
    exit 2
  fi

  while [[ $# > 0 ]]; do
    case $1 in
      -v|--volname)
        args[0]="-volname $2"
        shift
      ;;
      -s|--size)
        args[1]="-size $2"
        shift
      ;;
      -f|--format)
        args[2]="-type $2"
        shift
      ;;
      -v|--verbose)
        args+="-verbose"
      ;;
      -d|--debug)
        args+="-debug"
      ;;
      -q|--quiet)
        args+="-quiet"
      ;;
      -h|--help)
        fn_image_usage "$us_image_create"
      ;;
      *)
        echo "${__cmd}: Unknown option $1" 1>&2
        fn_image_usage "$us_image_create"
      ;;
    esac
    shift
  done

  case "$(uname -s)" in
    "Darwin")
      args+="-nospotlight"
      ;;
    *)        
  esac

  # hdiutil create $image ${args[@]} 1>&2

  echo $?
  
  exit 0
}

read -r -d '' us_image_mount <<-EOF
Usage: ${__cmd} mount  <image>
  Options:
    -m | --mount-point=<path>         mount at <path> instead of inside /Volumes in OSX or /mnt in UNIX
    -v | --verbose
    -d | --debug
    -q | --quiet
EOF

function fn_image_mount() {
    local image_name=$1
    local mount_point=$2

    if [ ! -d "${mount_point}" ]; then 
        fn_exec hdiutil attach "${image_name}.sparseimage" \
            -mountroot $(dirname mount_point) && fn_debug_ok $(fn_exec_get 1)
    else
        fn_debug_ok "Image ${mount_point} already mounted"
    fi

    echo $mount_point
}

read -r -d '' us_image_unount <<-EOF
Usage: ${__cmd} umount <devname>/<path/volname>
  Options:
    -v | --verbose
    -d | --debug
    -q | --quiet
EOF

function fn_image_unount() {
    local mount_point=$1

	if [ -d "${mount_point}" ]; then 
        fn_exec hdiutil detach $mount_point \
        	&& fn_debug_ok $(fn_exec_get 1)
    else
        fn_debug_ok "Image ${mount_point} already unmounted"
    fi
}

function fn_image_usage() {
  echo "" 1>&2
  echo "${1}" 1>&2
  echo "" 1>&2
  exit 1   
}

[[ "${__shell}" = /bin/bash* ]] && fn_image $@