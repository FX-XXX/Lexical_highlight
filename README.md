#环境需求：
linux操作系统 
php环境(建议安装xampp集成环境) 
lex库 
#打开xglex.html
修改添加高亮单词类型，
添加单词或特殊字符
输入需要高亮显示的文件名，点击提交按钮生成html文件。
提交后会自动弹出高亮后的html页面。
（存在延时问题，如第一次生成文件失败，请刷新）
#a.lex是原始文件，修改后执行文件为b.lex
#color是编译后执行高亮的二进制文件，由lex.yy.c生成
#xglex.php是完成修改的执行文件
#其余c文件，html文件为测试文件