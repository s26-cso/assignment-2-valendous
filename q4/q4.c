#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <dlfcn.h>
#define ll long long
int main () {
    char opcode[20];
    int a,b;
    void* libpointer=NULL;
    char libraryname[20];
    int (*func) (int,int); // fucntion pointer
    while(scanf("%5s %d %d",opcode,&a,&b)==3) {
        if(libpointer!=NULL) dlclose(libpointer);
        sprintf(libraryname,"lib%s.so",opcode);
        libpointer=dlopen(libraryname,1);//only get to the funcs when called faster but seg fault 
        func=dlsym(libpointer,opcode);
        int ans=func(a,b);
        printf("%d\n",ans);
    }
    if(libpointer!=NULL) dlclose(libpointer);
    return 0;
}