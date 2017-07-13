#!/bin/sh 

source ./base.sh

APP=dubbo-admin-2.5.4-SNAPSHOT.war
TARGET=$APPPATH/apache-tomcat-8.5.4/webapps/dubbo-admin

function check_installed () {
    if [ -d $TARGET ]; then
        return $TRUE
    fi
    return $FALSE
}

function install_app () {
    [ ! -f $PKGPATH/$APP ] && echo "ERROR: $PKGPATH/$APP do not exist" && exit 1
    [ ! -d $APPPATH/apache-tomcat-8.5.4 ] && echo "ERROR: Tomcat must be installed first" && exit 1
    [ -d $TARGET ] && echo "INFO: $APP already installed, \"$0 reintsall\" if you want" && exit 2

    unzip $PKGPATH/$APP -d $TARGET
    if [ -d $APPPATH/apache-tomcat-8.5.4/webapps/ROOT ]; then
        mv $APPPATH/apache-tomcat-8.5.4/webapps/ROOT $APPPATH/apache-tomcat-8.5.4/webapps/ROOT-default
    fi
    ln -s $TARGET $APPPATH/apache-tomcat-8.5.4/webapps/ROOT 
    retval=$?

    [ "$retval" -ne "0" ] && echo "ERROR: install $APP failed" && exit $retval
    echo "$APP is installed in $TARGET"
}

function remove_app () {
    [ -h $APPPATH/apache-tomcat-8.5.4/webapps/ROOT ] && rm -f $APPPATH/apache-tomcat-8.5.4/webapps/ROOT 
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

