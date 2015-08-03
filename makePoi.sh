#根据git最新版生成poi.app
#!/bin/bash
# set -e

title="Poi-installer" # dmg 文件 mount 了之后在文件系统中显示的名称
background_picture_name="poi-dmg-bg.png" # dmg 文件在 mount 了之后界面中显示的背景图片路径
application_name="poi.app" # 应用程序的名称
# Developer ID 证书的名称（名字的一部分即可，但是需要能在 Keychain Access 中唯一定位到该证书）
developer_id="Mother Child Studio"
electron="Electron.app" # electron.app路径名字
project_git="https://github.com/yudachi/poi.git"
electron_git="https://github.com/atom/electron"


# 获取到项目名称，如果自动获取的项目名称不正确，可以手动进行指定
# cd $(dirname $0)
project_name="poi"
# 后续需要根据 target 的名称查找最新的打包文件路径
project_target_name=$project_name


# 打包Git版本Poi
git clone $project_git
cd $project_name
git pull
git submodule init
git submodule update
npm i
./node_modules/.bin/bower install
./node_modules/.bin/gulp
cp default-config.cson config.cson

# 清理git目录
# rm -rf $project_name

# 获取electron版本号
electron_version=$(head -n 2 gulpfile.coffee|grep "ELECTRON_VERSION"|cut -f 3 -d " ")
electron_version=${electron_version//\'/}
echo $electron_version
version=$(head -n 1 gulpfile.coffee|cut -f 3 -d " ")
version=${electron_version//\'/}
cd ..

# 抓Electron
electron_url="https://npm.taobao.org/mirrors/electron/${electron_version}/electron-v${electron_version}-darwin-x64.zip"
echo $electron_url
curl -O $electron_url
unzip electron-v${electron_version}-darwin-x64.zip "Electron.app/*"

# 复制electron和app.zip
mv $electron ./${application_name}

# 压制zip
# zip -r app.zip $project_name -x "*.DS_Store"

# 压制asar
# mkdir ./node_modules
# npm install asar
# asar_bin="./node_modules/asar/bin/asar"
# $asar_bin pack $project_name app.asar
# rm -rf ./node_modules

# 复制zip
# cp app.zip ./${application_name}/Contents/Resources/
# rm app.zip

# 复制asar
# mv app.asar ./${application_name}/Contents/Resources/
# rm app.asar

# 复制文件夹
# cp -R $project_name ./${application_name}/Contents/Resources/app
mv $project_name ./${application_name}/Contents/Resources/app
