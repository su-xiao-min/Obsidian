我草，
我说为什么我对于Redis集群一点印象都没有，
因为这东西你JavaGuide当中根本不提供。
而二哥那里也没有。
看来我只能找
找我们伟大的知乎

[Redis 集群](https://weread.qq.com/web/reader/d5432be0813ab98b6g0133f5k0aa32fc02bf0aa1883c60ae)

好了，
这里还有一本书可以看，
我们看书吧。

你卡过最厉害的bug是什么？ - 花宝宝的回答 - 知乎
https://www.zhihu.com/question/316703576/answer/1987175670867055855

上面说的很对，
你卡过最厉害的bug是什么？ - 花宝宝的回答 - 知乎
https://www.zhihu.com/question/316703576/answer/1987175670867055855

我当时就不知道。

Redis Cluster 提供 Sharding，诶
诶，
这个怎么和我们的Elasticsearch一样诶。
采用哈希槽进行数据分布，每一个节点负责一部分槽，根据key存入相应的槽位。

1. 高可用性
2. 无中心架构
3. 主从架构
4. 故障恢复
5. 自动选择主节点
6. 支持扩展，Scalability

哈希算法非常简单，
有16384个槽位
HASH_SLOT = CRC16(key) % 16384

读写分离
写操作由Master处理，
度节点从Slave处理，
提高效率

在数据一致性方面，
Redis Cluster遵从AP，
「有时间我得把其他的C也找到
高低要对比学习，加深对于分布式的理解！」`ノ( º _ ºノ)`

## Redis 故障恢复

Sentinel监视，
Master 宕机，
超时未响应，
则Slave升级为Master
Slave宕机不影响，
但是尽快恢复。

当时还有一个Redis的读写策略，
