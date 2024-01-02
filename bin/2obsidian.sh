#!/bin/bash
## Assumes this is run within Obsidian directory

## Based on:
## https://nextpertise.net/posts/230509_word2obsidian/

FROM_FILE="${1}"
FROM_FORMAT="${2}"
TO_FILE="$(date +%Y.%m.%d)_${FROM_FILE}.md"

echo "Converting file ${FROM_FILE} from format ${FROM_FORMAT}"

pandoc -wrap=none \
    --verbose \
    -f "${FROM_FORMAT}" \
    -t markdown \
    "${FROM_FILE}" \
    -o "${TO_FILE}"

pwd
this_dir=`pwd`

if [ -s "${TO_FILE}" ]; then
    convertedDir=$(echo "${this_dir}" | sed 's!\(Obsidian/[^/]*\).*!\1!')
    convertedDir="${convertedDir}/converted2md/"
    mkdir -p "${convertedDir}"
    
    echo "Moving  ${FROM_FILE} to ${convertedDir}."
    mv "${FROM_FILE}" "${convertedDir}"

else
    echo "Conversion to markdown failed."
fi

