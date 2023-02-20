SUMMARY = "Resize rootfs to fill userdata partition."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PACKAGE_ARCH = "${MACHINE_ARCH}"

ALLOW_EMPTY:${PN} = "1"

pkg_postinst_ontarget:${PN}() {
    root=`lsblk -o NAME,LABEL -r | grep rootfs | awk -F' ' '{print $1}'`
    if [[ "$root" == *"mmcblk0"* ]]; then
        echo "Resizing root partition to fill SDCard..."
        sgdisk -e /dev/${root:0:-2}
        partprobe
        parted -s /dev/${root:0:-2} resizepart ${root:0-1} 100%
        partprobe
        resize2fs /dev/$root
    fi
}

RDEPENDS:${PN} += "e2fsprogs-resize2fs parted util-linux gptfdisk"