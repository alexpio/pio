#!/bin/bash
# Я не умею на питоне....
# Для работы этого скрипта нужен websocket_client-0.37.0. Я его установил так: pip install websocket-client

#exec 2>$0.err
#set -x

###################################################################################################
if [ $1 -ge 1 ] 2>/dev/null && [ $2 -ge 1 ] 2>/dev/null
then
    CON=$1
    REQ=$2
else
    echo "Usage: ws_test.sh N M. Where N is quantity of connection and M quantity of requests."
    exit
fi

echo N=$CON
echo M=$REQ
###################################################################################################
make_script (){
CON=$1
REQ=$2
echo "$HEAD"
while [ $CON -gt 0 ]; do
    echo "$CONN"
    CON=$(($CON - 1))
    REQ=$2
    while [ $REQ -gt 0 ]; do
	echo "$BODY"
	REQ=$(($REQ - 1))
    done
    echo "$TAIL"
done
}
###################################################################################################

HEAD='from __future__ import print_function
import websocket

if __name__ == "__main__":
    websocket.enableTrace(True)'

CONN='    print("---- conn ------------------------------------------------------------------------------------------------")
    ws = websocket.create_connection("ws://192.168.0.6/echo")'

BODY='    print("---- req -------------------------------------------------------------------------------------------------")
    print("Sending '\''Hello, World'\''...")
    ws.send("Hello, World")
#    print("Sent")
#    print("Receiving...")
    result = ws.recv()
    print("Received '\''%s'\''" % result)'

TAIL='    ws.close()'


make_script $CON $REQ | python


exit
cat << EOF | python
from __future__ import print_function
import websocket

if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.create_connection("ws://192.168.0.6/echo")
    print("Sending 'Hello, World'...")
    ws.send("Hello, World")
    print("Sent")
    print("Receiving...")
    result = ws.recv()
    print("Received '%s'" % result)
    print("---------------------------------------------------")

    ws.close()
EOF
