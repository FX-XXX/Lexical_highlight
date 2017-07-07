%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>

//格式串定义
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

keyword1        break|case|continue|default|do|else|enu|ssdd
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
        printf(fmt_number, yytext);
}
{keyword} {
        printf(fmt_keyword, yytext);
}
{ctype} {
        printf(fmt_ctype, yytext);
}
{lcomment} {
        printf(fmt_lcomment, yytext);
}
{string} {
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
        printf(fmt_normal, yytext);
}
{preproc} {
        printf(fmt_preproc, yytext);
}
\n {printf("<br>",yytext);}

%%

void printhelp()
{
        char *h =
        "Usage: cucolor [input file] [output file]\n\n";

        fprintf(stderr, "%s\n", h);
}

int main(int argc, char **argv)
{
        if (argv[1]) {
                if (strcmp(argv[1], "--help") == 0 ||
                    strcmp(argv[1], "-h") == 0) {
                        printhelp();
                        return 0;
                }
                if (freopen(argv[1], "r", stdin) == NULL) {
                        fprintf(stderr, "cannot open input file %s\n", argv[1]);
                        return -1;
                }
        }
        if (argv[2]) {
                if (freopen(argv[2], "w", stdout) == NULL) {
                        fprintf(stderr, "cannot open output file %s\n", argv[1]);
                        return -1;
                }
                printf("<!DOCTYPE><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><title>code highlight</title><style type='text/css'>ol{background:rgb(236, 240, 245)}</style></head><body><h2>Code Highlight</h2><ol>");
        }

        yylex();
        return 0;
}

int yywrap()
{
        return 1;
}
