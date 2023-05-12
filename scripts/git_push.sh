#!/bin/bash
set -e

data_dir="$1"

[ "$data_dir" = "" ]                && { >&2 echo "$0 path/to/data"; exit 1;}
[ "`basename $data_dir`" = "data" ] || { >&2 echo "$0 path/to/data"; exit 1;}
[ -d "$data_dir" ]                  || { >&2 echo "Invalid directory: $1"; exit 1;}


# copy all committed files (not pushed) in data/dyne/git_check

committed_files=`cd "$data_dir"; git diff --name-only origin/main HEAD`
if [ "$committed_files" = "" ]; then
    >&2 echo "No committed files to be checked"
else
    cd "$data_dir"
    rm -rf dyne/git_check
    mkdir dyne/git_check
    cp $committed_files dyne/git_check
    cd -

    # scrub data/dyne/git_check
    set +e
    ./scripts/scrub.sh $1/dyne git_check
    if [ $? != "0" ]; then
        rm -r "$data_dir/dyne/git_check"
        exit $?
    fi
    rm -r "$data_dir/dyne/git_check"
    set -e
fi

# push
cd $data_dir && git push
curl "https://uptime.dyne.org/api/push/SZJSAEl66T?status=up&msg=OK&ping="
