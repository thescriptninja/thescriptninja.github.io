#!/usr/bin/sh

# Commit change in content
git status
git add -A
echo Enter commit message for master branch
read masterCommitMessage
git commit -m "$masterCommitMessage"
git push origin master

#Building static files
hugo

# Commit change in static files
cd public
git status
git add -A
echo Enter commit message for gh-pages branch
read ghPagesCommitMessage
git commit -m "$ghPagesCommitMessage"
git push origin gh-pages
