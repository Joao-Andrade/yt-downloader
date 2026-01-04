#!/bin/bash

usage() { echo "Usage: $0 [-f <file with list of urls>] [-o <output directory>] [-a <youtube|spotify> (default: youtube)]" 1>&2; exit 1; }

a="youtube"

while getopts ":f:o:a:" i; do
    case "${i}" in
        f)
            f=${OPTARG}
            ;;
        a)
            a=${OPTARG}
            ;;
        o)
            o=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# If file path is not given
if [ -z "${f}" ]; then
    usage
fi

# if output folder is not given
if [ -z "${o}" ]; then
    usage
fi

# if provider is not youtube or spotify
if [ "${a}" != "youtube" ] && [ "${a}" != "spotify" ]; then
    echo "Error: Argument -a must be either 'youtube' or 'spotify'" 1>&2
    usage
fi

# if output directory does not exists
if [ ! -d "${o}" ]; then
    echo "Error: Directory ${o} does not exists."
    usage
fi

# Check if file with list of urls does not exists
if [ ! -f "${f}" ]; then
    echo "Error: File '${f}' not found." 1>&2
    exit 1
fi

echo "Processing file: ${f}"
echo "Provider: ${a}"
echo "Output folder: ${o}"

number=1
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    [[ -z "$line" ]] && continue
    echo "Processing URL ${number}: $line"
    number=$((number+1))
    echo "Executing: yt-dlp $line  -f 'ba' -P $o -x --audio-format mp3"
    yt-dlp "$line" -f 'ba' -P "$o" -o "%(title)s.%(ext)s" -x --audio-format mp3
done < "${f}"
