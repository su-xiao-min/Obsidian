## 前言

只是一个很水的笔记。
我还是很好奇的，
就是LazyVim究竟是什么东西。
虽然感觉很好玩，
但是没有弄懂。

[一篇知乎的笔记](https://zhuanlan.zhihu.com/p/638379995)
算了，还是自己手写链接的内容吧。
简单地说，
LazyVim和我们的Spring Boot的理念高度详细，
那就是，
约定大于配置，
传统的NeoVim需要你手搓完整的配置，
接着一个个注册，
有没有Spring写XML那个味道了。

但是Spring Boot就把这一切封装了。
它封装的方式也挺好的。
首先是在我们的

```lua
require("lazynvim-init")
```

也就是init.lua里面引用我们的一个文件。

接着，也就是在这一个文件
lazynvim-init.lua
当中解决所有的问题。

```lua
-- 寻找路径
local lazypath = vim.fn.stdpath("data")
if not vim.loo.fs_stat(lazypath) them
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypatho,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({})
```

之后就是启动，
首次启动的时候会自动安装。
之后就可以随便弄了。
比较常用的插件

- nivm-tree.lua
- lualine.nvim

我不是很懂这个后缀名。
反正自己后来也安装了不少插件。
可以直接在`setup({})` 当中进行插件的安装。
但是更好的策略是，
我们使用`plugins` 目录进行自己手动的管理。

简单说一下我们的插件体系，
这里我就以一个PicGo的插件举例。
在[GitHub仓库](https://github.com/askfiy/nvim-picgo)
当中没有写使用LazyVim进行安装的方式。
所以，我必须要思考，怎样在LazyVim当中进行安装。

使用Packer安装的代码是：

```lua
use {
    "askfiy/nvim-picgo",
    config = function()
        -- it doesn't require you to do any configuration
        require("nvim-picgo").setup()
    end
    }
```

对应的，使用LazyVim安装的方式是：

```lua
return {
  {
    "askfiy/nvim-picgo",
    event = "VeryLazy", -- 或按需触发，比如 InsertEnter、BufRead 等
    dependencies = {}, -- 本插件无额外依赖
    config = function()
      require("nvim-picgo").setup({
        notice = "notify",
        image_name = false,
        debug = false,
      })
    end,
  },
}
```

return 返回的是一个插件集合，
集合的每一个元素都是一个插件的描述，
或者说，配置
配置的第一行指定插件的GitHub的short url
会根据这个url去GitHub上面下载

event表示加载的方式，
其实我感觉更需要的可能是Markdown的BufRead。
VeryLazy也不错。
config就是一些配置。
一般都很简单。

另外则是插件的搜索路径。
我之前安装了一个插件，
结果，分享安装攻略的那个人它使用的是
dev模式，
所以会默认使用本地已经存在的插件，
不格外安装，
然后，我使用的时候就一直报错
![一张无趣的截图](http://image.suxiaomin.cn/vim/20260126101022953.png)

为什么要了解这个呢？
因为在摆烂啊，
想要实现一个很简单的效果，就是复制图片，
接着显示出来。
虽然在我的PowerShell当中，
这些东西都看不到的。
其实我感觉或许Quicker也可以实现类似的效果。
不过，
就先使用别人已经做好的东西吧……

```

```

```

```

```

```

```

```
