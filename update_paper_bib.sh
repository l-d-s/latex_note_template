#!/usr/bin/env bash

biber --output-format=bibtex result_dev/document.bcf -O - \
   | sed '/INFO - /d' \
   | sed '/WARN - /d' \
   | sed '/FILE = /d' \
   > ./document_biber.bib