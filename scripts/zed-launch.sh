#!/bin/bash
# Kills orphan zed daemon before launching fresh.
# Zed runs as a single-instance daemon which blocks relaunch
# if a previous invisible process is still running.
pkill -f zed-editor
sleep 0.5
zeditor &
