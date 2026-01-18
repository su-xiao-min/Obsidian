## Mybatis Pro激活码

518c8a08-6915-467c-8903-2c19c24312b8

309fe813-1f15-4a51-abe9-530f13b123a8

购买了，就购买了，无所谓了，反正之后我也会在java上面用很多时间，所以，破釜沉舟。



本来是想直接看书的，但是现在放弃了，感觉看书确实看不明白。图灵学院，java guide

Mybatis是一个持久层框架，ORM，支持SQL，免除JDBC代码，结果可以很简单的封装。

减少代码量

我终于知道为什么出问题了，还是因为我对于命名空间的理解不够深入。

看一看官方文档：

就我自己的理解

设置config文件

在config文件里面指定Mapper.xml文件的位置

在mapper.xml文件中写语句。

创建一个mapper接口，对应mapper.xml里面的namespace，

然后调用的时候，

```java
    public void test() throws IOException {
        InputStream in = Resources.getResourceAsStream("mybatis-config.xml");
        SqlSessionFactory fac = new SqlSessionFactoryBuilder().build(in);
        try (SqlSession session = fac.openSession()){
        EmpMapper mapper = session.getMapper(EmpMapper.class);}
    }
```

参数

这里第二行是读取xml文件，

第三行左边是工厂模式，一个重量级的工厂，右边是一个构造器。

第四行启动一个connection，

第五航采取动态代理。

## @Param

在 MyBatis 中，`@Param`注解用于在映射器接口的方法中为参数命名。这使得你可以在 XML 映射文件中通过参数名称来引用这些参数，而不是通过位置索引。这在处理多个参数时特别有用，可以提高代码的可读性和可维护性。


作用


• 命名参数：

• `@Param`注解为方法参数提供了一个名称，这个名称可以在 XML 映射文件中使用。

• 例如，在`@Select`注解中，你可以通过`${column}`和`#{value}`来引用方法参数。


• 支持动态 SQL：

• 通过`@Param`注解，你可以在 SQL 语句中动态使用参数，而不需要依赖于位置索引。

• 这使得 SQL 语句更加灵活，特别是在处理动态列名或表名时。


示例


映射器接口


```java
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface UserMapper {
    @Select("SELECT * FROM user WHERE ${column} = #{value}")
    User findByColumn(@Param("column") String column, @Param("value") String value);
}
```



XML 映射文件（可选）

虽然在注解中可以直接使用`@Param`，但在 XML 映射文件中也可以使用`@Param`注解的参数名称。


```xml
<mapper namespace="com.example.mapper.UserMapper">
    <select id="findByColumn" parameterType="map" resultType="User">
        SELECT * FROM user WHERE ${column} = #{value}
    </select>
</mapper>
```



详细解释


1.命名参数

在 MyBatis 中，`@Param`注解为方法参数提供了一个名称，这个名称可以在 SQL 语句中使用。例如：


```java
@Select("SELECT * FROM user WHERE ${column} = #{value}")
User findByColumn(@Param("column") String column, @Param("value") String value);
```



• `${column}`：表示动态列名，使用`@Param("column")`注解的参数值。

• `#{value}`：表示参数值，使用`@Param("value")`注解的参数值。


2.支持动态 SQL

`@Param`注解支持动态 SQL，使得 SQL 语句更加灵活。例如，你可以动态指定列名或表名：


```java
@Select("SELECT * FROM ${table} WHERE ${column} = #{value}")
User findByColumn(@Param("table") String table, @Param("column") String column, @Param("value") String value);
```



3.多参数支持

`@Param`注解特别适用于处理多个参数的情况。例如：


```java
@Select("SELECT * FROM user WHERE name = #{name} AND age = #{age}")
User findByColumn(@Param("name") String name, @Param("age") int age);
```



注意事项


• 动态列名和表名：

• 使用`${}`语法时，MyBatis 会直接替换字符串，因此需要注意 SQL 注入问题。确保传入的列名和表名是安全的，避免用户输入直接作为列名或表名。

