我有一些问题，
我正在参加一个企业项目开发，
我已经对于项目的一些代码做出了修改，
但是，
我希望，
我可以在提交的时候细致到具体某个文件修改的内容，
我怎么查看我对于某个文件的修改内容，
乃至，
具体的，
让这个文件回到我修改之前的样子。
只保留有限制的，
我被允许修改的内容

另外，
我想知道，
如果我想要提交我修改的结果，
我是应该一次把我的任务都完成了，
再统一push
还是说，
我应该多次push

下一个问题，
我push之后，
会发生什么事情
因为这是一个合作的项目，
所以，
我push了，
应该会被审核对吧

下一个问题，
如果，
我希望暂时把我修改的内容缓存起来，
让代码回到我上一次commit的样子，
我应该怎样做，
Git的命令是什么。

下一个问题，
git remote相关的命令介绍一下，
我这一块还不太熟悉。

希望你详细回答一下，
再补充一些实战中的使用建议。

简单地说，
就是几个命令，
我先自己总结

首先是
`git diff`

之后是
`git checkout`
or
`git restore`

[git 后悔药](https://zhuanlan.zhihu.com/p/1938562402275815984)

里面也有一些挺好的说法。
![git space](https://pic1.zhimg.com/v2-c6e765955884a599bf7a7414741a3adc_1440w.jpg)
里面的内容也不错，
这个图我就收下来了。

反正，我现在就要
git restore run_sql.py

还有
`git stash`
可以参考[博客园](https://www.cnblogs.com/tocy/p/git-stash-reference.html)
写的还可以。

多次commit
一次push





# Stash

帮我解释一下，我之前git stash了一份修改，之后我想把它弄出来，但是，貌似我好像弄出来了一些乱子，换言之，我git stash的时候，其实已经有了一些提交，之后我又使用了reset，然后，我基于reset之后的原始分支，再git stash pop 于是，就

```
tncet  teamerp2-data  ➜ ( dev-opush  1)  ♥ 20:00  git stash pop
CONFLICT (modify/delete): src/main/java/com/tncet/erp/service/impl/OPPOMessagePushService.java deleted in Updated upstream and modified in Stashed changes.  Version Stashed changes of src/main/java/com/tncet/erp/service/impl/OPPOMessagePushService.java left in tree.
CONFLICT (modify/delete): src/main/resources/sql/message_push_history.sql deleted in Updated upstream and modified in Stashed changes.  Version Stashed changes of src/main/resources/sql/message_push_history.sql left in tree.
On branch dev-opush
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   .gitignore
        modified:   src/main/java/com/tncet/erp/controller/tests/TestController.java
        modified:   src/main/java/com/tncet/erp/declare/enums/DeviceBrand.java
        modified:   src/main/java/com/tncet/erp/interceptor/BaseInterceptor.java
        modified:   src/main/resources/application.yml

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add/rm <file>..." as appropriate to mark resolution)
        deleted by us:   src/main/java/com/tncet/erp/service/impl/OPPOMessagePushService.java
        deleted by us:   src/main/resources/sql/message_push_history.sql

The stash entry is kept in case you need it again.
tncet  teamerp2-data  ➜ ( dev-opush  1)  ♥ 20:00  git status
On branch dev-opush
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   .gitignore
        modified:   src/main/java/com/tncet/erp/controller/tests/TestController.java
        modified:   src/main/java/com/tncet/erp/declare/enums/DeviceBrand.java
        modified:   src/main/java/com/tncet/erp/interceptor/BaseInterceptor.java
        new file:   src/main/java/com/tncet/erp/service/impl/OPPOMessagePushService.java
        modified:   src/main/resources/application.yml

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add/rm <file>..." as appropriate to mark resolution)
        deleted by us:   src/main/resources/sql/message_push_history.sql

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
modified:   src/main/java/com/tncet/erp/service/impl/OPPOMessagePushService.java
```

  这高低有一点让我看不懂了。

算了，算了，
我们就不要和AI争论这个问题了，
这太严肃了。
