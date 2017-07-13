本目录下的脚本需要在部署软件的目标机器上执行。

在执行脚本前，软件包已经被拷贝到 /opt/dplus/install/pkgs目录，脚本被拷贝到/opt/dplus/install/scripts/install/目录。
执行脚本后，大部分软件将安装在/opt/dplus/usr/目录; 有些rpm的软件不能指定安装路径，将安装在软件包缺省的路径，如/usr/bin/

脚本支持三种操作：install, remove, reinstall。

