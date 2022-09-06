#!/bin/sh
OUT_DIR=$1
TEX_DIR=$2
PREVIEW=$3

PDFLATEX_SWITCHES="-interaction=nonstopmode -halt-on-error -output-directory $OUT_DIR $TEX_DIR/*.tex"

# Creation of output directory
mkdir -p $OUT_DIR

# Latex recipe
pdflatex $PDFLATEX_SWITCHES
bibtex $OUT_DIR/*.aux
pdflatex $PDFLATEX_SWITCHES
pdflatex $PDFLATEX_SWITCHES

# The preview pdf file is used to prevent updates to the pdf in beetween recipe's commands.
if [ ! -z $PREVIEW ]; then
    # Creation of live preview files
    find . -type f -name '*.pdf' -printf "%f\n" \
        | { read -r pdfFile; basename -- $pdfFile .pdf ; } \
        | { read -r basePdfFile; cp $OUT_DIR/$basePdfFile.pdf $OUT_DIR/$basePdfFile.preview.pdf ; }

    find $OUT_DIR -type f -not -name '*.preview.pdf' -delete
    DELETE_PATTERN='*.preview.pdf'
else
    DELETE_PATTERN='*.pdf'
fi

# Deletion of temporary build artifacts
find $OUT_DIR -type f -not -name $DELETE_PATTERN -delete