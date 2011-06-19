#!/bin/bash

# cd ${ANDROID_BUILD_TOP}

# Android.mk
FILES=$(find . -type f -name Android.mk | xargs grep -l -e "[ =]-m64")

for file in $FILES; do
echo -n $file: replacing...
ed -s $file <<'_CMD'
,s/-m64//g
wq
_CMD
echo done
done

# build/core/main.mk
MAIN_MK=./build/core/main.mk
echo -n $MAIN_MK replacing...
ed -s $MAIN_MK <<'_CMD'
/ifeq (\$(BUILD_OS
ka
/^$
'a,. d
wq
_CMD
echo done
# done
