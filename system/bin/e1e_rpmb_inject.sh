
#!/system/bin/sh

cat /proc/cmdline | busybox grep "mp_state=engineering"
retcode=$?
if [ $retcode -eq 0 ]; then
    echo "rpmb key should be injected only while board is encrpyted"
    exit 1
fi

amt_test_cmd rpmb
exit $?
