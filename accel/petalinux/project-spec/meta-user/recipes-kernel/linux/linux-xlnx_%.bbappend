FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://bsp.cfg"
KERNEL_FEATURES_append = " bsp.cfg"
SRC_URI += "file://user_2021-10-31-11-38-00.cfg"

