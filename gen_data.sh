#!/bin/bash

BASH_PROFILE="/usr/local/hawq/greenplum_path.sh"
source ${BASH_PROFILE}

GPLOAD_HOST=`grep GPLOAD_HOST tpcds.config|awk -F '=' '{print $2}'`
CURDIR=`pwd`
DATASIZE=`grep DATASIZE tpcds.config|awk -F '=' '{print $2}'`
PARALLEL=`grep PARALLEL tpcds.config|awk -F '=' '{print $2}'`

DIRS=`grep DIRS tpcds.config|awk -F '=' '{print $2}'`

slaveNum=0
arrslave=(${GPLOAD_HOST//,/ })
for islave in ${arrslave[@]}
do
	let "slaveNum += 1"
done

folderNum=0
arrdir=(${DIRS//,/ })
for idir in ${arrdir[@]}
do
	let "folderNum += 1"
done

totalparallel=$((PARALLEL * folderNum * slaveNum))

ic=0
icall=""
arrdir=(${DIRS//,/ })
for idir in ${arrdir[@]}
do
	arrslave=(${GPLOAD_HOST//,/ })
	for islave in ${arrslave[@]}
	do
		ssh ${islave} "mkdir -p ${idir}/tpcds/${DATASIZE}"
		icall=""
		for ((counter = 1; counter <= $PARALLEL; ++counter)); do
			icall="${icall} $((++ic))"
		done
		echo "ssh ${islave} source ${BASH_PROFILE};$GPHOME/bin/parallel_dsdgen $DATASIZE $totalparallel ${idir}/tpcds/${DATASIZE} ${icall}"
		ssh ${islave} "source ${BASH_PROFILE};$GPHOME/bin/parallel_dsdgen $DATASIZE $totalparallel ${idir}/tpcds/${DATASIZE} ${icall}" &
		sleep 1
	done
	wait
done

wait
