#!/bin/bash

sudo pacman --noconfirm -Sy github-cli
git config --global user.name '$GIT_NAME'
git config --global user.email '$GIT_EMAIL'
echo '$GITHUB_TOKEN' | gh auth login --with-token