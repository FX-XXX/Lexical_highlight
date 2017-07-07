#include <stdio.h>
#include <stdlib.h>
#include "bitree.h"

int main()
{
	int num;
	init_bitree(&bt);
	system("clear");	//for linux
//	system("cls");		//for windows
	printf("\n");
	printf("*****************************************************************\n");
	printf("*	This progrom is an operation for bitree.		*\n");
	printf("*   Programed by wuwennongdao and request for comments.		*\n");  
	printf("*		Email:liuy0711@foxmail.com			*\n");      
	printf("*		Blog: blog.csdn.net/algorithn_only		*\n");      
	printf("*****************************************************************\n\n");
	for (;;) {
		printf("\n[bitree]# ");
		scanf("%d", &num);
		switch (num) {
		case 1:
			printf("Input elemtype to create bitree with preorder:\n"
				"(for exemple: 1 2 3 0 0 4 5 0 6 0 0 7 0 0 0) > ");
			create_bitree(&bt);
			break;
		case 2:
			printf("no recursive traverse:\n");
			printf("Preorder:\t");	preorder_traverse(bt, output_data); 	printf("\n");
			printf("Inorder:\t");	inorder_traverse(bt, output_data);	printf("\n");
			printf("Postorder:\t");	postorder_traverse(bt, output_data);	printf("\n");
			
			printf("recursive traverse:\n");
			printf("preorder:\t");	preorder(bt, output_data);	printf("\n");
			printf("inorder:\t");	inorder(bt, output_data);	printf("\n");
			printf("postorder:\t");	postorder(bt, output_data);	printf("\n");

			printf("level order traverse:");	levelorder_traverse(bt, output_data); 	printf("\n");
			break;
		case 3:
			printf("The number of the leave is : %d\n", get_num_of_leave(bt));
			break;
		case 4:
			printf("The depth of the tree is : %d\n", get_tree_depth(bt));
			break;
		case 5:
			free_bitree(&bt);
			break;
		case 0:
			printf("Please select one operation blow:\n");
			printf("--------------------------------------------------------------\n");
			printf("	1.	Create bitree.\n");
			printf("	2.	traverse bitree.\n");
			printf("	3.	Get the number of the leave.\n");
			printf("	4.	Get the Length of the bitree.\n");
			printf("	5.	Free the bitree.\n");
			printf("	0.	Display the options again.\n");
			printf("	-1.	Exit.\n");
			printf("---------------------------------------------------------------\n");
			break;
		case -1:
			printf("\n------------Thank you for using! bye bye-----------\n\n");
			return 0;
			break;
		default:
			printf("Error options!\n");
			break;
		}
	}
	return 0;
}

