#!/bin/sh 

source ./base.sh

APP=monit-5.18-linux-x64.tar.gz
TARGET=$APPPATH/monit-5.18

function check_installed () {
    if [ -d $TARGET ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

function install_app () {
    install_deps $DEPS_PKGS
    [ ! -f $PKGPATH/$APP ] && echo "ERROR: $PKGPATH/$APP do not exist" && exit 1

    check_installed $TARGET
    [ "$?" -eq "$TRUE" ] && echo "INFO: $APP already installed, \"$0 reintsall\" if you want" && exit 2

    [ ! -d $APPPATH ] && mkdir -p $APPPATH

    tar -xf $PKGPATH/$APP -C $APPPATH/

    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR:  tar -xf $PKGPATH/$APP -C $APPPATH/ return $retval" && exit $retval
    echo "$APP is installed in $APPPATH/"
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

