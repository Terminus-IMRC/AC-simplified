#!/usr/bin/env bash

PWD=$(pwd)

if ! fgrep -q $(realpath "$PWD")/tmp /proc/mounts; then
	mkdir -p "$PWD/tmp"
	sudo mount none -t tmpfs "$PWD/tmp"
fi
