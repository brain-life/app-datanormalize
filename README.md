[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.1-blue.svg)](https://doi.org/10.25663/bl.app.1)

# app-datanormalize
application to normalize the bvalues and flip the bvecs if necessary

### Authors
- Brent McPherson (bcmcpher@iu.edu)
- Lindsey Kitchell (kitchell@iu.edu)
- Soichi Hayashi (hayashis@iu.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

# Running via Docker

You can run this app anywhere that has docker engine installed.

## Build docker container

If you are not going to use the one that we've published on docker hub, you can build the container locally by git cloning this repo, and then run following command

`docker build -t app-datanormalize .`

## Create config.json

This container receives input parameter via config.json. Create something like following in your current working directory.

```
{
        "bvals": "/input/dwi.bvals",
        "bvecs": "/input/dwi.bvecs",
        "dwi": "/input/dwi.nii.gz",
        "xflip": true,
        "yflip": false,
        "zflip": false
}
```

/input is a path inside the container which we will map from our host directory. In this example, I will create a directory called testdata in my working directory.

```
mkdir testdata
# copy your dwi.bvals, dwi.bvecs, and dwi.nii.gz in to testdata
```
## Running container

Now, run docker run to run the app

```
docker run -it --rm \
    -v `pwd`/testdata:/input \
    -v `pwd`:/output \
    app-datanormalize

```

We will volume mount (-v) current working directory's testdata directory as container's /input directory, and also the current working directory as container's /output directory. /output directory is used as the working directory inside the container (which is mounted from the host's current working directory). So, by placing the config.json on the host's current working directory, container will find config.json under its /output directory.
