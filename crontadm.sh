#!/bin/sh
# crontab admin.©2020-2021 by Quinn.Zhang (angviza@gmail.com)
# Usage:
#
# 1. Put this script somewhere in your project
#
# cron='* * * * * /path/to/watch.sh /path/to/target'
# 2. list crontab ,run ./crontadm.sh l
# 3. To add the crontab, run ./crontadm.sh add $cron
#
# 4. To remove the crontab, run ./crontadm.sh rm $$cron
#
usage() {
    cat <<USAGE_END
Usage:
    $0 add "job-spec-lineno"
    $0 l # list crons
    $0 rm "job-spec-lineno"
USAGE_END
}

if [ -z "$1" ]; then
    usage >&2
    exit 1
fi
# var
cron=${@:2}
tmp=$(mktemp)
id

sumid() {
    id=$(echo -n $cron | md5sum | awk '{printf "#%s#",$1}')
}
check_arg() {
    if [ -z "$cron" ]; then
        usage >&2
        exit 1
    fi
}
check_id() {
    sumid
    grep -w "$id" /var/spool/cron/*
    if [ $? -eq 0 ]; then
        echo "$cron already exists"
        exit 1
    fi
}
save() {
    crontab "$tmp" && rm -f "$tmp"
}
#┌───────────────────────────────────────────────────┐
#│                       CRD                         │
#└───────────────────────────────────────────────────┘
add() {
    check_arg
    check_id

    crontab -l >"$tmp"
    printf '%s\n' "$cron ${id}" >>"$tmp"
    save
}
list() {
    crontab -l | cat -n
}
remove() {
    check_arg
    sumid $cron
    crontab -l | sed -e "/${id}/d" >"$tmp"
    save
}
case "$1" in
'add')
    add
    ;;
'l')
    list
    ;;
'rm')
    remove
    ;;
*)
    usage >&2
    exit 1
    ;;
esac
exit 0
