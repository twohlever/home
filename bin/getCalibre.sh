#!/bin/sh

URL='https://calibre-ebook.com/dist/osx' 
LOG="log.txt"
DL_PATH="/Users/theresawohlever/Library/CloudStorage/OneDrive-Personal/Software/Calibre"
origName=$(echo "${URL}" | sed 's!.*/!!')

echo "Download Path: ${DL_PATH}"
echo "URL: ${URL}"
echo "Downloaded Filename: ${origName}"

wget --output-file="${LOG}"   "${URL}"
dmgNAME=$(grep '.dmg$' "${LOG}" | sed 's!.*/calibre!calibre!') 

echo "New Filename: ${dmgNAME}" 

mv "${origName}" "${DL_PATH}/${dmgNAME}"
rm ${LOG}
