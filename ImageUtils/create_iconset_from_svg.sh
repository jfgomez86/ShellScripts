#!/bin/zsh

if [ -z "$1" ]; then
  print "You need to pass at least one SVG file"
  print "Usage: create_iconset_from_svg.sh file1 [file2] [file3] ..."
  exit 1
fi

for file in $@ ; do

  SVG_FILE=$file
  ICONSET_FOLDER="$(dirname $SVG_FILE)/$(basename -s .svg $SVG_FILE).iconset"
  TARGET_SIZES=(16 32 128 256 512)
  RSVG_CONVERT_PATH="/usr/local/bin/rsvg-convert"
  CONVERT_COMMAND="$RSVG_CONVERT_PATH -h {{:size:}} $SVG_FILE"

  create_folder() {
    echo "Creating folder $ICONSET_FOLDER"
    mkdir $ICONSET_FOLDER
  }

  create_variants() {
    for size in $TARGET_SIZES; do
      target_without_suffix="$ICONSET_FOLDER/icon_${size}x$size"
      hires_size=$(echo "2*$size" | bc)

      normal_target_png=$target_without_suffix.png
      hires_target_png="'$target_without_suffix@2x.png'"

      normal_convert_command="$(echo $CONVERT_COMMAND | sed "s/{{:size:}}/$size/") > $normal_target_png"
      hires_convert_command="$(echo $CONVERT_COMMAND | sed "s/{{:size:}}/$hires_size/") > $hires_target_png"

      echo "Converting into size $size..."
      eval $normal_convert_command
      eval $hires_convert_command

    done

    echo $ICONSET_FOLDER
  }

  create_folder $ICONSET_FOLDER
  create_variants $SVG_FILE

done
