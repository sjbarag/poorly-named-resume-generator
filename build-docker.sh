#!/usr/bin/env bash
set -x

DOCKER=$(
  command -v podman || \
  command -v docker || \
  (echo "Either docker or podman must be installed." && exit 1)
)

set -euo pipefail

$DOCKER build --tag poorly-named-resume-generator .
$DOCKER run -it -v $PWD:/pnrg poorly-named-resume-generator
