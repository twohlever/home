#!/bin/sh


##
## Executable paths
##
BIN="${HOME}/bin"
BREW_BIN="/opt/homebrew/bin"

CP_CMD="/usr/bin/rsync -aPz"
SYNC_CMD="${BREW_BIN}/rclone sync -P" ## https://rclone.org/commands/rclone_sync/


##
## Prepare Date information
##
THIS_YEAR=$(date "+%Y")
THIS_MONTH=$(date "+%0m")
LAST_MONTH=$(printf "%02d" $(( $(echo "${THIS_MONTH}" | sed 's/^0*//')-1)))


##
## Backup paths
##
EXT_HD_SG="/Volumes/Seagate"
EXT_HD_WD="/Volumes/WesternDigital/WohleverFam"

MUSIC="Music"
PICS="Pictures"
BOOKS="Books"
CALIBRE="CalibreLibrary"
CALIBRE_PATH="${HOME}/${CALIBRE}"

SOFTWARE="Software"


## Set minimum sync size so we don't unintentionally delete all the backups
## Values based on `du -d 0` run 26 Sept. 2022
## 137448	Theresa_Career
## 22841848	WohleverConsulting
MIN_SYNC_SIZE=13600 ## smallest One Drive subdir as of 26 Sept. 2022
MIN_SYNC_SIZE_Calibre=2300000    ## 2304328 /Users/theresawohlever/CalibreLibrary/
MIN_SYNC_SIZE_BOOKS=$(( ${MIN_SYNC_SIZE_Calibre} + 1190000 ))      ## 4460560	Books
MIN_SYNC_SIZE_DOCS=9943000       ## 9943864	Documents
MIN_SYNC_SIZE_GD=482000          ## 483104	/Users/theresawohlever/Google Drive/
MIN_SYNC_SIZE_MUSIC=32300000


MUSIC_PATH="${HOME}/Music"

AD="Amazon Drive" ## Photos & Videos
LOCAL_AD="${HOME}/${AD}"
LOCAL_AD_PICS="${LOCAL_AD}/${PICS}"
EXT_HD_SG_AD="${EXT_HD_SG}/${AD}"
EXT_HD_WD_AD="${EXT_HD_WD}/${AD}"


OD="OneDrive" ## Documents, books, & audio
LOCAL_OD="${HOME}/${OD}"
LOCAL_OD_BOOKS="${LOCAL_OD}/${BOOKS}"
EXT_HD_SG_OD="${EXT_HD_SG}/${OD}"
EXT_HD_WD_OD="${EXT_HD_WD}/${OD}"


GD="Google Drive" ## Editable/shareable documents
LOCAL_GD='/Users/theresawohlever/Library/CloudStorage/GoogleDrive-theresa.wohlever@gmail.com/My Drive'  ##"${HOME}/${GD}"
EXT_HD_SG_GD="${EXT_HD_SG}/${GD}"
EXT_HD_WD_GD="${EXT_HD_WD}/${GD}"






####################################
####################################
##
## FUNCTIONS
##
####################################

_just_do_it_f (){
  _SOURCE="${1}"
  _DEST="${2}"
  _CMD="${3}"

  echo "${_CMD} ${_SOURCE} ${_DEST}"
  ${_CMD} "${_SOURCE}" "${_DEST}"

}

copy_f (){
  _just_do_it_f "${1}"  "${2}" "${CP_CMD}"

}

sync_f (){
    _just_do_it_f "${1}"  "${2}" "${SYNC_CMD}"
}



is_syncable_size_f (){
  # 1 = Minimum syncable size
  # 2 = Path

  ## Initialize local vars
  _SIZE=0
  _MIN_SYNC_SIZE=${MIN_SYNC_SIZE}
  _PATH="/dev/null"

  # set local vars to legit values
  # 1 = Minimum syncable size
  # 2 = Path
  if [[ ${1} -gt ${_MIN_SYNC_SIZE} ]]; then
    _MIN_SYNC_SIZE=${1} ## Set min to be larger of function input or base min
  fi

  _PATH=${2}
  _SIZE=$(du -d 0 "${_PATH}" | cut -f 1 )

  echo "Is ${_SIZE}. > ${_MIN_SYNC_SIZE}."
  echo "for  syncing ${_PATH} safely?"

  if [[ ${_SIZE} -gt ${_MIN_SYNC_SIZE} ]]; then
      return 0;
  else
    echo "ERROR: Min size not met!!"
    return 1;
  fi
}

back_brew_f () {

## Software
## Bundle Brew Packages
## https://apple.stackexchange.com/questions/101090/list-of-all-packages-installed-using-homebrew
 
  brew upgrade
  cd "${LOCAL_OD}/${SOFTWARE}/"
  rm -f "Brewfile"
  brew bundle dump
  cd -
}




####################################
####################################
##
## Organize Photos
##
####################################

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
  echo " Sync-ing "
  echo "     +++++ ${day_dir} +++++"
  echo "                to External Hard Drives"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  SOURCE="${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}"

  DEST="${EXT_HD_SG_AD}/${PICS}/${THIS_YEAR}/${day_dir}"
  sync_f "${SOURCE}" "${DEST}"

  DEST="${EXT_HD_WD_AD}/${PICS}/${THIS_YEAR}/${day_dir}"
  sync_f "${SOURCE}" "${DEST}"

