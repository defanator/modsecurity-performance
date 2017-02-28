#!/bin/bash
# vim: tabstop=4 expandtab

set -e

locations="/modsec-off /modsec-light /modsec-full"
iterations=10
duration=10s
threads=1
connections=50

function run {
    sudo service nginx stop

    echo "Running wrk, please be patient"

    for location in ${locations}; do
        rm -f /tmp${location}.out
        i=1
        while [ $i -le ${iterations} ]; do
            echo "[${i}/${iterations}] $location ..."
            sudo service nginx start
            sleep 1
            wrk -t${threads} -c${connections} -d${duration} http://localhost${location}/a/b/c 2>&1 >>/tmp${location}.out
            sudo service nginx stop
            sleep 1
            i=$((i+1))
        done
    done
}

function stats {
    for location in ${locations}; do
        echo "Summary for ${location}, RPS (count):"
        awk '{if ($1 == "Requests/sec:") {print $2}}' /tmp${location}.out | ministat -n -w 80 | fgrep -v stdin
        echo " latency (ms)"
        awk '{if ($1 == "Latency") {print substr($2, 1, length($2)-2)}}' /tmp${location}.out | ministat -n -w 80 | tail -1
        echo
    done
}

case $1 in
  run) run ;;
  stats) stats ;;
  *) echo "usage: `basename $0` run|stats" ;;
esac


