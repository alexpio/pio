#!/bin/bash

exec 2>$0.err
#set -x

WORK_DIR=/usr/src/apache-websocket
SRC_DIR=$WORK_DIR/examples
MODULES_DIR=/usr/lib/apache2/modules
AP_CONF_DIR=/etc/apache2
AP_CONF_FILE=$AP_CONF_DIR/apache2.conf


cd $SRC_DIR
/usr/bin/scons
/usr/bin/scons install



cp $AP_CONF_FILE ${AP_CONF_FILE}.bak


cat << EOF > $AP_CONF_DIR/blabla.tmp

# For testing apache-websocket ############################################################
#<IfModule mod_websocket.c> # If uncomment this line - module dont work....
  <Location /echo>
    SetHandler websocket-handler
    WebSocketHandler /usr/lib/apache2/modules/mod_websocket_echo.so echo_init
  </Location>
 <Location /dumb-increment>
    SetHandler websocket-handler
    WebSocketHandler /usr/lib/apache2/modules/mod_websocket_dumb_increment.so dumb_increment_init
  </Location>
#</IfModule>
############################################################################################

EOF

cat $AP_CONF_FILE >> $AP_CONF_DIR/blabla.tmp
mv $AP_CONF_DIR/blabla.tmp $AP_CONF_FILE


/etc/init.d/apache2 restart
