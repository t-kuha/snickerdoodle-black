# replace default "interfaces" file

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://my-interfaces \
"

do_install:append () {
    install -m 0644 ${WORKDIR}/my-interfaces ${D}${sysconfdir}/network/interfaces
}
