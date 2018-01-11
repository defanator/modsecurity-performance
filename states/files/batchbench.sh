#!/bin/bash
# vim: tabstop=4 expandtab

function run {
    mkdir -p ${HOME}/batch/raw ${HOME}/batch/res

    if [ ! -f Makefile.in ]; then
        sed -e "s#^LMSREV=.*#LMSREV=%%REV%%#g" < Makefile > Makefile.in
    fi

    while read rev ; do
        if [ -f "${HOME}/batch/res/${rev}" ]; then
            continue
        fi

        echo "===> Working with ${rev}"
        rm -rf ModSecurity lms
        sed -e "s#%%REV%%#${rev}#g" < Makefile.in > Makefile

        echo "---> Building ${rev}"
        make lms > ${HOME}/batch/raw/${rev}.build 2>&1
        (cd ModSecurity && git log -1 --pretty=format:"%H,%ai,%s" ${rev}) > ${HOME}/batch/res/${rev}.log

        echo "---> Benchmarking ${rev}"
        ./batchperfrun.sh run ${rev}
        ./batchperfrun.sh stats ${rev} > ${HOME}/batch/res/${rev}

       cat ${HOME}/batch/res/${rev}
    done < batchbench.revs
}

function stats {
    echo ";rps_avg,latency_avg,workers_utime_avg,revision,date,commit_log"

    while read rev ; do
        if [ ! -f ${HOME}/batch/res/${rev} ]; then
            continue
        fi

        str=`cat ${HOME}/batch/res/${rev}.log`
        avgs=`cat ${HOME}/batch/res/${rev} | grep "^x" | awk '{print $6}' | tr '\n' ' '`
        rps=`echo ${avgs} | cut -d ' ' -f 1`
        lat=`echo ${avgs} | cut -d ' ' -f 2`
        utime=`echo ${avgs} | cut -d ' ' -f 3`

        if [ -z "${rps}" -o -z "${lat}" ]; then
            continue
        fi

	printf "%.2f,%.2f,%.2f,%s\n" "${rps}" "${lat}" "${utime}" "${str}"
    done < batchbench.revs
}

case $1 in
    run) run ;;
    stats) stats ;;
    *) echo "usage: `basename $0` run|stats" ;;
esac