• 例如：

```java
     @Select("SELECT * FROM ${table} WHERE ${column} = #{value}")
     User findByColumn(@Param("table") String table, @Param("column") String column, @Param("value") String value);
```



• 参数类型：

• `@Param`注解可以用于任何类型的参数，包括基本类型、包装类型、字符串等。

• 例如：

```java
     @Select("SELECT * FROM user WHERE name = #{name} AND age = #{age}")
     User findByColumn(@Param("name") String name, @Param("age") int age);
```



• 多个参数：

• 如果方法有多个参数，建议使用`@Param`注解为每个参数命名，以提高代码的可读性和可维护性。

• 例如：

```java
     @Select("SELECT * FROM user WHERE name = #{name} AND age = #{age}")
     User findByColumn(@Param("name") String name, @Param("age") int age);
```



总结

`@Param`注解在 MyBatis 中用于为方法参数命名，使得你可以在 SQL 语句中通过参数名称来引用这些参数。这不仅提高了代码的可读性和可维护性，还支持动态 SQL，使得 SQL 语句更加灵活。通过合理使用`@Param`注解，可以编写出更加清晰和灵活的 MyBatis 映射器方法。



## XML

XML头部那一串东西到底是什么？

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
```

这个是一个约束。

## 日志技术

Log4j 和 Logback 都是流行的 Java 日志框架，它们在功能和设计上有很多相似之处，但也有一些关键的区别。了解它们的关系和区别可以帮助你更好地选择适合你项目的日志框架。


1.历史背景


• Log4j：

• 起源：Log4j 是最早的 Java 日志框架之一，由 Ceki Gülcü 开发，最初发布于 1999 年。

• 版本：Log4j 1.x 是非常流行的版本，广泛用于许多 Java 项目。Log4j 2.x 是 Log4j 的一个重大更新，引入了许多新特性和改进。

• 特点：Log4j 1.x 和 2.x 在设计上有所不同，2.x 版本在性能和功能上都有显著提升。


• Logback：

• 起源：Logback 由 Log4j 的创始人 Ceki Gülcü 开发，最初发布于 2006 年。

• 特点：Logback 是 Log4j 的一个改进版本，旨在解决 Log4j 1.x 的一些问题，并引入了许多新特性。


2.关系


• Logback 是 Log4j 的改进版本：

• Logback 保留了 Log4j 的许多核心概念，如 Appender、Layout 和 Logger，但进行了改进和优化。

• Logback 旨在提供更好的性能、更高的灵活性和更少的内存占用。


• SLF4J（Simple Logging Facade for Java）：

• 作用：SLF4J 是一个日志门面（Facade），提供了一个统一的日志接口，使得应用程序可以在运行时选择具体的日志实现。

• 关系：Logback 是 SLF4J 的一个实现，而 Log4j 2.x 也支持 SLF4J。通过 SLF4J，你可以轻松地在 Logback 和 Log4j 之间切换。


3.功能和性能对比


功能


• Log4j 2.x：

• 异步日志：支持异步日志记录，提高性能。

• 动态配置：支持动态配置文件，可以在运行时重新加载配置。

• 插件系统：支持插件系统，可以扩展日志功能。

• 性能：在性能上进行了优化，特别是在高并发环境下表现更好。


• Logback：

• 异步日志：支持异步日志记录，提高性能。

• 自动重新加载：支持自动重新加载配置文件，无需重启应用程序。

• 性能：在性能上进行了优化，特别是在高并发环境下表现更好。

• 灵活性：提供了更多的配置选项和扩展点。


性能


• Log4j 2.x：

• 性能：Log4j 2.x 在性能上进行了优化，特别是在高并发环境下表现更好。

• 异步日志：支持异步日志记录，可以显著提高性能。


• Logback：

• 性能：Logback 在性能上进行了优化，特别是在高并发环境下表现更好。

• 异步日志：支持异步日志记录，可以显著提高性能。


4.选择建议


• Log4j 2.x：

• 适用场景：如果你需要一个功能强大、性能优化的日志框架，并且希望使用 SLF4J 作为日志门面，Log4j 2.x 是一个不错的选择。

• 优势：支持异步日志、动态配置、插件系统等高级特性。


• Logback：

• 适用场景：如果你需要一个灵活、高性能的日志框架，并且希望使用 SLF4J 作为日志门面，Logback 是一个不错的选择。

• 优势：支持异步日志、自动重新加载配置文件、更多的配置选项。


5.示例代码


Log4j 2.x 配置


```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss} [%t] %-5level %logger{36} - %msg%n"/>
        </Console>
    </Appenders>
    <Loggers>
        <Root level="info">
            <AppenderRef ref="Console"/>
        </Root>
    </Loggers>
