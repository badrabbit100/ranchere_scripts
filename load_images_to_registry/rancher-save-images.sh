#!/bin/bash
list="r.txt"
images="rancher-images.tar.gz"

usage () {
    echo "USAGE: $0 [--image-list rancher-images.txt] [--images rancher-images.tar.gz]"
    echo "  [-l|--image-list path] text file with list of images; one image per line."
    echo "  [-i|--images path] tar.gz generated by docker save."
    echo "  [-h|--help] Usage message"
}

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--images)
        images="$2"
        shift # past argument
        shift # past value
        ;;
        -l|--image-list)
        list="$2"
        shift # past argument
        shift # past value
        ;;
        -h|--help)
        help="true"
        shift
        ;;
        *)
        usage
        exit 1
        ;;
    esac
done

if [[ $help ]]; then
    usage
    exit 0
fi

pulled=""
while IFS= read -r i; do
    [ -z "${i}" ] && continue
    if docker pull "${i}" > /dev/null 2>&1; then
        echo "Image pull success: ${i}"
        pulled="${pulled} ${i}"
    else
        if docker inspect "${i}" > /dev/null 2>&1; then
            pulled="${pulled} ${i}"		
        else
            echo "Image pull failed: ${i}"
        fi
    fi
done < "${list}"

echo "Creating ${images} with $(echo ${pulled} | wc -w | tr -d '[:space:]') images"
docker save $(echo ${pulled}) | gzip --stdout > ${images}


