#!/usr/bin/env bash

cd `dirname $0`

source client.sh.arg.sh

#sed  -i  's/local/xxx/g' 客户端/fpc-copy.ini

/root/frp-base/frp_0.30.0_linux_amd64/frpc -c  /root/frp-base/client_config/fpc-$blockname.ini
