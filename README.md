## Berry Conda

Berryconda is a conda based Python distribution for the Raspberry Pi.  With it,
you can install and manage a scientific or Pydata stack on your Raspberry Pi using
[conda](http://conda.pydata.org/docs/), a package and environment management system.
All this can be done without compiling a single package!

## Quick start

Berryconda is designed to work with [raspbian](https://www.raspbian.org/)
jessie.  Other Linux versions and distributions may or may not work.

To install Berryconda, download the installer appropiate for your Raspberry Pi
model.  For Raspberry Pi 2 or 3 use the armv7l installers.  For Raspberry
Pi 1 or Zero use the armv6l installer.  

Berryconda comes in two 'flavors', Berryconda2 and Berryconda3.  The difference
between these are the version of Python installed; Berryconda2 installs
Python 2.7, and Berryconda3 installs Python 3.5. Choose the version you want install. 

### armv7l installers (Raspberry Pi 2 or 3)

* [Berryconda3-1.0.0-Linux-armv7l.sh](https://github.com/jjhelmus/berryconda/releases/download/v1.0.0/Berryconda3-1.0.0-Linux-armv7l.sh)
* [Berryconda2-1.0.0-Linux-armv7l.sh](https://github.com/jjhelmus/berryconda/releases/download/v1.0.0/Berryconda2-1.0.0-Linux-armv7l.sh)

### armv6l installers (Raspberry Pi 1 or Zero)

* [Berryconda3-1.0.0-Linux-armv6l.sh](https://github.com/jjhelmus/berryconda/releases/download/v1.0.0/Berryconda3-1.0.0-Linux-armv6l.sh)
* [Berryconda2-1.0.0-Linux-armv6l.sh](https://github.com/jjhelmus/berryconda/releases/download/v1.0.0/Berryconda2-1.0.0-Linux-armv6l.sh)

Once this file is downloaded on your Raspberry Pi, make the file executable
using `chmod` and the execuate the installer.  For example, to install
Berryconda3 on a Raspberry Pi 3:

```
chmod +x Berryconda3-1.0.0-Linux-armv7l.sh`
./Berryconda3-1.0.0-Linux-armv7l.sh
```

Follow the prompts to finish your install of Berryconda.

Once installed use the [conda](http://conda.pydata.org/docs/) command to
add packages from the [rpi](https://anaconda.org/rpi/) channel.

## Details

Berryconda is created using [constructor](https://github.com/conda/constructor)
using the configuration files in the **installer** directory of this
repository.

The packages in the [rpi](https://anaconda.org/rpi/) channel were created
using [conda-build](http://conda.pydata.org/docs/building/recipe.html)
using the recipes in the **recipes** directory of this repository.

Package building is done on two Raspberry Pi 3s, a Raspberry Pi 1, and a
Raspberry Pi Zero.

## Issues and package requests

Please report any problems with Berryconda or the packages in the rpi channel
by submitting an [issue](https://github.com/jjhelmus/berryconda/issues).
Also, use this link to request new packages.

## Acknowlegements

The majority of the packages used in Berryconda were adapted from
[conda-forge](http://conda-forge.github.io/) recipes. A big thanks to
everyone involved in the project!

Thanks to [Continuum Analytics](https://www.continuum.io/) for hosting the rpi
channel on the [Anaconda Cloud](https://anaconda.org) and for creating the
conda ecosystem.
