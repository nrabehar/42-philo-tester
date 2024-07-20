#!/bin/bash

# -- SETUP ------------------------------------------------------------------------------#
# ADJUST PATH TO PHILO/PHILO_BONUS DIRECTORY IF NECESSARY (-> IF ITS NOT THE PARENT DIRCTORY)
PHILO_PARENT_DIR="$(dirname "$0")/../"

source utils.sh
source tests.sh

setup_tester
