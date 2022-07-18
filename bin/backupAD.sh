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
EXT_HD_SG="/Volumes/Seagate"
EXT_HD_WD="/Volumes/WesternDigital"

PICS="Pictures"
BOOKS="Books"
CALIBRE="CalibreLibrary"
CALIBRE_PATH="${HOME}/${CALIBRE}"


AD="Amazon Drive"
LOCAL_AD="${HOME}/${AD}"
LOCAL_AD_BOOKS="${LOCAL_AD}/${BOOKS}"
LOCAL_AD_PICS="${LOCAL_AD}/${PICS}"

EXT_HD_SG_AD="${EXT_HD_SG}/${AD}"
EXT_HD_WD_AD="${EXT_HD_WD}/${AD}"

GD="Google Drive"
LOCAL_GD="${HOME}/${GD}"

EXT_HD_SG_GD="${EXT_HD_SG}/${GD}"
EXT_HD_WD_GD="${EXT_HD_WD}/${GD}"



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
# Only sync photos from this month & last month
for day_dir in `ls -1 "${LOCAL_AD_PICS}/${THIS_YEAR}/" | \
  grep -e "${THIS_YEAR}-${THIS_MONTH}" -e "${THIS_YEAR}-${LAST_MONTH}" `
do
  echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo "     +++++  ${THIS_YEAR} ${day_dir} +++++"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  SOURCE="${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}"

  DEST="${EXT_HD_SG_AD}/${PICS}/${THIS_YEAR}/${day_dir}"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"

  DEST="${EXT_HD_WD_AD}/${PICS}/${THIS_YEAR}/${day_dir}"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"

done


# In case any "new" pictures were picked up
# from before the current month
for month in `seq 1 $((${LAST_MONTH}-1)) `
do
  month2d="$(printf "%02d" ${month})"
  echo ""; echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo "     +++++  ${THIS_YEAR} ${month2d} +++++"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="

  for day_dir in `ls -1 "${LOCAL_AD_PICS}/${THIS_YEAR}/" | grep "${THIS_YEAR}-${month2d}-" `
  do
    echo ""; echo "";
    echo "Copying subdirectory ${day_dir} to External Hard drives..."

    echo "${CP_CMD} \"${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/\"   \"${EXT_HD_SG_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"
    ${CP_CMD} "${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/"   "${EXT_HD_SG_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"

    echo "${CP_CMD} \"${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/\"   \"${EXT_HD_WD_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"
    ${CP_CMD} "${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/"   "${EXT_HD_WD_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"
  done
done




# In case any "new" pictures were picked up
# from before the current year
for year in `ls -1 "${LOCAL_AD_PICS}/" | grep 20 | grep -v "${THIS_YEAR}" `
do
  echo ""; echo ""; echo "";
  echo "${year}"
  echo "Copying over ${year} to External Hard drives..."

  echo "${CP_CMD} \"${LOCAL_AD_PICS}/${year}/\" \"${EXT_HD_SG_AD}/${PICS}/${year}/"
  ${CP_CMD} "${LOCAL_AD_PICS}/${year}/" "${EXT_HD_SG_AD}/${PICS}/${year}/"

  echo "${CP_CMD} \"${LOCAL_AD_PICS}/${year}/\" \"${EXT_HD_WD_AD}/${PICS}/${year}/"
  ${CP_CMD} "${LOCAL_AD_PICS}/${year}/" "${EXT_HD_WD_AD}/${PICS}/${year}/"
done






##
## BOOKS
##

echo ""; echo ""; echo ""; echo "";
date
echo "Backing up ${CALIBRE} ${BOOKS}"
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
SOURCE="${CALIBRE_PATH}/"
DEST="${LOCAL_AD_BOOKS}/${CALIBRE}/"
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"



##
## Backing up all other data
##
echo ""; echo ""; echo ""; echo "";
date
echo "Done backing up ${AD} ${PICS} & ${BOOKS}. Backing up all other ${AD} data."
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="



for sub in `ls -1 "${LOCAL_AD}/" | grep -v -e ${PICS} -e "Icon" `
do
  echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo "     +++++    ${sub}    +++++"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  SOURCE="${LOCAL_AD}/${sub}/"

  DEST="${EXT_HD_SG_AD}/${sub}/"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"

  DEST="${EXT_HD_WD_AD}/${sub}/"
  echo "${SYNC_CMD} ${SOURCE} ${DEST}"
  ${SYNC_CMD} "${SOURCE}" "${DEST}"
done






echo ""; echo ""; echo ""; echo "";
date
echo "Done backing up ${AD} data. Backing up all ${GD} data."
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="


echo ""; echo "";
SOURCE="${LOCAL_GD}/"
DEST="${EXT_HD_SG_GD}/"
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"


DEST="${EXT_HD_WD_GD}/"
echo "${SYNC_CMD} ${SOURCE} ${DEST}"
${SYNC_CMD} "${SOURCE}" "${DEST}"




echo ""; echo ""; echo ""; echo "";
date
echo "Full Backup Done!"
