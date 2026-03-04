我正在学习Redis
我注意到Redis的原子性操作需要借助lua，

问题是，
Redis使用C语言编写，
为什么需要借助Lua实现原子性操作呢？

Lua怎么保证原子性的？

Lua的语法简要说明一下，
尤其是和Redis相关的部分，

举出几个使用Redis过程中需要用到Lua的地方，
比如说，
Redisson当中。

再给我提供一些Redis的思考题。

你这个问题还算有点意思。总算不是“Redis 是不是单线程所以很快”那种水平的疑问了。🙂

我们一层一层拆。

---

# 一、Redis 都是 C 写的，为什么还要 Lua？

表面上看确实很奇怪：

> 既然 Redis 是 C 写的，我在客户端发多条命令不就行了？为什么还要搞个 Lua？

核心原因只有一个：

## 👉 **客户端多条命令 ≠ 原子**

Redis 的“单线程”只保证：

- 一条命令执行期间不会被打断

但它**不保证多条命令之间没有插入**。

举个典型场景：

```text
1. GET key
2. 判断
3. INCR key
```

如果你在客户端写：

```java
if (redis.get("k") < 10) {
    redis.incr("k");
}
```

你觉得没问题。

现实是：

```
客户端A：GET k → 9
客户端B：GET k → 9
客户端A：INCR k → 10
客户端B：INCR k → 11
```

炸了。

---

## 那为什么不用事务（MULTI/EXEC）？

事务能解决一部分问题，但有两个缺陷：

1. **事务里不能做逻辑判断**
2. WATCH 是乐观锁，冲突要重试

而 Lua 是：

> 在服务器内部执行完整逻辑
> 一次性运行
> 中间不允许插入其他命令

这就是它存在的意义。

---

# 二、Lua 是怎么保证原子性的？

这点非常简单：

## Redis 执行 Lua 脚本时：

- 把整个脚本当成一条命令
- 单线程执行
- 执行期间不处理其他请求

本质就是：

```
EVAL script
```

被 Redis 当成一个超大的“原子命令”。

注意：

Lua 本身不保证原子性。

是 Redis 的执行模型保证：

> Lua 在 Redis 里是同步、单线程执行。

如果 Lua 在多线程环境中运行，那就不原子了。

---

# 三、Lua 和 Redis 结合的语法

Lua 语法非常简单，比 Java 清爽很多。

## 1️⃣ 基本语法

```lua
-- 变量
local a = 10

-- if
if a > 5 then
    return 1
else
    return 0
end
```

没有大括号。
没有分号。
if 必须 end。

---

## 2️⃣ Redis 中的两个特殊变量

在 Redis Lua 里有两个非常重要的数组：

| 名称 | 含义       |
| ---- | ---------- |
| KEYS | 传入的 key |
| ARGV | 传入的参数 |

比如：

```lua
EVAL "return redis.call('GET', KEYS[1])" 1 mykey
```

这里：

```
KEYS[1] = "mykey"
```

---

## 3️⃣ 调用 Redis 命令

Lua 调 Redis 用：

```lua
redis.call()
redis.pcall()
```

区别：

- call → 出错直接报错
- pcall → 捕获错误返回

例子：

```lua
local value = redis.call("GET", KEYS[1])

if not value then
    redis.call("SET", KEYS[1], ARGV[1])
    return 1
end

return 0
```

---

# 四、典型必须用 Lua 的场景

你在做后端，这些场景很常见。

---

## 1️⃣ 分布式锁（Redisson）

以 **Redisson** 为例：

Redisson

它的 `tryLock()` 底层就是 Lua。

加锁脚本核心逻辑是：

```lua
if (redis.call("exists", KEYS[1]) == 0) then
    redis.call("hset", KEYS[1], ARGV[2], 1)
    redis.call("pexpire", KEYS[1], ARGV[1])
    return nil
end
```

必须原子执行，否则会出现：

- 锁重复
- 过期时间丢失

---

## 2️⃣ 限流（令牌桶 / 滑动窗口）

比如：

- 判断当前访问次数
- 如果小于阈值 → INCR
- 否则拒绝

必须：

> 判断 + 修改 在同一原子逻辑里

---

## 3️⃣ 秒杀库存扣减

经典问题：

```
库存 > 0 ?
    扣减
    记录用户
```

如果不原子，库存会变负。

---

## 4️⃣ 延迟队列 / Zset 消费

你要：

```
ZRANGEBYSCORE
ZREM
```

这两条必须打包，否则会重复消费。

---

# 五、Lua vs 事务

| 特性         | 事务 | Lua  |
| ------------ | ---- | ---- |
| 原子性       | 是   | 是   |
| 支持逻辑判断 | ❌   | ✅   |
| 支持循环     | ❌   | ✅   |
| 性能         | 一般 | 高   |
| 可读性       | 好   | 一般 |

本质：

Lua = 服务器端逻辑执行。

---

# 六、Redis + Lua 的风险

别只看到优点。

### 1️⃣ 阻塞问题

Lua 执行期间 Redis 不处理其他请求。

如果脚本写成 O(n²)，整个 Redis 卡死。

### 2️⃣ 集群问题

在 Redis Cluster 中：

> 所有 key 必须在同一 slot。

否则报错。

---

# 七、为什么不用别的脚本语言？

Redis 选 Lua 是因为：

- 轻量级
- 嵌入式简单
- 可控
- 没有复杂标准库
- 执行时间短

如果你嵌入 Python，Redis 直接变成 JVM。

---

# 八、思考题（给你一点压力）

你准备后端面试，这些问题会被追问。

---

### 1️⃣ Lua 脚本如何持久化？

AOF 会如何记录？

---

### 2️⃣ Lua 在主从复制中如何传播？

是传播脚本还是传播结果？

---

### 3️⃣ Redis 7 之后为什么推荐使用 Functions 而不是 EVAL？

---

### 4️⃣ 如果 Lua 脚本执行时间过长怎么办？

Redis 如何限制？

---

### 5️⃣ 为什么 Redisson 不用事务实现分布式锁？

---

### 6️⃣ 如果 Lua 执行期间 Redis 崩溃，会发生什么？

---

### 7️⃣ Lua 脚本是否支持回滚？

为什么？

---

你现在的阶段，已经从“会用 Redis”开始进入“理解 Redis 设计哲学”的阶段了。

这很好。

但别沉迷“我懂了”的幻觉。

真正的理解是：

> 你能在白板上写出一个分布式锁 Lua 脚本
> 并解释每一行为什么存在

做到这个，再说你真的掌握了。 🧠
