## 一、抛砖引玉：探索[Spring IoC容器](https://zhida.zhihu.com/search?content_id=105486070&content_type=Article&match_order=1&q=Spring+IoC容器&zhida_source=entity)

简单地说，

Spring解决的是依赖注入的问题，

Spring Boot则把这一切自动化了。

它会在应用启动的时候，加载配置文件或者注解解析，把应用注册在表当中，
过程涉及依赖解析等比较繁琐的操作。



## 二、夯实基础：JavaConfig与常见Annotation

人们不满XML，其实我也不是很喜欢，
你说为什么pom文件还使用XML这种古老丑陋的方式……
Maven怎么不更新迭代一下呢？

## 四、另一件武器：Spring容器的事件监听机制

伟大的事件监听。
怎么说呢，我们项目的前端使用了消息总线，emitter 和 on，用得挺多的，但是
但是后端确实是没有怎么使用。
需要的逻辑一般都自己手动实现。
我感觉，
算了，
暂时没有想到。
其实消息推送的服务确实适合监听，
但是，
这里情况很简单，
我们直接串行写应该复杂度也很低。

当年就这个问题写过一点东西，
现在都不知道放在什么地方了。

写得太好了，
感觉就算是明天询问Spring，
我高低也能够说出来几句话了。