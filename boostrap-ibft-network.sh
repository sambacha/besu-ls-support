#!/bin/bash
set -e
source common/variables
source common/functions

sh scripts/generate-ibft-network-files 3 4
