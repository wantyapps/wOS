#!/bin/bash

# A script to send all patches in patches/ to Uri Arev

root=$(git rev-parse --show-toplevel)

git send-email --to me@wantyapps.xyz $root/patch/*.patch
