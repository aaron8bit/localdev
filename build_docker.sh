#!/bin/bash

./get_files.sh

docker build -t aaron8bit/devdocker:latest .
