#!/bin/bash

#mainly to debug locally
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi

#clean up previous job (just in case)
rm -f finished

if [ $ENV == "IUHPC" ]; then
    module load matlab
fi

echo "starting main"

cat << EOT > _run.sh
export MATLABPATH=$MATLABPATH:$SERVICE_DIR
time matlab -nodisplay -nosplash -r main

#check for output files
if [ -s dwi.bvecs ] && [ -s dwi.bvals ]; then
	echo 0 > finished
else
	echo "bvecs or bvals  missing"
	echo 1 > finished
	exit 1
fi
EOT

chmod +x _run.sh
nohup ./_run.sh > stdout.log 2> stderr.log & echo $! > pid
