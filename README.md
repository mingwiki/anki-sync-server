# anki-sync-server

## 1、安装docker运行环境

``` shell
$   apt/yum install docker  # linux用户
$   brew install --cask docker  # mac homebrew用户
$   mkdir /ankidata  # 用于本地存储anki数据，防止docker挂掉或者版本更新的时候数据丢失。
```

## 2、启动或停止anki-server
``` shell
$   # 启动docker，建议存为startAnki.sh,方便以后直接使用。
$   docker run -d --rm --name anki-server -p 27701:27701 -v /ankidata:/anki/data mingwiki/anki-sync-server:v1
$   # 停止docker，建议存为stopAnki.sh,方便以后直接使用。
$   docker container kill anki-server       
```

## 3、进入docker管理anki用户

```shell
$   docker container exec -it anki-server /bin/bash # 进入容器
$   ./ankisyncctl.py help   # 获取命令
$   ./ankisyncctl.py adduser <username> # 添加用户
$   ./ankisyncctl.py deluser <username> # 删除用户
$   ./ankisyncctl.py lsuser             # 列出用户
$   ./ankisyncctl.py passwd <username>  # 更改用户密码
```

> 退出时输入exit即可。

## 4、此时win版anki已经可以使用，需要安装同步插件。

### 点击工具--插件--查看本地插件文件，自动弹出插件目录

### 在该目录中新建文件夹ankisyncd，进入后，新建txt文件，改名为__init__.py ，用记事本打开，内容如下

```python
import os

addr = "https://anki.naizi.fun/" #服务器地址，务必修改此处。
os.environ["SYNC_ENDPOINT"] = addr + "sync/"
os.environ["SYNC_ENDPOINT_MEDIA"] = addr + "msync/"
```

> 默认是http 27701端口，所以地址格式为 http://127.0.0.1:27701/ ，需要做https的朋友继续下一步。

### 重启anki后，点击同步即可使用。

## 5、安卓麻烦一点，需要用nginx做反向代理http至https。
> 使用我的个人站点举例 "anki.naizi.fun"。
### 使用云服务器的朋友可以直接获得域名服务商提供的的免费SSL证书，本地电脑自建服务器的需要生成本地证书。
``` shell
$   apt/yum/brew install certbot
$   certbot certonly --standalone -d anki.naizi.fun     #生成证书包含三个文件xx.cer, xx.pem, xx.key。
```
> 生成本地SSL证书的软件很多，mkcert和openssl均可，网上教程很多。

### 本地建anki-server的朋友需要把生成证书的xx.cer文件，安装至安卓手机。使用云服务器的朋友不需要此步骤。

> 设置--安全--证书管理--安装证书，各种手机设置大同小异肯定有此选项。

### 有了证书以后需要设置nginx，推荐配置如下

### 文件名保存为，anki.conf 
``` nginx
server {
    # Allow access via HTTPS
    listen 443 ssl;
    listen [::]:443 ssl;

    # Set server names for access
    server_name anki.naizi.fun; # 务必编辑此处

    # Set TLS certificates to use for HTTPS access
    ssl_certificate certs/anki.naizi.fun.pem; # 务必编辑此处
    ssl_certificate_key certs/anki.naizi.fun.key; # 务必编辑此处

    location / {
        # Prevent nginx from rejecting larger media files
        client_max_body_size 0;

        proxy_pass http://内网ip:27701; # 务必编辑此处
    }
```
> 把上述文件放在特定的目录下，一般在/etc/nginx/conf.d (linux)，/usr/local/etc/nginx/servers (homebrew)

> 务必不要修改默认的nginx.conf文件

> 此配置的作用是把http的27701端口反向代理到https的443端口

### 重启nginx后安卓anki便可使用，配置地址应该类似如下格式。

``` txt
https://anki.naizi.fun/
https://anki.naizi.fun/msync
```

### ！！！注意最后的斜杠不可省略，一个有一个没有。
