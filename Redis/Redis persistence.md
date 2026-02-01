Redis' three persistence ways

## RDB

The RDB persistence is to create a snapshot of the copy of a time,
After 快照创建，
就可以快乐的复制重建了，

RDB是怎么生成的
是我们fork一个子进程，
子进程执行，
不会阻塞主线程。
为什么选择子进程？
我看过这个问题，
主要是，
因为子线程炸了，
那么主线程跟着炸，
但是进程就相对隔离一些。

至于说内存问题，
这个问题不大，
我们可以开心快乐的互相映射，
实际地址和虚拟地址，
这就是操作系统的作用。

其实还有一点，
就是你既然写快照，
那么那边还在写应该怎么办，
当然是，
copyonwrite，
这样就不会影响我们的主线程。

而且写也是分离的，
先写到AOF缓冲区，
再写到AOF文件，
再根据持久化方式fsync策略<
再写到文件

保存的位置可以自定义。

## AOF
