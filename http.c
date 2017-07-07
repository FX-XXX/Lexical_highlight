#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <netdb.h>
#include <unistd.h>
#define BUFFSIZE 4096
#define TEXT_BUFFSIZE 1024
#define PORT 80

void geturl(char *url) {
	char myurl[BUFFSIZE], host[BUFFSIZE], 
		GET[BUFFSIZE], request[BUFFSIZE],
		text[BUFFSIZE], *phost = 0;
	int socketid, connectid, res, recvid, flag = 1;
	struct hostent *purl = NULL;
	struct sockaddr_in sockinfo;

	memset(myurl, 0, BUFFSIZE);
	memset(host, 0, BUFFSIZE);
	memset(GET, 0, BUFFSIZE);
	strcpy(myurl, url);
	// 设置连接信息结构
	memset(&sockinfo, 0, sizeof(struct sockaddr_in));
	sockinfo.sin_family = AF_INET;
	sockinfo.sin_addr.s_addr = *((unsigned long *)purl->h_addr_list[0]);
	sockinfo.sin_port = htons(PORT);

	// 构造http请求
	memset(request, 0, BUFFSIZE);
	strcat(request, "GET ");
	strcat(request, GET);
	strcat(request, " HTTP/1.1\r\n");
	// 以上为http请求行信息
	strcat(request, "HOST: ");
	strcat(request, host);
	strcat(request, "\r\n");
	strcat(request, "User-Agent: ");
	strcat(request, "2333 Browser");
	strcat(request, "\r\n");
	strcat(request, "Author: ");
	strcat(request, "By Jiavan&Keeln&LZY");
	strcat(request, "\r\n");
	strcat(request,"Cache-Control: no-cache\r\n\r\n");

	// 连接到远端服务器
	connectid = connect(socketid, (struct sockaddr*)&sockinfo, sizeof(sockinfo));
	if (connectid == -1) {
		printf("连接远端服务器失败\n");
		exit(1);
	}
	printf("-> 连接到远端服务器成功\n");

	// 向服务器发送GET请求
	res = send(socketid, request, strlen(request), 0);
	if (res == -1) {
		printf("向服务器发送GET请求失败\n");
		exit(1);
	}
	printf("-> 发送GET请求成功，共发送了%d bytes\n", res);
	printf("-> HTTP请求报文如下\n--------HTTP Request--------\n%s\n", request);
	printf("-> HTTP响应内容正在重定向至index.html\n");

	// 接受服务器的响应
	if (freopen("index.html", "w", stdout) == NULL) {
		printf("输出重定向错误\n");
		exit(1);
	} else {
		while (flag) {
			memset(text, 0, TEXT_BUFFSIZE);
			int bufflen = recv(socketid, text, TEXT_BUFFSIZE, 0);
			
			if (bufflen < 0) {
				printf("接收数据流出错\n");
				fclose(stdout);
				close(socketid);
				exit(1);
			}
			if (bufflen > 0) {
				printf("%s\n", text);
			} else {
				flag = 0;
			}
		}
	}
	fclose(stdout);
	close(socketid);
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		printf("请输入正确的URL参数\n");
		exit(1);
	}
	geturl(argv[1]);
	return 0;
}
