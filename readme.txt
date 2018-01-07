　如果脚本有问题可以欢迎反馈：https://www.iewb.net/qg/4727.html

脚本是根据我的需求编写的，使用生成好的密钥/证书，服务端使用脚本安装完成后启动openvpn，把/etc/openvpn目录的client.zip下载下来，解压后放在客户端修改成你的服务端ip就可以使用。

在你的服务器上执行：

git clone https://github.com/qiguang0920/openvpn.git && cd openvpn &&chmod +x OpenVPN_centos7.sh &&./OpenVPN_centos7.sh
就可以自动安装。

　脚本说明：
1。使用的默认1194/udp端口
2。脚本适用于centos7系统，如果是其它redhat系列的系统，需要手动处理防火墙端口，deban系列不支持

　　脚本适合想快速部署而且偏懒得童鞋。如果对安全要求较高，在安装完成后可以重新生成证书，再配置下server.conf指向你生成的证书就可以了。客户端同样。

　　OpenVPN证书的签发
　　进入/etc/openvpn/easy-rsa/easyrsa3

　　生成服务器端所需密钥

1。./easyrsa init-pki    //目录初始化
2。./easyrsa build-ca    //创建根证书CA,此密码必须记住，不然以后不能为证书签名。还需要输入common name 通用名，这个你自己随便设置，一般设置为签发机构名或是域名。
3../easyrsa gen-req server_iewb.net nopass    //创建服务器端证书，此处我输入的是server_iewb.net，也可以是别的名字，会生成两个文件server_iewb.net.req和server_iewb.net.key
4。./easyrsa sign server server_iewb.net        //签约服务端证书，需要提供CA密码（第二步时的密码），会生成server_iewb.net.crt
5。./easyrsa gen-dh    //创建Diffie-Hellman，确保key穿越不安全网络的命令

　　生成客户端所需密钥

1。./easyrsa gen-req client_iewb.net    //client为自定义，可以是别的，会生成client_iewb.net.req和client_iewb.net.key，因为没有和服务器一样使用nopass参数，所以生成时我们输入一个证书密码。

2。./easyrsa import-req  ./pki/reqs/client_iewb.net.req client1    //导入req。此处目录和上面生成的名字都要正确，后面的那个client1可以理解为注释，其实是一个短名称，签约证书时可以使用短名称签约。        
3。./easyrsa sign client client_iewb.net        //签约证书 ,同签约服务端证书一样，需要输入CA密码

　　生成的文件所在目录分别为：

easy-rsa/easyrsa3/pki/ca.crt
easy-rsa/easyrsa3/pki/reqs/server_iewb.net.req
easy-rsa/easyrsa3/pki/reqs/client_iewb.net.req
easy-rsa/easyrsa3/pki/private/ca.key
easy-rsa/easyrsa3/pki/private/server_iewb.net.key
easy-rsa/easyrsa3/pki/private/client_iewb.net.key
easy-rsa/easyrsa3/pki/issued/server_iewb.net.crt
easy-rsa/easyrsa3/pki/issued/client_iewb.net.crt
easy-rsa/easyrsa3/pki/dh.pem

　　.req和.key为生成证书时生成，.crt为签约证书时生成，签约证书时都需要输入CA密码，其实我们使用的是.crt和.key，其中ca.crt服务端和客户端都会用到。如果想为更多人添加证书，可以再次运行命令，生成证书(不同名字)–导入–签约证书

　　一般情况下，比如单位或学校可能更需要所有人使用一个证书，然后再配置用户名和密码登陆，我们打开openvpn的配置文件server.conf，把下面三行的注释去掉

auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env
username-as-common-name
script-security 3

如果不使用证书，只使用用户名和密码验证，把下面一行的注释也去掉

client-cert-not-required 

　　以上几行配置官方的配置默认是没有的，其它手动配置openvpn的小伙伴可以把这几行加上，使用脚本安装的小伙伴只需去掉注释就可以了。

　　然后我们编辑psw-file，这里面定义用户名和密码，一行一个，用户名和密码使用空格分开。
　　同样，checkpsw.sh和psw-file这两个文件官方安装包安装完也是没有的，checkpsw.sh我们可以从网上下载，psw-file自己新建一个就行。
　　checkpsw.sh官方下载地址： http://openvpn.se/files/other/checkpsw.sh （PS:这个网址被墙了）
　　也可以看这里：https://github.com/qiguang0920/openvpn/blob/master/data/checkpsw.sh

　　然后客户端我们也要配置下，在client.ovpn中加上一行：

auth-user-pass 

　　这样服务端和客户端我们就启用了密钥和用户名密码双认证，所有用户使用同一个密钥，然后分配不同的用户名和密码。