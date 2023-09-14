#!/usr/bin/env bash

for f in result_dev/*.bcf; do
   fb="${f%.*}"
   biber --output-format=bibtex $f -O - \
      | sed '/INFO - /d' \
      | sed '/WARN - /d' \
      | sed '/FILE = /d' \
      > ./${fb}.bib
done

# cat result_dev/*.bib > result_dev/merged.bib

# Currently deletes Phipson Thesis
bibtool  --preserve.key.case=on --print.deleted.entries=off \
   -d -i <(cat result_dev/*.bib) -o ./document_biber.bib