</Configuration>
```



Logback 配置


```xml
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    <root level="info">
        <appender-ref ref="STDOUT"/>
    </root>
</configuration>
```



6.总结

Log4j 和 Logback 都是流行的 Java 日志框架，Logback 是 Log4j 的改进版本，提供了更好的性能和更高的灵活性。通过 SLF4J，你可以轻松地在 Logback 和 Log4j 之间切换。选择哪个框架取决于你的具体需求，包括功能、性能和灵活性。在大多数情况下，Logback 是一个非常不错的选择，特别是在需要高性能和灵活配置的场景中。

```
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.17</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.5.18</version>
        </dependency>
```

依赖差不多就是这样，可以记录到文件里面。

配置文件，从官方网站找一下，然后自己配置就好了，感觉，无论如何，读官方文档还是十分必要的。

## Maven

Maven真的是一个好东西，我后悔之前没有好好学习，感觉其中操作的细节实在是太多了。

## 参数传递

两种参数传递。

单个参数，随意。

多个参数，分类讨论。

传递arg0或者param1

或者对象

或者一个map，其实和前面一样，只不过前面是自己封装成map。

或者使用@Param这种方法。



在 MyBatis 中，如果不使用`@Param`注解，直接根据参数的名字来进行赋值是不支持的。MyBatis 默认情况下是通过参数的位置来绑定参数的，而不是通过参数的名字。因此，如果方法有多个参数，必须使用`@Param`注解来为每个参数命名，以便在 SQL 语句中通过参数名称来引用这些参数。


为什么需要`@Param`注解


• 多参数支持：

• 当方法有多个参数时，MyBatis 无法直接通过参数的名字来进行赋值。`@Param`注解为每个参数提供了唯一的名称，使得你可以在 SQL 语句中通过这些名称来引用参数。


• 动态 SQL：

• 在动态 SQL 中，你可能需要根据参数的值动态生成 SQL 语句。`@Param`注解允许你在 SQL 语句中使用参数的名称，而不是通过位置索引。


示例


不使用`@Param`注解

假设你有以下方法：


```java
public interface UserMapper {
    @Select("SELECT * FROM users WHERE name = #{name} AND age = #{age}")
    User findByNameAndAge(String name, int age);
}
```


在上面的代码中，`#{name}`和`#{age}`是无法直接绑定到方法参数`name`和`age`的，因为 MyBatis 不知道这些参数的具体名称。


使用`@Param`注解

为了使上述代码能够正常工作，你需要使用`@Param`注解为每个参数命名：


```java
public interface UserMapper {
    @Select("SELECT * FROM users WHERE name = #{name} AND age = #{age}")
    User findByNameAndAge(@Param("name") String name, @Param("age") int age);
}
```


在这个例子中，`@Param("name")`和`@Param("age")`为参数命名，`#{name}`和`#{age}`在 SQL 语句中引用这些参数。


单参数情况

如果方法只有一个参数，MyBatis 可以直接绑定这个参数，而不需要使用`@Param`注解。例如：


```java
public interface UserMapper {
    @Select("SELECT * FROM users WHERE id = #{id}")
    User findById(int id);
}
```


