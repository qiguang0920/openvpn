如果脚本有问题可以欢迎反馈：https://www.iewb.net/qg/4727.html

脚本是根据我的需求编写的，使用生成好的密钥/证书，服务端使用脚本安装完成后启动openvpn，把/etc/openvpn目录的client.zip下载下来，解压后放在客户端修改成你的服务端ip就可以使用。

在你的服务器上执行：

git clone https://github.com/qiguang0920/openvpn.git && cd openvpn &&chmod +x OpenVPN_centos7.sh &&./OpenVPN_centos7.sh

就可以自动安装。


脚本说明：
1。使用的默认1194/udp端口
2。脚本适用于centos7系统，如果是其它redhat系列的系统，需要手动处理防火墙端口，deban系列不支持
3。开启了redirect-gateway，firewalld开启了转发
4。连接方式为tun
5。安装完成时会询问是否现在启动OpenVPN,输入yes启动。
6。默认加入了系统启动项，重新开机会自动启动OpenVPN
7.无认服务器端还是客户端证书密码都是www.iewb.net，手机登陆的时候会用到证书密码

脚本适合想快速部署而且偏懒得童鞋。如果对安全要求较高，在安装完成后可以重新生成证书，再配置下server.conf指向你生成的证书就可以了。客户端同样。