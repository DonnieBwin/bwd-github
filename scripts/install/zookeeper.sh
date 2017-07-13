#!/bin/sh 

source ./base.sh

APP=zookeeper-3.4.8.tar.gz
TARGET=$APPPATH/zookeeper-3.4.8

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

    [ ! -d $APPPATH ] && mkdir -p $APPPATH

    tar -xf $PKGPATH/$APP -C $APPPATH/
    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR: tar -xf $PKGPATH/$APP -C $APPPATH/ return $retval" && exit $retval
    echo "$APP is installed in $APPPATH/"
}

function remove_app () {
    rm -rf $TARGET
    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR: rm -rf $TARGET return $retval" && exit $retval
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

