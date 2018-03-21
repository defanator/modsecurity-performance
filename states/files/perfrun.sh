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
            wrk -t${threads} -c${connections} -d${duration} -s ${HOME}/report.lua \
                -H "Host: www.example.com" \
                -H "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5 (.NET CLR 3.5.30729)" \
                -H "Accept: text/html,application/xhtml+xml,application/xml; q=0.9,*/*;q=0.8" \
                -H "Accept-Language: en-us,en;q=0.5" \
                -H "Accept-Encoding: gzip,deflate" \
                -H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
                -H "Keep-Alive: 300" \
                -H "Connection: keep-alive" \
                -H "Cookie: PHPSESSID=r2t5uvjq435r4q7ib3vtdjq120" \
                -H "Pragma: no-cache" \
                -H "Cache-Control: no-cache" \
                "http://localhost${location}/test.pl?param1=test&para2=test2" 2>&1 >>/tmp${location}.out
            sudo service nginx stop
            sleep 1
            i=$((i+1))
        done
    done
}

function stats {
    for location in ${locations}; do
        echo "Summary for ${location}, RPS (count):"
        awk '{if ($1 == "rps:") {print $2}}' /tmp${location}.out | ministat -n -w 80 | fgrep -v stdin
        echo " latency (ms)"
        awk '{if ($1 == "latency.avg:") {print $2}}' /tmp${location}.out | ministat -n -w 80 | tail -1
        echo
    done
}

case $1 in
  run) run ;;
  stats) stats ;;
  *) echo "usage: `basename $0` run|stats" ;;
esac


