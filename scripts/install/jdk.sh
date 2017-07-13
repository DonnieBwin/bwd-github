#!/bin/sh 

source ./base.sh

APP=jdk-8u101-linux-x64.rpm
TARGET=$APPPATH/jdk1.8.0_101

if [ -d $TARGET ] ; then
    PKG_RPM_NAME=`rpm -qf $TARGET`
fi

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

    rpm -ih --prefix=$APPPATH $PKGPATH/$APP
    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR: rpm -ih --prefix=$APPPATH $PKGPATH/$APP return $retval" && exit $retval
    echo "$APP is installed in $APPPATH/"
}

function remove_app () {
    if [ -n "$PKG_RPM_NAME" ] ; then
        echo rpm -e $PKG_RPM_NAME
        rpm -e $PKG_RPM_NAME
        retval=$?
        [ "$retval" -ne "0" ] && echo "ERROR: rpm -e $PKG_RPM_NAME return $retval"
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

