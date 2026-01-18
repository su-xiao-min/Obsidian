[通过自定义域名访问OSS-对象存储(OSS)-阿里云帮助中心](https://help.aliyun.com/zh/oss/user-guide/access-buckets-via-custom-domain-names?spm=a2c4g.11186623.0.0.7b1c61e9EqsYws)

这就是我要做的事情，我希望我可以做到吧。

一开始的想法就是，看一下，记得之前好像看到过，说OSS提供的服务，可以形成一个网页的，就是那种点击之后不会默认下载的网页。

之后，就询问AI，也就是千问，不过千问给出来的答案并不可靠。

它提议我使用一个ossutil的工具。

我感觉，其实还可以。

[命令行工具ossutil 2.0-对象存储-阿里云](https://help.aliyun.com/zh/oss/developer-reference/ossutil-overview/?spm=5176.8466032.console-base_search-panel.dtab-help_2786110.6ab51450LrAnw0&scm=20140722.S_help@@文档@@2786110.S_BB1@bl%2BRQW@ag0%2BBB2@ag0%2Bhot%2Bos0.ID_2786110-RL_ossutil-LOC_console~UND~help-OR_ser-PAR1_2150427117675292014554705ee66e-V_4-P0_0-P1_0)

使用的方式就在这里。

也是老熟人了，我上一个使用的工具还是恒源云的C:\tools\oss_windows_x86_64.exe，

我那时不太理解，为什么在这里，上传的文件夹都是oss://，对应我们普通的Windows当中的C://，大概也是建立一个虚拟映射，总结一下，还挺好玩的。

或者，有了这个工具就足够了，但是，我死心不改吧。

死心不改，于是，想着购买一个域名，去探索新的生活，结果，因为自己的愚蠢，光是探索就探索了半天，这些对于我来说都是新的知识，什么云服务器，什么ESC，什么域名选择，我都很好奇，我一度想要购买3年的域名，我选择的当然是最简单的

<http://suxiaomin.cn>

很可惜，中国境内的域名都需要备案，麻了，真的麻了，换言之，我买一个域名可能只需要38￥，我为了备案，还需要再购买一个服务器，那又是好多好多钱，真的麻了。

至少，至少我知道了一个好工具。

```txt
PS C:\Users\thewo> C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cp C:\W\信息描述复习\ISV.html oss://suxiaomin-tuil/note/InformationDescriptionNote.html
Succeed: Total num: 1, size: 969,012. OK num: 1(upload 1 files).

average speed 970000(byte/s)

1.001383(s) elapsed
PS C:\Users\thewo> C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cpC:\W\信息描述复习\可视化版本.md oss://suxiaomin-tuil/note/InformationDescription.md
Error: no such command: "cpC:\W\信息描述复习\可视化版本.md", please try "help" for more information
PS C:\Users\thewo> C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cp C:\W\信息描述复习\可视化版本.md oss://suxiaomin-tuil/note/InformationDescription.md
Succeed: Total num: 1, size: 116,622. OK num: 1(upload 1 files).

average speed 181000(byte/s)

0.647435(s) elapsed
PS C:\Users\thewo> C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cp C:\W\信息描述复习\ISV.html oss://suxiaomin-tuil/note/InformationDescriptionNote.html
cp: overwrite "oss://suxiaomin-tuil/note/InformationDescriptionNote.html"(y or N)? y
Succeed: Total num: 1, size: 969,018. OK num: 1(upload 1 files).

average speed 203000(byte/s)

4.765199(s) elapsed
PS C:\Users\thewo>
```



我想要知道，我希望部署自己的HTML网页，但是我看到阿里云OSS说，自己购买域名可以实现这个效果

我想知道，购买域名有什么用处？



如果我基于Spring开发了一个网页，我能不能直接部署在自己购买的这个域名上面，让别人也能够访问？



大概知道了，挺好玩的，什么都可以往里面放oss://suxiaomin-tuil/note/





也没有什么关系，



我把下面这段内容弄成了快捷输入

之后，我再想要上传笔记，就只需要，输入，oss，接着替换路径就可以了。分享的时候，就把第二行分享出去就可以了。我觉得是挺美好的。

而且，因为，是可以替换的，换言之，即使第一版弄得不满意，也可以继续修改，网址都不需要修改，只不过阅读的人就需要重新下载了。我也没有办法去推送说我更新了，没关系了。

C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cp C:\W\html oss://suxiaomin-tuil/note/.html 


https://suxiaomin-tuil.oss-cn-wuhan-lr.aliyuncs.com/note/

```
C:\tools\ossutil-v1.7.19-windows-amd64\ossutil.exe cp C:\W\信息描述复习\ISV.html oss://suxiaomin-tuil/note/InformationDescriptionNote.html 


https://suxiaomin-tuil.oss-cn-wuhan-lr.aliyuncs.com/note/
```

大概是一败涂地了。

![image-20260104202046793](C:\Tymage\image-20260104202046793.png)

是的，它不会给我走后门的。

或许，或许，有一天也可以尝试一下，其实也没有关系了，就直接放一个OSS的地址也不错。

而且，之后，是的，之后就很方便了。

无所谓了，也玩够了，还发现了一个好玩的工具，之后就可以自己命令行上传图片了。



其实oss很简单，oss的工具也很简单，支持很多复杂的场景，只不过，我实在能力不够了。但是，也玩够了。

有一天，想要开发更复杂的服务，再拓展吧。