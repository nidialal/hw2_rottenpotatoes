#!/bin/bash
git status
git add .
git status
git commit -m $msg
git status
git push
git push heroku
