什么是多路复用？

- 多路： 指的是多个socket网络连接
- 复用： 指的是复用一个线程检测多个文件描述符的就绪状态

多路复用的常用技术

- select
- poll
- epoll typora

五种 I/O 策略

1. 阻塞I/O，经典咏流传
2. 轮询I/O
3. 回调I/O  
4. 

真的不知道了。

I/O的两个阶段

1. 数据准备阶段
2. 复制回进程缓冲区的阶段


  select

相关伪代码
```c 
int select(
  int nfds,
  fd_set *readfds,
  fd_set *writefds,
  fd_set *exceptfds,
  struct timeval *timeout);
)
```

懒得写实现了，我们直接开始走。

然后我们看一下poll的实现，它其实就是select的一种优化而已。它使用pollfd

之后就是我们的 epoll ，它使用红黑树，最大的特点在于，出现了问题的响应的时候，不需要完全返回。所以，性能更高。

以上就是我在学习`I/O`多路复用的时候的一些感受，请你扮演一个严格的老师，指出来我理解存在的问题，并且给我提出建议。




```
```
