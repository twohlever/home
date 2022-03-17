#!/bin/sh

#
# Prep the globals
#
HOME_DIR='/Users/theresawohlever'
AD_PIC_DIR="${HOME_DIR}/Amazon Drive/Pictures"
GIT_REPO_DIR="${HOME_DIR}/git_repos"


ORIG_PHOTO_DIR="${HOME_DIR}/Desktop/Photos"
DEST_PHOTO_DIR="${AD_PIC_DIR}"

LOG_DIR="${HOME_DIR}/Desktop/Photo_log_$(date '+%Y-%m-%d')/"
mkdir -p "${LOG_DIR}"

LOG_DATE=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="${LOG_DIR}/${LOG_DATE}.sortphotos.log"


#
# Do the thing
#
echo ""
echo "Begining to organize Pictures!! YAY!"
date
echo "Moving Photo files from Amazon to Desktop Photo folder..."
## move all new photos to the "ORIG_PHOTO_DIR"
rsync -aPz --remove-source-files \
   "${AD_PIC_DIR}/iPhone-TAW/" \
   "${AD_PIC_DIR}/iPad-TAW/" \
   "${AD_PIC_DIR}/Theresa’s iPad/" \
   "${AD_PIC_DIR}/Matt Wohlever’s iPhone/" \
   "${ORIG_PHOTO_DIR}/"
echo ""

#### https://github.com/twohlever/sortphotos
echo "Sort photos python script command: "
echo ${GIT_REPO_DIR}/sortphotos/src/sortphotos.py --recursive --sort '%Y/%Y-%m-%b_%d' --rename '%Y-%m-%b-%d_%H-%M' -c "${ORIG_PHOTO_DIR}/" "${DEST_PHOTO_DIR}"
echo ""

${GIT_REPO_DIR}/sortphotos/src/sortphotos.py \
    --recursive --sort '%Y/%Y-%m-%b_%d' --rename '%Y-%m-%b-%d_%H-%M'  \
    -c "${ORIG_PHOTO_DIR}/" "${DEST_PHOTO_DIR}" >> "${LOG_FILE}"

echo ""
echo "Collecting photo files that failed to be sorted..."
grep -B 1 "File will remain where it is" "${LOG_FILE}" \
    | grep "${HOME_DIR}" \
    | sed 's!^.*Desktop!!' > "${LOG_FILE}.failed"

mkdir -p "${LOG_DIR}/Failed"
rsync -aPz --remove-source-files --files-from="${LOG_FILE}.failed" \
    "${HOME_DIR}/Desktop/"  \
    "${LOG_DIR}/Failed/"
echo ""
echo "Moving organized photos to log folder..."
mv  "${ORIG_PHOTO_DIR}" "${LOG_DIR}/Organized_${LOG_DATE}"
mkdir -p "${ORIG_PHOTO_DIR}"
echo ""
echo "Done."
date
