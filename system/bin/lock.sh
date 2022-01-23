#!/bin/sh

#
# LOCK
#

lock_file=/data/dji/amt/lock

aging_test_lock()
{
    sync
    while [ -f $lock_file ]; do
        echo "$BASHPID waiting for lock release..."
        sleep 2
        sync
    done

    touch $lock_file
    sync
}

aging_test_unlock()
{
    sync
    rm -rf $lock_file
}