在这个例子中，`#{id}`会自动绑定方法参数`id`的值。


传递对象

如果方法的参数是一个对象，MyBatis 会自动使用对象的属性名称来绑定参数。例如：


```java
public class User {
    private int id;
    private String name;
    private String password;
    private String email;

    // Getters and Setters
}

public interface UserMapper {
    @Select("SELECT * FROM users WHERE name = #{name} AND password = #{password}")
    User findByUser(User user);
}
```


在这个例子中，`#{name}`和`#{password}`会自动绑定`User`对象的`name`和`password`属性。


总结

在 MyBatis 中，如果不使用`@Param`注解，直接根据参数的名字来进行赋值是不支持的。对于多参数方法，必须使用`@Param`注解来为每个参数命名，以便在 SQL 语句中通过参数名称来引用这些参数。对于单参数方法或传递对象的情况，MyBatis 可以自动绑定参数，而不需要使用`@Param`注解。通过合理使用`@Param`注解，可以提高代码的可读性和可维护性。

## 返回类型

一行数据，pojo或者map

多行，就是list。resultType就直接指定里面的泛型。

当前对于我来说，最困难的地方在于，如何理解复杂的一对多的结果，感觉无法理解，完全无法理解。

如果字段名不能对应，那么就使用resultMap来对应。

我感觉MyBatis真的又简单，又无聊，所以，我还是等到之后上课的时候再学习吧，虽然我已经浪费了蛮多时间的。

## 结果映射

结合文档和其他书，我感觉差不多学会了，之后就是上课的时候划划水，应该就可以了。

其实比较特别的也就是association和collection这两个参数，但是也没有什么特别的，一个是封装对象，另外一个是封装集合。\

当然，一般情况下，单表查询，还是使用自动映射。

另外，尽可能避免使用select * 这种丑陋的写法。

一般来说，徐庶它不建议，古老的方式，还是采取封装一个DTO，自己命名多一点，然后自动映射就可以。

但是嵌套映射就会多查询。

懒加载用处不大，不如DTO。

property，对应的属性

column对应查询的字段

select分布查询的方式，命名空间+ID。

## mybatis插件

mybatis的分页插件，

mybatis公共字段统一赋值。

责任链，mybatis底层代码。

它是怎么实现的。

怎么保证在调用的过程中



## java api

使用 MyBatis 的主要 Java 接口就是 SqlSession。你可以通过这个接口来执行命令，获取映射器示例和管理事务。在介绍 SqlSession 接口之前，我们先来了解如何获取一个 SqlSession 实例。SqlSessions 是由 SqlSessionFactory 实例创建的。SqlSessionFactory 对象包含创建 SqlSession 实例的各种方法。而 SqlSessionFactory 本身是由 SqlSessionFactoryBuilder 创建的，它可以从 XML、注解或 Java 配置代码来创建 SqlSessionFactory。

当 Mybatis 与一些依赖注入框架（如 Spring 或者 Guice）搭配使用时，SqlSession 将被依赖注入框架创建并注入，所以你不需要使用 SqlSessionFactoryBuilder 或者 SqlSessionFactory，可以直接阅读 SqlSession 这一节。请参考 Mybatis-Spring 或者 Mybatis-Guice 手册以了解更多信息。

自动注入大法好，但是学习一下底层原理还是有用的。

我感觉我可以开始上手mybatisplus了。

看了一下java八股文，感觉学海无涯。



# MybatisPlus

我现在会看pom文件的依赖传递了，感觉蛮有趣的，但是很多时候，传递依赖的时候会出现版本的问题。

太恶心了，我因为跟着视频，而不是自己看说明文件，所以在快速开始的时候，传递的依赖出现了问题，我少了一个3，或者选择了4，

我是SpringBoot3，所以我选择的mybatisplus也应该是对应的版本，一定要注意。如果你要自己配置，就要记得版本的问题。

不过，感觉也没有什么好学习的，操作都很简单。

