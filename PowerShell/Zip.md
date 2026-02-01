我建议，
没有事情就不要去压缩
压缩的命令应该非常郑重，

我遇到的问题，
我压缩的时候，
解压的时候，
希望重命名，
结果，每一次都弄错了文件结构，
就是一次次灾难。
情况是，
压缩和解压缩根本就不是用来重命名的，
或者，
我们可以抽象一下，
你想一下打包，
如果你打包的时候，
把别人的包装也带上了，
那么，
你拆开的时候，
看到得也是别人的包装，

反过来说，
你没有带上，
那么，
你就需要自己准备好包裹。

所以，
我们打包的时候，
最好告诉别人，
这东西有没有内存的包装，
解压之后是不是可以直接使用？
一般都是可以直接使用的，
像是我这样喜欢重命名的还是比较少的笨蛋！

```PowerShell
# 基本语法
Compress-Archive -Path <源文件/文件夹> -DestinationPath <目标.zip文件>

# 示例
Compress-Archive -Path "C:\FolderA" -DestinationPath "C:\Archive.zip"
```

我草，
你真的不如我的Typora，我的Typora都支持代码高亮的。

```PowerShell
# 基本语法
Expand-Archive -Path <源.zip文件> -DestinationPath <目标路径>

# 示例
Expand-Archive -Path "C:\Archive.zip" -DestinationPath "C:\Extracted"
```

也没有什么好说的了，
只有我这种又蠢，又喜欢命令行操作的人才会遇到这样的问题，
而且，
算了，不骂自己了，
没有什么好骂的，
之后吸取教训就可以了。

反正就是要记住，
这东西，
你最好把命令写清楚一点，
最好，
