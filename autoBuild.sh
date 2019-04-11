#工程绝对路径
project_path=$(cd `dirname $0`; pwd)
echo $project_path

#项目名
project_name=autoBuildPkg

#工程名
scheme_name=autoBuildPkg

#打包模式
echo "请填写打包模式 [1:Release 2:Debug] "

read number
while([[ $number != 1 ]] && [[ $number != 2 ]])
do
echo "输入错误 [1:Release 2:Debug] "
echo "请填写打包模式 [1:Release 2:Debug] "
read number
done

#读取打包模式
if [ $number == 1 ];then
development_mode=Release
else
development_mode=Debug
fi

#读取更新说明
echo "请填写更新说明:"
read infomation

#build文件夹路径
build_path=${project_path}/"autoBuild"
#plist文件所在路径
exportOptionsPlistPath=${project_path}/"autoBuild/ExportOptions.plist"
#导出.ipa文件所在路径
exportIpaPath=${project_path}/"autoBuild/ipa/${development_mode}"


echo '///-----------'
echo '/// 开始清理工程'
echo '///-----------'

xcodebuild \
clean -configuration ${development_mode} -quiet  || exit

echo '///-----------'
echo '/// 清理完成'
echo '///-----------'


echo '///-----------'
echo '/// 开始编译工程:'${development_mode}
echo '///-----------'

# autoBuildPkg.xcworkspace
#xcodebuild \
#archive -workspace ${project_path}/${project_name}.xcworkspace \
#-scheme ${scheme_name} \
#-configuration ${development_mode} \
#-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit


# autoBuildPkg.xcodeproj
xcodebuild \
archive -project ${project_path}/${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo '///-----------'
echo '/// 编译完成'
echo '///-----------'


echo '///-----------'
echo '/// 开始打包'
echo '///-----------'

xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath}

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo '///-----------'
echo '/// ipa包已导出'
echo '///-----------'
else
echo '///-----------'
echo '/// ipa包导出失败'
echo '///-----------'
fi

echo '///-----------'
echo '/// 完成打包'
echo '///-----------'


#echo '///-----------'
#echo '/// 开始发布'
#echo '///-----------'

#if [ $number == 1 ];then

##验证并上传到App Store
## 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
#altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
#"$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
#"$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  XXX -p XXX -t ios --output-format xml

#echo '///-----------'
#echo '/// 成功上传AppStore'
#echo '///-----------'

#else

#echo '///-----------'
#echo '/// 更新说明:'${infomation}
#echo '///-----------'

# 自动上传到蒲公英
#curl -F "file=@$exportIpaPath/$scheme_name.ipa" \
#-F "uKey=" \
#-F "_api_key=" \
#-F "updateDescription=$infomation" \
#https://www.pgyer.com/apiv1/app/upload

#echo '///-----------'
#echo '/// 成功上传蒲公英'
#echo '///-----------'

#fi


#echo '///-----------'
#echo '/// 开始钉钉通知'
#echo '///-----------'

##卡片样式
#curl -X POST -H 'Content-type':'application/json' -d '{"msgtype":"link","link":{"title": "蒲公英有新更新", "text": "更新说明: '$infomation'", "messageUrl":"https://www.pgyer.com/XXXX"}}' https://oapi.dingtalk.com/robot/send?access_token=XXXX

##纯文本+艾特相关人
##curl -X POST -H 'Content-type':'application/json' -d '{"msgtype":"text","text":{"content":"下载地址: https://www.pgyer.com/XXXX , 更新说明: '$infomation' "},"at":{"atMobiles":["XXXX","XXXX"],"isAtAll":false}}' https://oapi.dingtalk.com/robot/send?access_token=XXXX

#echo '///-----------'
#echo '/// 结束'
#echo '///-----------'

#fi  #Shell脚本没有{}括号，所以用fi表示if语句块的结束

exit 0