也就是，Mapper继承一个BaseMapper，Service继承一个IService，然后就好了。

好像也没有其他操作要领。

不管怎么说，单表查询，它确实很方便，但是我感觉不如MyBatisCodeHelper。不过暂时就这样吧。之后有需要的时候再学习。

github高星java项目

# 整合SSM框架

## SpringMVC

web.xml

- 编码过滤器
- 支持res的过滤器

springmvc.xml

- 扫描controller包
- 添加annottaion-driver
- 视图解析器
- 静态资源解析

添加控制器类

## Spring

web.xml

- add listener

spring.xml

- scan all bean exclude controller
- 声明式事务

## mybatis

需要和Spring整合

- 将sqlSessionFactory配置为bean
- 配置数据源
- 全局配置文件
- mapper映射文件

将mapper接口的包交给Spring

加入全局配置文件

# 源码学习

​	

## 泛型

这里我学到了Type	GenericArrayType ParameterizedType TypeVariable WildcardType

怎么理解这些东西的区别，Type是抽象类，下面的都是它的实现。

Class是具体的实现，

TypeVariable是变量的实现。对于一个TypeVariable，可以使用getBounds获得它的边界。

ParameterizedType是类包含一个类型，参数化类型

GenericArrayType就是一个数组

WildcardType就是一个包含？的类型。

## Binding包

从前我只是认为一切就是约定，认为JAVA语言web开发就是规则，我不想深入源码。

现在我才能理解，很多繁琐的步骤的必要，为什么要设置一个mybatis-config.xml文件。

越是古老的调用方法，越是能够暴露一些底层的细节。

比如说，配置文件是怎么读取的，xml文件是如何转变成java的config类的。

以及，为什么Mapper接口没有实现细节，只是添加一个注解，就可以调用数据库查询了。

这一切就是binding包的作业。mybatis的动态代理和一般动态代理不同的地方在于，它不是简单的增强，它是直接通过配置文件来实现。

读源码确实让人犯困……

不过，尝试使用自己的话总结一下，为什么Spring和SpringBoot可以简单使用Mybatis，因为它已经封装了全部的细节，配置类中自己扫描，然后什么都有了。

一般来说，会有一个MapperFactoryBean，然后这个bean再在需要的时候通过@Autowired自动生成代理类。

## 建造者模式

```java
public class SunnySchoolUserBuilder implements UserBuilder {
    private String name;
    private String email;
    private Integer age;
    private Integer sex;
    private String schoolName;

    public SunnySchoolUserBuilder(String name) {
        this.name = name;
    }

    public SunnySchoolUserBuilder setEmail(String email) {
        this.email = email;
        return this;
    }

    public SunnySchoolUserBuilder setAge(Integer age) {
        this.age = age;
        return this;
    }

    public SunnySchoolUserBuilder setSex(Integer sex) {
        this.sex = sex;
        return this;
    }

    public User build() {
        if (this.name != null && this.email == null) {
            this.email = this.name.toLowerCase().replace(" ", "").concat("@sunnyschool.com");
        }
        if (this.age == null) {
            this.age = 7;
        }
        if (this.sex == null) {
            this.sex = 0;
        }
        this.schoolName = "Sunny School";
        return new User(name, email, age, sex, schoolName);
    }
}
```

我现在理解建造者模式的用法了。

它包含两种方法，一种是属性设置方法，一种是目标对象生成方法。

前者可以采用链式编程的方法，后者可以封装一些专有属性。

在构建复杂对象的时候，这种方法非常好用。

基于内部类的建造者模式提高了类的内聚性，这句话真的有一点复杂。

这是ResultMapping这个类的构造：

