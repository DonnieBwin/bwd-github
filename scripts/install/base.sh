#!/bin/bash

BASEPATH=/opt/dplus
PKGPATH=$BASEPATH/install/pkgs
APPPATH=$BASEPATH/usr
TRUE=1
FALSE=0

install_from_yum () {
    yum -y install $1
    return $?
}

install_from_local () {
    local pkg=`ls $PKGPATH/ | grep $1`
    [ -z "$pkg" ] && echo "$1 do not exist" && return 1

    pkg=$PKGPATH/$pkg
    pkg_name=`rpm -qp $pkg 2>/dev/null`
    pkg_name=`rpm -qa | grep $pkg_name`
    if [ -z "$pkg_name" ]; then
        echo install $pkg_name
        rpm -ih $pkg
    fi
    return $?
}

function install_deps () {
    local i pkg_name

    for i in $@
    do
        pkg_name=`rpm -qa | grep $i`
 
        if [ -z "$pkg_name" ]; then
            install_from_local $i
            [ "$?" -ne "0" ] && install_from_yum $i
        fi
    done
}

