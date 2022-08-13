#!/bin/bash
###########################################################################
# inotifywait directory monitoring script for centmin mod lemp stack
###########################################################################
DT=$(date +"%d%m%y-%H%M%S")
INOTIFY_LOGDIR='/root/centminlogs'
INOTIFY_LOG_FILENAME='inotify.log'
INOTIFY_LOG="${INOTIFY_LOGDIR}/${INOTIFY_LOG_FILENAME}"

if [ ! -d "$INOTIFY_LOGDIR" ]; then
  mkdir -p "$INOTIFY_LOGDIR"
fi

if [ ! -f /usr/bin/inotifywait ]; then
  yum -y -q install inotify-tools
fi

file_removed() {
  TIMESTAMP=$(date)
  echo "[$TIMESTAMP]: The file $1$2 was deleted" | tee -a "$INOTIFY_LOG"
}

file_modified() {
  TIMESTAMP=$(date)
  echo "[$TIMESTAMP]: The file $1$2 was modified" | tee -a "$INOTIFY_LOG"
}

file_attrib() {
  TIMESTAMP=$(date)
  echo "[$TIMESTAMP]: The file $1$2 attribute was modified" | tee -a "$INOTIFY_LOG"
}

file_created() {
  TIMESTAMP=$(date)
  echo "[$TIMESTAMP]: The file $1$2 was created" | tee -a "$INOTIFY_LOG"
}

clear_log() {
  rm -f "$INOTIFY_LOG"
  touch "$INOTIFY_LOG"
}

inotifywait -q -m -r -e modify,delete,create,attrib $1 | while read DIRECTORY EVENT FILE; do
  case $EVENT in
    ATTRIB*)
      file_attrib "$DIRECTORY" "$FILE"
      ;;
    MODIFY*)
      file_modified "$DIRECTORY" "$FILE"
      ;;
    CREATE*)
      file_created "$DIRECTORY" "$FILE"
      ;;
    DELETE*)
      file_removed "$DIRECTORY" "$FILE"
      ;;
  esac
done