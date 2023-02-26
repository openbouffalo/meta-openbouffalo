#!/bin/bash
# Bootstrapper for buildbot slave

DIR="build"
MACHINE="bl808"
BITBAKEIMAGE="openbouffalo-image"
RELEASE=`git branch --show-current`
CONFFILE="conf/auto.conf"
SRCDIR=`pwd`
# fix permissions set by buildbot
#echo "Fixing permissions for buildbot"
#umask -S u=rwx,g=rx,o=rx
#chmod -R 755 .
echo "Will use Yocto Release $RELEASE"


echo "Cloning Necessary Layers"
if [ ! -d poky/.git ]
then
	echo "Poky"
	git clone git://git.yoctoproject.org/poky && cd poky && git checkout -q $RELEASE && cd ..
fi
if [ ! -d meta-bl808/.git ]
then
	echo "meta-bl808"
	git clone https://github.com/Fishwaldo/meta-bl808.git && cd meta-bl808 && git checkout -q $RELEASE && cd ..
fi
if [ ! -d meta-riscv/.git ]
then
	echo "meta-riscv"
	git clone https://github.com/riscv/meta-riscv.git && cd meta-riscv && git checkout -q $RELEASE && cd ..
fi
if [ ! -d meta-openembedded/.git ]
then
	echo "meta-openembedded"
	git clone https://github.com/openembedded/meta-openembedded.git && cd meta-openembedded && git checkout -q $RELEASE && cd ..
fi


# bootstrap OE
echo "Init OE"
export BASH_SOURCE="poky/oe-init-build-env"
. poky/oe-init-build-env $DIR

# add the missing layers
echo "Adding layers"
bitbake-layers add-layer $SRCDIR/poky/meta
bitbake-layers add-layer $SRCDIR/poky/meta-poky
bitbake-layers add-layer $SRCDIR/poky/meta-yocto-bsp
bitbake-layers add-layer $SRCDIR/meta-riscv
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-oe
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-python
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-networking
bitbake-layers add-layer $SRCDIR/meta-bl808
bitbake-layers add-layer $SRCDIR


# fix the configuration
echo "Creating auto.conf"

if [ -e $CONFFILE ]; then
    rm -rf $CONFFILE
fi
cat <<EOF > $CONFFILE
MACHINE ?= "${MACHINE}"
USER_CLASSES ?= "buildstats buildhistory buildstats-summary"
INHERIT += "uninative"
DISTRO ?= "OpenBouffalo"
BB_HASHSERVE_UPSTREAM = "openbouffalo.my-ho.st:8687"
SSTATE_MIRRORS = "file://.* https://openbouffalo.my-ho.st:8443/sstate/PATH"
EOF



echo "To build an image run"
echo "---------------------------------------------------"
echo "bitbake openbouffalo-image                         "
echo "---------------------------------------------------"
echo "Other Images: openboufffalo-image-dev              "
echo "---------------------------------------------------"
echo "To Build individual packages run                   "
echo "bitbake <packagename>                              "
echo "---------------------------------------------------"
echo "If you wish to setup the BitBake Enviroment in the "
echo "future then:                                       "
echo "cd $SRCDIR; . poky/oe-init-build-env $DIR          "
echo "---------------------------------------------------"


# start build
#echo "Starting build"
#bitbake $BITBAKEIMAGE


