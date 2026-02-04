[MySQL三大日志(binlog、redo log和undo log)详解 | JavaGuide](https://javaguide.cn/database/mysql/mysql-logs.html#日志文件组)

跟着他看看吧，看能够看到哪一步。

[MySQL 被干成老二了？](https://mp.weixin.qq.com/s/APWD-PzTcTqGUuibAw7GGw)，也不妨碍去了解新型数据库，但是，先等待一会。当时还没有意识到问题的严重性，就在这里随便写了一点内容。也高低是有一点后悔的。:anger:. 

[NULL 和 '' 的区别是什么？](https://javaguide.cn/database/mysql/mysql-questions-01.html#null-和-的区别是什么)

[⭐️Boolean 类型如何表示？](https://javaguide.cn/database/mysql/mysql-questions-01.html#⭐️boolean-类型如何表示)

[⭐️手机号存储用 INT 还是 VARCHAR？](https://javaguide.cn/database/mysql/mysql-questions-01.html#⭐️手机号存储用-int-还是-varchar)





### [禁止为程序使用的账号赋予 super 权限](#禁止为程序使用的账号赋予-super-权限)

- 当达到最大连接数限制时，还运行 1 个有 super 权限的用户连接。
- super 权限只能留给 DBA 处理问题的账号使用。

### [对于程序连接数据库账号，遵循权限最小原则](#对于程序连接数据库账号-遵循权限最小原则)

- 程序使用数据库账号只能在一个 DB 下使用，不准跨库。
- 程序使用的账号原则上不准有 drop 权限。

## [推荐阅读](#推荐阅读)

- [技术同学必会的 MySQL 设计规约，都是惨痛的教训 - 阿里开发者](https://mp.weixin.qq.com/s/XC8e5iuQtfsrEOERffEZ-Q)
- [聊聊数据库建表的 15 个小技巧](https://mp.weixin.qq.com/s/NM-aHaW6TXrnO6la6Jfl5A)


