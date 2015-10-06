#!/bin/bash
DST="output/"
OUTPUT_BASE="barag_resume"

python3 generate_resume.py --output-name $OUTPUT_BASE --destination $DST raw_source.yaml
pushd $DST
lualatex ${OUTPUT_BASE}.tex &&
    lualatex ${OUTPUT_BASE}.tex
popd
