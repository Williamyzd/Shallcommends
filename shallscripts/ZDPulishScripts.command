#! /bin/bash
echo "=================================准备工作========================================"
#需要修改的参数=========开始===========
#bundleid
#PRODUCT_BUNDLE_IDENTIFIER
#PROVISIONING_PROFILE
#fir.im 应用上传的token,登陆fir.im可见
firToken=""
#debug or relase
configuration_setting="Release"
#打包存储路径以及配置根路径
xcodeArchiveFiles_path=""
#企业版还是AdHoc版:
#0:AdHoc版;1:企业版
production_type="1"



#需要修改的参数=========结束===========



#以下代码用来切换至项目路径
D=$0
echo "脚本文件地址:$D"
project_path=$(dirname $D)
echo "切换路径到:$project_path"
cd $project_path

#获取系统时间,用来命名生成的文件
current_date=$(date "+%Y-%m-%d %H-%M-%S")
echo "当前时间:$current_date"
find 


#获取工程名字
workplace_name=$(basename $(find . -name "*.xcworkspace" -maxdepth 1))
app_name=${workplace_name%%.*}
project_name=""

if [[ ! -n "$workplace_name" ]]; then
	project_name=$(basename $(find . -name "*.xcodeproj" -maxdepth 1))
	app_name=${project_name%%.*}
fi
echo "截取到的工程名字是:$app_name"

if [[ -n "$workplace_name" ]]; then
echo "=================================pod升级========================================"
pod  update
fi

echo "=================================清理缓存========================================"
xcodebuild clean -configuration "$configuration_setting"

echo "=================================开始archive===================================="
#有无workplace
archivePath="$xcodeArchiveFiles_path/archive/$app_name$current_date/$app_name.xcarchive"
if [[ -n "$workplace_name" ]]; then
	xcodebuild archive -workspace "$workplace_name" -scheme "$app_name" -configuration "$configuration_setting"  -archivePath "${archivePath}" 
else
	xcodebuild archive -project "$project_name" -scheme "$app_name"  -configuration "$configuration_setting"  -archivePath "${archivePath}"  
fi



echo "=================================开始导出ipa===================================="
#ipa导出地址
exportPath="$xcodeArchiveFiles_path/ipas/$app_name$current_date"
#配置文件地址
optiontype="EnterpriseExportOptions.plist"
if [[ "$production_type" -eq "0" ]]; then
	optiontype="AdHocExportOptions.plist"
fi
exportOptionsPath="$xcodeArchiveFiles_path/ExportOptions/$optiontype"
if [[ ! -f "$exportOptionsPath" ]]; then
echo "配置文件exportOptionsPath不存在,期望地址:$exportOptionsPath"
exit
fi

xcodebuild -exportArchive -archivePath "${archivePath}"  -exportPath "${exportPath}"  -exportOptionsPlist "${exportOptionsPath}"
echo "=================================上传fir.im===================================="
ipaPath="$exportPath/$app_name.ipa"
if [[ ! -f "$ipaPath" ]]; then
echo "ipa文件不存在,期望地址:$ipaPath"
exit
fi

echo "要上传的ipa文件地址:$ipaPath"
#前提是要安装fir.ci命令行 终端执行 sudo gem install fir-cli
#添加短连接会报400错误 -s "$app_name"+"ios"
fir publish "${ipaPath}" -T "${firToken}" -c "脚本打包:$current_date"

echo "=================================上传成功====================================="
echo "============================我是一条华丽的分割线================================"
exit





