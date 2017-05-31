#!/bin/bash

#mainly to debug locally
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi

#clean up previous job (just in case)
rm -f finished
module load matlab


echo "starting main"

(
export MATLABPATH=$MATLABPATH:$SCA_SERVICE_DIR
nohup time matlab -nodisplay -nosplash -r main > stdout.log 2> stderr.log

#check for output files
if [ -s dwi.bvecs ] && [ -s dwi.bvals ];
then
	echo 0 > finished
else
	echo "bvecs or bvals  missing"
	echo 1 > finished
	exit 1
fi
) &