```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("location of code : %p\n", (void *)main);
    printf("location of heap : %p\n", (void *)malloc(1));
    int x = 3;
    printf("location of stack : %p\n", (void *) &x);
    return x;
}
```



解释一下这段代码，我正在学习操作系统，我很好奇，为什么使用  printf("location of code : %p\n", (void *)main);就可以得到代码的虚拟地址呢？
请你着重从C语言的语法给我解释一下