```java
public class ResultMapping {

  private Configuration configuration;
  private String property;
  private String column;
  private Class<?> javaType;
  private JdbcType jdbcType;
  private TypeHandler<?> typeHandler;
  private String nestedResultMapId;
  private String nestedQueryId;


  ResultMapping() {
  }

  public static class Builder {
    private ResultMapping resultMapping = new ResultMapping();

    public Builder(Configuration configuration, String property, String column, TypeHandler<?> typeHandler) {
      this(configuration, property);
      resultMapping.column = column;
      resultMapping.typeHandler = typeHandler;
    }

    public Builder(Configuration configuration, String property, String column, Class<?> javaType) {
      this(configuration, property);
      resultMapping.column = column;
      resultMapping.javaType = javaType;
    }



    public Builder javaType(Class<?> javaType) {
      resultMapping.javaType = javaType;
      return this;
    }


    public Builder lazy(boolean lazy) {
      resultMapping.lazy = lazy;
      return this;
    }

    public ResultMapping build() {
      // lock down collections
      resultMapping.flags = Collections.unmodifiableList(resultMapping.flags);
      resultMapping.composites = Collections.unmodifiableList(resultMapping.composites);
      resolveTypeHandler();
      validate();
      return resultMapping;
    }


    }
}
```

所有类似于arg、id之类的标签都对应一个Resultsmapping属性。



化繁为简

我又学会了一个新的知识，一般来说，继承父类都需要扩充父类的功能，但是有一些时候，我们却可以反其道而行之。设计一个功能强大的父类，在子类的继承中，对于父类的功能进行裁剪。

## 缓存

感觉Mybatis的缓存实现得很优雅。

一个简单的抽象类，

一个简单的实现类，也就是一个有id的HashMap

很多装饰器。

比如说LruCache

```java
  public void setSize(final int size) {
    keyMap = new LinkedHashMap<Object, Object>(size, .75F, true) {
      private static final long serialVersionUID = 4267176411845948333L;

      /**
       * 每次向LinkedHashMap放入数据时触发
       * @param eldest 最久未被访问的数据
       * @return 最久未必访问的元素是否应该被删除
       */
      @Override
      protected boolean removeEldestEntry(Map.Entry<Object, Object> eldest) {
        boolean tooBig = size() > size;
        if (tooBig) {
          eldestKey = eldest.getKey();
        }
        return tooBig;
      }
    };
  }
```

非常优雅——很优雅。

结合[Java LinkedHashMap详解（附源码） | 二哥的Java进阶之路](https://javabetter.cn/collection/linkedhashmap.html#_04、小结)，我看懂了，我现在大概明白了，但是第一遍看，感觉没有完全明白。

为什么这里除了需要return tooBig，还需要设置一个eldestKey呢？因为，这里的map只是一个记录了key key 的续表，移除的操作需要我们手动进行。

## javassist

```java
@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) throws Exception {
        ClassPool pool = ClassPool.getDefault();
        // 定义一个类
        CtClass userCtClazz = pool.makeClass("com.github.yeecode.mybatisdemo.User");
        // 创建name属性
        CtField nameField = new CtField(pool.get("java.lang.String"), "name", userCtClazz);
        userCtClazz.addField(nameField);
        // 创建name的setter
        CtMethod setMethod = CtNewMethod.make("public void setName(String name) { this.name = name;}", userCtClazz);
        userCtClazz.addMethod(setMethod);
        // 创建sayHello方法
        CtMethod sayHello = CtNewMethod.make("public String sayHello() { return \"Hello, I am \" + this.name ;}", userCtClazz);
        userCtClazz.addMethod(sayHello);

        Class<?> userClazz = userCtClazz.toClass();
        // 创建一个对象
        Object user = userClazz.newInstance();
        // 为对象设置name值
        Method[] methods = userClazz.getMethods();
        for (Method method: methods){
            if (method.getName().equals("setName")) {
                method.invoke(user,"易哥");
            }
        }
        // 调用对象sayHello方法
        for (Method method: methods){
            if (method.getName().equals("sayHello")) {
                String result = (String) method.invoke(user);
                System.out.println(result);

            }
        }
    }
}
```

感觉就是很优雅，非常优雅，非常好。

直接操作字节码，生成一个类。
