#!/bin/sh 

source ./base.sh

APP=redis-3.2.3-1.el7.x86_64.rpm
TARGET=$APPPATH/redis-3.2.3-1
DEPS_PKGS="jemalloc"

function check_installed () {
    if [ -d $TARGET ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

function install_app () {
    [ ! -f $PKGPATH/$APP ] && echo "ERROR: $PKGPATH/$APP do not exist" && exit 1

    check_installed $TARGET
    [ "$?" -eq "$TRUE" ] && echo "INFO: $APP already installed, \"$0 reintsall\" if you want" && exit 2

    install_deps $DEPS_PKGS
    [ ! -d $TARGET ] && mkdir -p $TARGET
    pushd $TARGET
    rpm2cpio $PKGPATH/$APP | cpio -div
    retval=$?
    popd

    [ "$retval" -ne "0" ] && echo "ERROR: \"rpm2cpio $PKGPATH/$APP | cpio -div\" return $retval" && exit $retval
    echo "$APP is installed in $TARGET/"
}

function remove_app () {
    check_installed $TARGET
    if [ "$?" -eq "$TRUE" ]; then
        echo rm -rf $TARGET
        rm -rf $TARGET
        retval=$?
        [ "$retval" -ne "0" ] && echo "ERROR: rm -rf $TARGET return $retval"
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

