```
  "scripts": {

    "dev": "vite",

    "build": "tsc -b && vite build",

    "lint": "eslint .",

    "preview": "vite preview"

  },
```
我非常好奇，
这几个npm 脚本到底有什么用
为什么需要他们的存在？
还有没有其他类似的命令，

因为我正在写一个React的项目，
我之前还在学习一些Vue的项目，
还有很古老的webpack的项目

我感觉，
他们就是一种映射，
把不同的架构工具的命令集中映射到了dev、build、start这几个比较常见的上面，
当你更换的时候，
就不会出现不适应，

问题是，
直接运行的时候，
是使用直接使用 vite？

还有，vite是什么？