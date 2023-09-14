#!/bin/bash
DST="output/"
OUTPUT_BASE="barag_resume"

rm -rf $DST && mkdir $DST

python3 generate_resume.py --output-name $OUTPUT_BASE --destination $DST raw_source.yaml && \

cp static-content/barag_resume.cls $DST/
(
  cd $DST
  lualatex ${OUTPUT_BASE}.tex && lualatex ${OUTPUT_BASE}.tex
)
