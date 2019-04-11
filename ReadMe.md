## 功能
脚本实现自动编译及打包，上传AppStore、上传蒲公英、发送钉钉

## 如何使用
脚本中需要修改为自己的project_name、scheme_name
自动上传需要补充蒲公英的Key，钉钉通知需要补充token

编译命令有两种，通过POD引入第三方库使用autoBuildPkg.xcworkspace，Xcode创建项目使用autoBuildPkg.xcodeproj；
#### autoBuildPkg.xcworkspace
#### autoBuildPkg.xcodeproj

## 命令
sh autoBuild.sh
