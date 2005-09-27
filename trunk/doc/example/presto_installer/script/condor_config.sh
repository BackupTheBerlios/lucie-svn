#!/bin/sh

FILE_DIR="/etc/lucie/files"

fcopy -s $FILE_DIR /etc/condor/condor_config /etc/condor/condor_config.local
