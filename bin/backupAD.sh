#!/bin/sh

THIS_YEAR="2022"


## Backup paths
LOCAL_AD="${HOME}/Amazon Drive"
EXT_HD_AD="/Volumes/Seagate/Amazon Drive"
NAS_AD="/Volumes/Wohlever_Media/Amazon Drive"


## Executables
BIN="${HOME}/bin"
BREW_BIN="/opt/homebrew/bin"

CP_CMD="/usr/bin/rsync -aPz"

## https://rclone.org/commands/rclone_sync/
SYNC_CMD="${BREW_BIN}/rclone sync -P"



##
## Organize Photos
##
date
echo "Organize Photos..."
${BIN}/organize-pictures.sh


## Back it up
# Local to external hard drive
SOURCE="${LOCAL_AD}/Documents/"
DEST="${EXT_HD_AD}/Documents/"
echo ""; echo ""; echo "";
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


SOURCE="${LOCAL_AD}/Audio/"
DEST="${EXT_HD_AD}/Audio/"
echo ""; echo ""; echo "";
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


SOURCE="${LOCAL_AD}/Books/"
DEST="${EXT_HD_AD}/Books/"
echo ""; echo ""; echo "";
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


SOURCE="${LOCAL_AD}/Pictures/${THIS_YEAR}/"
DEST="${EXT_HD_AD}/Pictures/${THIS_YEAR}/"
echo ""; echo ""; echo "";
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


# In case any "new" pictures were picked up
# from before the current year
for year in `ls -1 "${LOCAL_AD}/Pictures/" | grep 20 | grep -v ${THIS_YEAR}`
do
  echo ""; echo ""; echo "";
  echo "${year}"
  echo "Copying over ${year} to External Hard drive..."
  ${CP_CMD} "${LOCAL_AD}/Pictures/${year}/" "${EXT_HD_AD}/Pictures/${year}/"
done

#
# External hard drive to Network Storage
#
SOURCE="${EXT_HD_AD}/"
DEST="${NAS_AD}/"
echo ""; echo ""; echo "";
# echo "${SYNC_CMD} ${SOURCE} ${DEST}"
# ${SYNC_CMD} "${SOURCE}" "${DEST}"

echo "Done!"
date
