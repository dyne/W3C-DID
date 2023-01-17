#!/bin/bash

[ "$1" = "" ]                && { >&2 echo "$0 path/to/data"; exit 1;}
[ "`basename $1`" = "data" ] || { >&2 echo "$0 path/to/data"; exit 1;}
[ -d "$1" ]                  || { >&2 echo "Invalid directory: $1"; exit 1;}

# copy all committed files (not pushed) in data/dyne/git_check
cd $1
committed_files=`git diff --name-only origin/main HEAD`
sandbox_files=`echo $committed_files | grep "dyne/sandbox"`
[ "$sandbox_files" = "" ] || {
    >&2 echo "Sandbox files found in committed files: "
    echo $sandbox_files | tr ' ' '\n' >&2
    exit 1
}
mkdir dyne/git_check
cp $committed_files dyne/git_check
cd -

# scrub data/dyne/git_check
./scripts/scrub.sh $1/dyne git_check
[ $? != "0" ] && { rm -r $1/dyne/git_check; exit $?;}
rm -r $1/dyne/git_check

# push
#cd $1 && git push