%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>

//输出格式串定义，此处添加高亮颜色
const char *fmt_number = "<span style=""color:Red>%s""<""/span>";
const char *fmt_keyword = "<span style=""color:Blue>%s""<""/span>";
const char *fmt_ctype = "<span style=""color:Purple>%s""<""/span>";
const char *fmt_lcomment = "<span style=""color:LimeGreen>%s""<""/span>""<br>";
const char *fmt_bcomment1 = "<span style=""color:LimeGreen>";         ///!!
const char *fmt_bcomment2 = "<""/span>""<br>";                  ///!!
const char *fmt_string = "<span style=""color:Orange>%s%c""<""/span>";   ///!!
const char *fmt_char = "<span style=""color:Navy>%s%c""<""/span>""<br>";       ///!!
const char *fmt_normal = "<span>%s""<""/span>";          //default: black
const char *fmt_preproc = "<span style=""color:Brown>%s""<""/span>";
%}
//正则规则
digit           [0-9]
xdigit          [0-9a-fA-F]
odigit          [0-7]

decnum          (0(\.{digit}+)?)|([1-9]{digit}*(\.{digit}+)?)
octnum          0{odigit}+
hexnum          0(x|X){xdigit}+
number          {decnum}|{octnum}|{hexnum}
lcomment        \/\/.*
string          \"[^"]*
char              \'[^']*
normal          [a-zA-Z_]+[a-z0-9A-Z_]*
preproc         #.*

keyword1        break|case|continue|default|do|else|enum
keyword2        extern|for|goto|if|return|sizeof|struct
keyword3        switch|typedef|union|volatile|while
keyword4        catch|class|delete|friend|inline|new|operator
keyword5        private|protected|public|template|this|throw|try|virtual
ctype1          auto|char|const|double|float|int|long|register
ctype2          short|signed|static|unsigned|void|bool

keyword         {keyword1}|{keyword2}|{keyword3}|{keyword4}|{keyword5}
ctype           {ctype1}|{ctype2}

%x comment

%%

"/*" {
//注释下内容高亮
        printf(fmt_bcomment1);
        ECHO;
        BEGIN(comment);
}
        <comment>[^*\n]* ECHO;
        <comment>"*"+[^*/\n]* ECHO;
        <comment>\n ECHO;
        <comment>"*"+"/" {
                BEGIN(INITIAL);
                ECHO;
                printf(fmt_bcomment2);
        }

{number} {
//数字参数高亮
        printf(fmt_number, yytext);
}
{keyword} {
//关键词高亮
        printf(fmt_keyword, yytext);
}
{ctype} {
//特殊字符高亮
        printf(fmt_ctype, yytext);
}
{lcomment} {
        printf(fmt_lcomment, yytext);
}
{string} {
//单行注释高亮
        if (yytext[yyleng - 1] == '\\') {
                int i;
                int more = 1;
                for (i = yyleng - 2; i >= 0; i--) {
                        if (yytext[ i ] == '\\') more = !more;
                        else break;
                }
                if (more) yymore();
                else printf(fmt_string, yytext, input());
        } else {
                printf(fmt_string, yytext, input());
        }
}
{char} {
//字符串显示规则
        if (yytext[yyleng - 1] == '\\') {
                int i;
                int more = 1;
                for (i = yyleng - 2; i >= 0; i--) {
                        if (yytext[ i ] == '\\') more = !more;
                        else break;
                }
                if (more) yymore();
                else printf(fmt_char, yytext, input());
        } else {
                printf(fmt_char, yytext, input());
        }
}
{normal} {
//不高亮的字符串
        printf(fmt_normal, yytext);
}
{preproc} {
//井号开头高亮显示
        printf(fmt_preproc, yytext);
}
\n {printf("<br>",yytext);}
//换行符规则

%%

void printhelp()
{
//输入规则帮助函数
        char *h =
        "Usage: color [input file] [output file]\n\n";

        fprintf(stderr, "%s\n", h);
}

int main(int argc, char **argv)
{
//主函数 第一个参数为要修改的文件名
        if (argv[1]) {
        //如果输入-h或者--help调用帮助函数
                if (strcmp(argv[1], "--help") == 0 ||
                    strcmp(argv[1], "-h") == 0) {
                        printhelp();
                        return 0;
                }
                if (freopen(argv[1], "r", stdin) == NULL) {
                        fprintf(stderr, "cannot open input file %s\n", argv[1]);
                        return -1;
                        //读写文件如果失败就跳出返回报错
                }
        }
        if (argv[2]) {
        //输出第二个参数是生成文件文件名，如果输入打印在命令行
                if (freopen(argv[2], "w", stdout) == NULL) {
                        fprintf(stderr, "cannot open output file %s\n", argv[1]);
                        return -1;
                        //读写文件如果失败就跳出返回报错
                }
                printf("<!DOCTYPE><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><title>code highlight</title><style type='text/css'>ol{background:rgb(236, 240, 245)}</style></head><body><h2>Code Highlight</h2><ol>");
                //输出生成html文件头文件
        }

        yylex();
        return 0;
}

int yywrap()
{
        return 1;
        //语法循环判别语句
}
