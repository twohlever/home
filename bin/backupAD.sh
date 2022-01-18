#!/bin/sh

## Backup paths
LOCAL_AD="${HOME}Amazon\ Drive"
EXT_HD_AD="/Volumes/Seagate/Amazon\ Drive"
NAS_AD="/Volumes/Wohlever_Media/Amazon\ Drive"


## Executables
BIN="${HOME}/bin"
BREW_BIN="/opt/homebrew/bin"

SYNC="${BREW_BIN}/rclone sync -P " ‪## https://rclone.org/commands/rclone_sync/


## Organize Photos
# ${BIN}/organize-pictures.sh


## Back it up
# Local to external hard drive
SOURCE="${LOCAL_AD}/Documents/"
DEST="${EXT_HD_AD}/Documents/"
echo ""; echo ""; echo "";
echo "${SYNC} ${SOURCE} ${DEST}"
# ${SYNC} ${SOURCE} ${DEST}



SOURCE="${LOCAL_AD}/Audio/"
DEST="${EXT_HD_AD}/Audio/"
echo ""; echo ""; echo "";
echo "${SYNC} ${SOURCE} ${DEST}"
# ${SYNC} ${SOURCE} ${DEST}


SOURCE="${LOCAL_AD}/Books/"
DEST="${EXT_HD_AD}/Books/"
echo ""; echo ""; echo "";
echo "${SYNC} ${SOURCE} ${DEST}"
# ${SYNC} ${SOURCE} ${DEST}


SOURCE="${LOCAL_AD}/Pictures/2022/"
DEST="${EXT_HD_AD}/Pictures/2022/"
echo ""; echo ""; echo "";
echo "${SYNC} ${SOURCE} ${DEST}"
# ${SYNC} ${SOURCE} ${DEST}


# External hard drive to Network Storage
SOURCE="${EXT_HD_AD}/"
DEST="${NAS_AD}/"
echo ""; echo ""; echo "";
echo "${SYNC} ${SOURCE} ${DEST}"
# ${SYNC} ${SOURCE} ${DEST}
