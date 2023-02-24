#!/bin/bash
# Bootstrapper for buildbot slave

DIR ?= "build"
MACHINE="pine64-ox64"
BITBAKEIMAGE="openbouffalo-image"
RELEASE="kirkstone"
CONFFILE="conf/auto.conf"
SRCDIR=`pwd`
# fix permissions set by buildbot
#echo "Fixing permissions for buildbot"
#umask -S u=rwx,g=rx,o=rx
#chmod -R 755 .

echo "Cloning Necessary Layers"
echo "Poky"
git clone -q git://git.yoctoproject.org/poky && cd poky && git checkout -q $RELEASE && cd ..
echo "meta-bl808"
git clone -q https://github.com/Fishwaldo/meta-bl808.git && cd meta-bl808 && git checkout -q $RELEASE && cd ..
echo "meta-riscv"
git clone -q https://github.com/riscv/meta-riscv.git && cd meta-riscv && git checkout -q $RELEASE && cd ..
echo "meta-openembedded"
git clone -q https://github.com/openembedded/meta-openembedded.git && cd meta-openembedded && git checkout -q $RELEASE && cd ..


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
bitbake-layers add-layer $SRCDIR/meta-bl808
bitbake-layers add-layer $SRCDIR/meta-openbouffalo
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-oe
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-python
bitbake-layers add-layer $SRCDIR/meta-openembedded/meta-networking


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
EOF



echo "To build an image run"
echo "---------------------------------------------------"
echo "MACHINE=pine64-ox64 bitbake openbouffalo-image     "
echo "---------------------------------------------------"
echo "Other Images: openboufffalo-image-dev              "
echo "---------------------------------------------------"

# start build
#echo "Starting build"
#bitbake $BITBAKEIMAGE


