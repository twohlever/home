#!/bin/sh

##
## Prepare Date information
##
THIS_YEAR=$(date "+%Y")
THIS_MONTH=$(date "+%0m")
LAST_MONTH="$(printf "%02d" $((${THIS_MONTH}-1)))"


##
## Backup paths
##
EXT_HD="/Volumes/Seagate"
NAS_HD=""
PICS="Pictures"

AD="Amazon Drive"
LOCAL_AD="${HOME}/${AD}"
LOCAL_AD_PICS="${LOCAL_AD}/${PICS}"
EXT_HD_AD="${EXT_HD}/${AD}"
NAS_HD_AD="${NAS_HD}/${AD}"

GD="Google Drive"
LOCAL_GD="${HOME}/${GD}"
EXT_HD_GD="${EXT_HD}/${GD}"
NAS_HD_GD="${NAS_HD}/${GD}"



##
## Executable paths
##
BIN="${HOME}/bin"
BREW_BIN="/opt/homebrew/bin"

CP_CMD="/usr/bin/rsync -aPz"
SYNC_CMD="${BREW_BIN}/rclone sync -P" ## https://rclone.org/commands/rclone_sync/



##
## Organize Photos
##
date
echo "Organize ${AD} ${PICS}..."
${BIN}/organize-pictures.sh
echo "Done Organizing  ${AD} ${PICS}."
date
echo ""; echo ""; echo "";




####################################
####################################
##
## Backup
##
####################################



#
# Pictures & Videos
#

echo "Backing up ${AD} ${PICS}..."
# Only sync photos from this month
for day_dir in `ls -1 "${LOCAL_AD_PICS}/${THIS_YEAR}/" | \
  grep -e "${THIS_YEAR}-${THIS_MONTH}" -e "${THIS_YEAR}-${LAST_MONTH}" `
do
  echo ""; echo ""; echo "";
  echo $day_dir
  SOURCE="${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}"
  DEST="${EXT_HD_AD}/${PICS}/${THIS_YEAR}/${day_dir}"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"

done


# In case any "new" pictures were picked up
# from before the current year
for year in `ls -1 "${LOCAL_AD_PICS}/" | grep 20 | grep -v "${THIS_YEAR}" `
do
  echo ""; echo ""; echo "";
  echo "${year}"
  echo "Copying over ${year} to External Hard drive..."
  ${CP_CMD} "${LOCAL_AD_PICS}/${year}/" "${EXT_HD_AD}//${PICS}/${year}/"
done



##
## Backing up all other data
##
echo ""; echo ""; echo ""; echo "";
date
echo "Done backing up ${AD} ${PICS}. Backing up all other ${AD} data."
echo ""; echo "";

for sub in `ls -1 "${LOCAL_AD}/" | grep -v -e ${PICS} -e "Icon" `
do
  echo ""; echo ""; echo "";
  echo "${sub}"
  SOURCE="${LOCAL_AD}/${sub}/"
  DEST="${EXT_HD_AD}/${sub}/"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"
done




echo ""; echo ""; echo ""; echo "";
date
echo "Done backing up ${AD} data. Backing up all ${GD} data."
echo ""; echo "";
SOURCE="${LOCAL_GD}/"
DEST="${EXT_HD_GD}/"
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


#
# External hard drive to Network Storage
#
#SOURCE="${EXT_HD_AD}/"
#DEST="${NAS_AD}/"
#echo ""; echo ""; echo "";
# echo "${SYNC_CMD} ${SOURCE} ${DEST}"
# ${SYNC_CMD} "${SOURCE}" "${DEST}"

echo "Full Backup Done!"
date
