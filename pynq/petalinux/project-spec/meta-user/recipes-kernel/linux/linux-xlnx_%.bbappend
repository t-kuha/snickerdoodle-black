FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2022-11-09-12-43-00.cfg \
            file://user_2022-11-12-11-44-00.cfg \
            file://user_2022-11-12-11-48-00.cfg \
            "

