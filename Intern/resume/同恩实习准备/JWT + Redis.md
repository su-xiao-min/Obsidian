

## 🔥 1. JWT + Redis

- 为什么需要双 Token？
- Refresh Token 被盗怎么办？
- Redis 宕机怎么办？
- 如何实现单点登录？
- 如何实现强制踢人下线？

如果你答不出来，说明你只是“照着写”。

回答

1. 简单地说，单token面临一些问题，就比如说，服务器无法主动让token失效，如果有效时间太短，那么用户需要经常登录。
   使用双token之后，第二个token作为刷新Access token的工具，就解决了这个问题。
2. 那就完蛋了。如果能够发现，那么在Redis当中删除就好了，这也是比Access token好的一点，如果没有发现，那么就如同被盗号。Refresh token的保密只能交给TLS来实现。
   话说，既然这样，那么还需要把Refresh token弄成JWT的形式吗？我感觉直接弄成类似于Cookie+SessionId的形式也可以。
3. Redis宕机，一般来说，也就是Access token失效之后用户需要再登录一次，只要Redis可以快速恢复就可以了，影响不大。
4. Refresh token关联的Redis记录当中直接添加字段，记录RegId。
5. 同上。毕竟Redis当中可以写很多内容，不需要像是JWT那样小心翼翼。

# 🔥 一、JWT + Redis —— 你现在属于“能用，但没想透”

---

## ❌ 1. 双 Token 的理解太浅

你说：

> 单 token 不能主动失效

对，但这只是**表层原因**。

真正的问题是：

|方案|状态存储|可控性|
|---|---|---|
|单 JWT|无状态|不可撤销|
|Session|有状态|可控|
|双 Token|半状态|可控 + 轻量|

双 Token的本质：

> 用短生命周期 Access Token 保证性能  
> 用有状态 Refresh Token 保证控制权

不是“为了无感刷新”，而是：

### 👉 把认证拆成

- **频繁校验部分（无状态）**
- **可撤销部分（有状态）**

---

## ❌ 2. Refresh Token 被盗 —— 你回答太随缘

你说：

> TLS保护

这只是传输层保护。真正问题是：

### 攻击场景：

用户手机被 root  
浏览器 XSS  
数据库泄漏

你要回答的是：

### 正确思路：

- Refresh Token 必须：
    - HttpOnly
    - SameSite
    - 绑定设备指纹
    - 存 hash，而不是明文
- 支持 Refresh Token 轮换（rotation）

每刷新一次：

旧 token 作废  
生成新 token

这叫 **Refresh Token Rotation**

否则：

> 攻击者可以无限刷新

## ❌ 3. Redis 宕机 —— 你低估了影响

你说：

> 重新登录就好

这是学生级答案。

企业级答案要说：

- Redis 主从
- 哨兵
- AOF 持久化
- 降级策略

真正问题是：

> 如果 Redis 宕机，Refresh Token 是否全部失效？

如果是，那就是全站强制登出。  
这不是“影响不大”。这是事故。🚨

---

## ❌ 4. 单点登录回答太模糊

你说：

> 加个字段

这不是设计。

真正思路：

### 单点登录实现

- 每个用户只允许一个 Refresh Token
- 新登录时：
    - 删除旧 Refresh Token
    - 写入新的
- Access Token 自然失效

---

## ❌ 5. 强制踢人下线

不是“Redis 能写很多内容”。

而是：

- 维护 token blacklist
- 或删除 refresh token
- 或维护登录版本号（token version）

比如：

JWT 里放 version  
Redis 存当前 version

如果不一致 → 无效

这才是完整回答。