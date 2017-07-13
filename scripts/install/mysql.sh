#!/bin/sh 

source ./base.sh

APPS="mysql-community-client-5.7.17-1.el7.x86_64.rpm mysql-community-common-5.7.17-1.el7.x86_64.rpm mysql-community-libs-5.7.17-1.el7.x86_64.rpm mysql-community-server-5.7.17-1.el7.x86_64.rpm"
TARGET=/usr/sbin/mysqld
DEPS_PKGS="perl-Data-Dumper"

function check_installed () {
    [ -f $TARGET ] && return $TRUE
    return $FALSE
}

function install_app () {
    for app in $APPS
    do
        [ ! -f $PKGPATH/$app ] && echo "ERROR: $PKGPATH/$APP do not exist" && exit 1
    done

    check_installed
    [ "$?" -eq "$TRUE" ] && echo "INFO: $APP already installed, \"$0 reintsall\" if you want" && exit 2

    install_deps $DEPS_PKGS
    pushd $PKGPATH
    rpm -ivh $APPS 
    retval=$?
    popd

    [ "$retval" -ne "0" ] && echo "ERROR: \"rpm -ivh $APPS\" return $retval" && exit $retval
    echo "$APPS is installed"
}

function remove_app () {
    check_installed
    if [ "$?" -eq "$TRUE" ]; then
        PKG_NAMES=
        for app in $APPS
        do
            if [ -f $PKGPATH/$app ]; then
                PKG_NAMES+=" `rpm -qp $PKGPATH/$app 2>/dev/null`"
            fi
        done
        [ -z "$PKG_NAMES" ] && echo "ERROR: do not known which pkgs to remove" && exit 1 
        echo "rpm -e $PKG_NAMES"
        rpm -e $PKG_NAMES
        retval=$?
        [ "$retval" -ne "0" ] && echo "ERROR: \"rpm -e $PKG_NAMES\" return $retval"
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

