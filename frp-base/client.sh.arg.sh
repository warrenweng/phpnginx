#!/usr/bin/env bash
#参数快速填写
# /bin/bash /root/frp-base/client.sh --blockname=ssh --custom_domains= --type=tcp --server_addr= --local_ip=127.0.0.1 --local_port= --remote_port= ;


help(){
cat<<EOF
参数(带*表示必须填写):
--blockname 块状的意义 (当前值:$blockname)
--custom_domains  (当前值:$custom_domains)
--type  (当前值:$type)
--server_addr*  (当前值:$server_addr)
--local_ip  (当前值:$local_ip)
--local_port*  (当前值:$local_port)
--remote_port*  (当前值:$remote_port)
-h | --help 显示此帮助文档
EOF
exit 0;
}


# -o -代表不接受短参数的命名

OPTS=`getopt  -o :h  --long blockname:,custom_domains:,type:,server_addr:,local_ip:,local_port:,remote_port:,help -- "$@"`
if [ $? != 0 ] ; then echo "参数解析错误" >&2 ; exit 1 ; fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    #块状的意义;
    --blockname)
        #设置变量值
        blockname=$2; shift 2;;
    #;
    --custom_domains)
        #设置变量值
        custom_domains=$2; shift 2;;
    #;
    --type)
        #设置变量值
        type=$2; shift 2;;
    #;
    --server_addr)
        #设置变量值
        server_addr=$2; shift 2;;
    #;
    --local_ip)
        #设置变量值
        local_ip=$2; shift 2;;
    #;
    --local_port)
        #设置变量值
        local_port=$2; shift 2;;
    #;
    --remote_port)
        #设置变量值
        remote_port=$2; shift 2;;
    -h|--help) help; exit 0; ;;
    --) shift; break ;;
    * ) break ;;
  esac
done
#默认参数设置
[ -z $blockname ] && blockname="ssh" ;
[ -z $type ] && type="tcp" ;
[ -z $local_ip ] && local_ip="127.0.0.1" ;

#必填参数检测
[ -z $server_addr ] && echo -e "server_addr 参数必填.\n" && help ;
[ -z $local_port ] && echo -e "local_port 参数必填.\n" && help ;
[ -z $remote_port ] && echo -e "remote_port 参数必填.\n" && help ;


#需要替换文件(2)
cp /root/frp-base/client_config/fpc.ini /root/frp-base/client_config/fpc-$blockname.ini;

#加上主机名字作为区别，这样可以进行负载均衡
sed  -i  's/\$blockname/'$blockname'-'$HOSTNAME'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$custom_domains/'$custom_domains'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$type/'$type'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$server_addr/'$server_addr'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$local_ip/'$local_ip'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$local_port/'$local_port'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
sed  -i  's/\$remote_port/'$remote_port'/g'  /root/frp-base/client_config/fpc-$blockname.ini;