done


# In case any "new" pictures were picked up
# from before the current month
for month in `seq 1 $((${LAST_MONTH}-1)) `
do
  month2d="$(printf "%02d" ${month})"
  echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo " Copying over "
  echo "  +++++  ${THIS_YEAR} ${month2d} +++++"
  echo "                  to External Hard Drives"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="


  for day_dir in `ls -1 "${LOCAL_AD_PICS}/${THIS_YEAR}/" | grep "${THIS_YEAR}-${month2d}-" `
  do
    echo ""; echo "";
    echo "Copying subdirectory ${day_dir} to External Hard drives..."
    copy_f "${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/" "${EXT_HD_SG_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"
    copy_f "${LOCAL_AD_PICS}/${THIS_YEAR}/${day_dir}/"   "${EXT_HD_WD_AD}/${PICS}/${THIS_YEAR}/${day_dir}/"

  done
done




# In case any "new" pictures were picked up
# from before the current year
for year in `ls -1 "${LOCAL_AD_PICS}/" | grep 20 | grep -v "${THIS_YEAR}" `
do
  echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo " Copying over "
  echo "     +++++  ${year} +++++"
  echo "                to External Hard Drives"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="

  copy_f "${LOCAL_AD_PICS}/${year}/" "${EXT_HD_SG_AD}/${PICS}/${year}/"
  copy_f  "${LOCAL_AD_PICS}/${year}/" "${EXT_HD_WD_AD}/${PICS}/${year}/"

done






##
## BOOKS
##


echo ""; echo ""; echo ""; echo "";
date
echo "Backing up ${CALIBRE} ${BOOKS}"
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
is_syncable_size_f "${MIN_SYNC_SIZE_Calibre}" "${CALIBRE_PATH}/"
if [[ $? -eq 0 ]]
then
  sync_f "${CALIBRE_PATH}/" "${LOCAL_OD_BOOKS}/${CALIBRE}/"
fi




##
## MUSIC
##


echo ""; echo ""; echo ""; echo "";
date
echo "Backing up ${MUSIC} from ${MUSIC_PATH}"
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
is_syncable_size_f "${MIN_SYNC_SIZE_MUSIC}" "${MUSIC_PATH}/"
if [[ $? -eq 0 ]]
then
  sync_f "${MUSIC_PATH}/" "${EXT_HD_SG}/${MUSIC}"
  sync_f "${MUSIC_PATH}/" "${EXT_HD_WD}/${MUSIC}"
fi



##
## Backing up all other data
##
echo ""; echo ""; echo ""; echo "";
date
echo "Done syncing ${AD} ${PICS} & ${OD} ${CALIBRE} ${BOOKS}."
echo "      Backing up all other ${OD} data."
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="



for sub in `ls -1 "${LOCAL_OD}/" | grep -v -e ${PICS} -e "Icon" `
do
  echo ""; echo ""; echo "";
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  echo "     +++++    ${sub}    +++++"
  echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
  SOURCE="${LOCAL_OD}/${sub}/"

  if [[ ${sub} == *"Document"* ]]; then
    is_syncable_size_f "${MIN_SYNC_SIZE_DOCS}" "${SOURCE}/"
    if [[ $? -eq 0 ]]
    then
     DEST="${EXT_HD_SG_OD}/${sub}/"
     sync_f "${SOURCE}" "${DEST}"
     DEST="${EXT_HD_WD_OD}/${sub}/"
     sync_f "${SOURCE}" "${DEST}"
    fi
  elif [[ ${sub} == *"Books"* ]]; then
    is_syncable_size_f "${MIN_SYNC_SIZE_BOOKS}" "${SOURCE}/"
    if [[ $? -eq 0 ]]
    then
      DEST="${EXT_HD_SG_OD}/${sub}/"
      sync_f "${SOURCE}" "${DEST}"
      DEST="${EXT_HD_WD_OD}/${sub}/"
      sync_f "${SOURCE}" "${DEST}"
    fi
   else
    
    if [[ ${sub} == "${SOFTWARE}" ]]; then
      back_brew_f 
    fi
    
    is_syncable_size_f "${MIN_SYNC_SIZE}" "${SOURCE}/"
    if [[ $? -eq 0 ]]
    then
      DEST="${EXT_HD_SG_OD}/${sub}/"
      sync_f "${SOURCE}" "${DEST}"
      DEST="${EXT_HD_WD_OD}/${sub}/"
      sync_f "${SOURCE}" "${DEST}"
    fi
  fi

done



echo ""; echo ""; echo ""; echo "";
date
echo "Done backing up ${OD} data. Backing up all ${GD} data."
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="
echo "=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-==-=-=-="


echo ""; echo "";
SOURCE="${LOCAL_GD}/"

is_syncable_size_f "${MIN_SYNC_SIZE_GD}" "${SOURCE}/"
if [[ $? -eq 0 ]]
then
  DEST="${EXT_HD_SG_GD}/"
  sync_f "${SOURCE}" "${DEST}"

  DEST="${EXT_HD_WD_GD}/"
  sync_f "${SOURCE}" "${DEST}"
fi


echo ""; echo ""; echo ""; echo "";
date
echo "Full Backup Done!"
