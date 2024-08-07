#!/usr/bin/env sh

echo "This is some output that should go to STDOUT";
>&2 echo "This is some output that should go to STDERR";
