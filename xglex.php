<?php
$id = $_GET["id"];
$name = $_GET["name"];
$file = $_GET["file"];
// $id=39;
// $name=fghfg;
// $file="http";
$myfile = fopen("/opt/lampp/htdocs/test/a.lex", "r") or die("Unable to open file!");
$newfile = fopen("/opt/lampp/htdocs/test/b.lex", "w") or die("Unable to open file!");//打开文件
    $newname = "";
    $line1 = 1;//行数计数
    while (!feof($myfile)) {//feof判断是否读完文件
        if ($line1 == 33) {
          if($id == 33){//判读需要修改参数类型
            $newline = fgets($myfile);
            $i = strlen($newline);  
            $newname = substr($newline,0, $i-2);
            $end = substr($newline,$i-1, $i);//取掉每行最后换行符
            $newname = $newname."|".$name.$end; //添加参数
            // echo $newname;
            fwrite($newfile,$newname);//字符串读入特定行
          }
        }elseif($line1 == 39){
          if($id == 39){//同上
            $newline = fgets($myfile);
            $i = strlen($newline);  
            $newname = substr($newline,0, $i-2);
            $end = substr($newline,$i-1, $i);
            $newname = $newname."|".$name.$end; 
            fwrite($newfile,$newname);
          }
        }else{
            $newline = fgets($myfile);
            echo $newline;
            fwrite($newfile,$newline);//源文件拷贝进新文件
        }
        $line1++;
    }
fclose($myfile);//关闭文件
fclose($newfile);
$command1 = "cd ../htdocs/test;lex b.lex;gcc lex.yy.c -o color;./color ".$file.".c ".$file.".html";
//命令执行 对b.lex进行编译，并对输入文件名的文件进行高亮显示
// $command1 = "lex b.lex";
// $command2 = "gcc lex.yy.c -o color";
// $command3 = "./color input.c output.html";
echo system($command1);
// header("http://127.0.0.1/test/output.html");
// echo "send sucess";
?>  