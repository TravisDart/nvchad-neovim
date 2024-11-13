#!/bin/bash

cd "$(dirname "$0")"

bash 01_build_base.sh
bash 02_build_test.sh
bash 03_test.sh
# bash 04.deploy.sh
# bash 05_pull.sh
# bash 03_test.sh --published
