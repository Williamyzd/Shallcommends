# Shallcommends
打包用的一些命令行<br/>
#使用xcodebuild打包,导出ipa
#使用fir.im命令行上传至对应账号
命令行使用说明
1.前提
#安装xcode命令行(检测:终端执行xcodebuild命令)
安装下载地址:https://developer.apple.com/download/more/
#安装fir.im命令行(该命令行也包含打包命令行,但是需要手动输入相关配置,这里仅仅使用了他的上传命令),终端执行命令行:sudo gem install fir-cli
2.存储路径设置
将xcodeArchive文件夹放在你喜欢的位置(主要用来存放打包过程中生成的文件以及打包的配置文件)
#ExportOptions其中的文件主要是打包的配置文件,不用动
#shallscripts存放的脚本文件,正常情况下使用TRSAdHocScripts.command即可
3.使用
########################配置###################################
将TRSAdHocScripts.command/TRSEnterpriseScripts.command放置到工程根路径(同project文件平级)
鼠标右键打开方式选择编译器打开(sbline/xocde)修改以下参数
  ##firToken  去fir.im账号获取apitoken
  ##configuration_setting 正常是release
  ##xcodeArchiveFiles_path  将xcodeArchive文件夹的绝对路径
  ##production_type   默认选0即可,使用adhoc方式;企业版使用1
  ##fir.im上传支持修改短连接:-s "$app_name"+"ios"  但是总是修改不成功,报400错误,但是不影响上传
########################使用###################################
双击*command文件即可
#工程中会生成build文件夹,其实是空的,可以忽略掉
