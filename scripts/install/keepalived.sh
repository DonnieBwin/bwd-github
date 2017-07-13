#!/bin/sh 

source ./base.sh

APP=keepalived-1.2.13-7.el7.x86_64.rpm
TARGET=/usr/sbin/keepalived
DEPS_PKGS="net-snmp-agent-libs net-snmp-libs lm_sensors-libs"

function check_installed () {
    [ -f $TARGET ] && return $TRUE
    return $FALSE
}

function install_app () {
    install_deps $DEPS_PKGS
    [ ! -f $PKGPATH/$APP ] && echo "ERROR: $PKGPATH/$APP do not exist" && exit 1

    check_installed
    [ "$?" -eq "$TRUE" ] && echo "INFO: $APP already installed, \"$0 reintsall\" if you want" && exit 2

    install_deps $DEPS_PKGS
    rpm -ivh $PKGPATH/$APP
    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR: \"rpm -ivh $PKGPATH/$APP\" return $retval" && exit $retval
    echo "$APP is installed"
}

function remove_app () {
    check_installed
    if [ "$?" -eq "$TRUE" ]; then
        pkg_name=`rpm -qf $TARGET`
        echo "rpm -e $pkg_name"
        rpm -e $pkg_name
        retval=$?
        [ "$retval" -ne "0" ] && echo "ERROR: \"rpm -e $pkg_name\" return $retval"
    fi
}

case $1 in
    install)
        install_app
        ;;
    reinstall)
        remove_app
        install_app
        ;;
    remove)
        remove_app
        ;;
    *)
        echo "Usage: $0 {install|remove|reinstall}"
        ;;
esac

