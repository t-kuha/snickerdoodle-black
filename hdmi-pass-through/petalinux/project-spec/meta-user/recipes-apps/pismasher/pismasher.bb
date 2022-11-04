#
# This file is the pismasher recipe.
#

SUMMARY = "piSmasher Configuration Software and Libraries"
SECTION = "PETALINUX/apps"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=25a68f382c083e41c1a78b1ede7555cd"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
	git://github.com/krtkl/piSmasher-software.git \
	file://0001-Add-support-for-Yocto.patch \
"
SRCREV = "b67f63c0a0ebe8ac2aac7442a82ca6634fc43d9d"

S = "${WORKDIR}/git/projects"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}${bindir}
	             
	install -m 0755 ${S}/build/audio-config ${D}${bindir}/audio-config
	install -m 0755 ${S}/build/hdmi-config ${D}${bindir}/hdmi-config
	install -m 0755 ${S}/build/hdmi-edid ${D}${bindir}/hdmi-edid
	install -m 0755 ${S}/build/uio-clk-wiz ${D}${bindir}/uio-clk-wiz
	install -m 0755 ${S}/build/uio-vdma ${D}${bindir}/uio-vdma
	install -m 0755 ${S}/build/uio-vtc ${D}${bindir}/uio-vtc
	install -m 0755 ${S}/build/video-config ${D}${bindir}/video-config
	install -m 0755 ${S}/build/vid-tpg-config ${D}${bindir}/vid-tpg-config
}
