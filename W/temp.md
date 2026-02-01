ps aux | grep -E "mvn|spring-boot" | grep -v grep

ps aux | grep "[m]vn spring-boot:run" | wc -l

curl -s http://localhost:8080/actuator/health 2>/dev/null || echo "服务未启动或端口不可达"



  3. 🔍 如何查看项目是否运行

  方法 1：检查端口监听

  lsof -i :8081  # 应用在 8081 端口（不是 8080）

  方法 2：检查运行进程

  ps aux | grep "[m]vn spring-boot:run"

  方法 3：测试健康端点

  curl http://localhost:8081/actuator/health

  方法 4：查看日志

  tail -f /tmp/backend-final.log

  pkill -9 -f "mvn spring-boot:run"





| 配置项             | 值                                     | 说明                                          |
| ------------------ | -------------------------------------- | --------------------------------------------- |
| defaultProfile     | {61c54bbd-c2c6-5271-96e7-009a87ff44bf} | 默认启动的配置文件(这里是 Windows PowerShell) |
| copyOnSelect       | true                                   | 选中文本后自动复制到剪贴板                    |
| copyFormatting     | "none"                                 | 复制时不包含格式                              |
| focusFollowMouse   | true                                   | 鼠标悬停时自动聚焦窗口                        |
| showTabsInTitlebar | false                                  | 标签页不显示在标题栏中                        |
| useAcrylicInTabRow | true                                   | 标签栏使用毛玻璃效果                          |

---
  ⌨️ 快捷键绑定

| 快捷键          | 功能         |
| -----------   | ------------ |
| Ctrl+C          | 复制到剪贴板 |
| Ctrl+V      |     从剪贴板粘贴 |
| Alt+Shift+D |                  复制当前窗格 |

---
  🖥️ 配置文件列表

  当前配置了 4 个终端配置文件:

  1️⃣ Windows PowerShell (默认)

  - GUID: {61c54bbd-c2c6-5271-96e7-009a87ff44bf}
  - 命令: powershell.exe
  - 字体: Lucida Console, 15号, 中等粗细
  - 毛玻璃效果: 启用

  2️⃣ 命令提示符 (CMD)

  - GUID: {0caa0dad-35be-5f56-a8ff-afceeeaa6101}
  - 命令: cmd.exe
  - 名称: 命令提示符

  3️⃣ Azure Cloud Shell

  - GUID: {b453ae62-4e3d-5e58-b989-0a998ec441b8}
  - 来源: Windows.Terminal.Azure

  4️⃣ Ubuntu (WSL)

  - GUID: {89f94071-235f-59d1-a9cb-de4669e057ff}
  - 来源: Microsoft.WSL

---
  🎨 其他配置

  - schemes: 空数组(未定义自定义颜色方案)
  - themes: 空数组(未定义主题)
  - newTabMenu: 显示所有剩余的配置文件

---
  💡 重要提示

  如果你想要:
  - 添加 Git Bash 配置: 我可以帮你添加
  - 修改字体/颜色主题: 可以在 schemes 中自定义
  - 添加更多快捷键: 在 keybindings 数组中添加

1. 现在它一页上面显示四个PowerShell
2. rfwu 
3. will 
4. math 

- [x]  rfwu 



我想问一下，copyFormatting除了none，还可以选择什么参数。有什么影响。其他配置项的效果你也顺便解释一下。比如说，毛玻璃效果是什么，标签页显示在标题栏有什么用。

还可以添加什么配置项？

另外，我按下了Alt+Shift+D，现在它一页上面显示四个PowerShell，我应该怎么办。我想关闭新开的窗格。



我需要你帮我添加Git Bash的配置项，放在第五个。添加ssh配置项，内容是root@8.145.33.108，直接到/root/workspace路径。



 📋 copyFormatting 参数详解

  copyFormatting 控制复制文本时保留的格式类型,可选值:

| 值     | 效果                             |
| ------ | -------------------------------- |
| "none" | 纯文本,不保留任何格式            |
| "html" | 保留 HTML 格式(包含颜色、粗体等) |
| "rtf"  | 保留富文本格式(Rich Text Format) |

  实际影响:
  - none: 粘贴到任何地方都是纯文本
  - html: 粘贴到支持 HTML 的应用(如 Outlook、OneNote)会保留颜色
  - rtf: 粘贴到 Word、记事本等会保留格式

---
  🎨 其他配置项效果解释

  1️⃣ 毛玻璃效果

| 配置项                              | 效果                            |
| ----------------------------------- | ------------------------------- |
| useAcrylicInTabRow                  |                                 |
| 标签栏背景半透明,能透出下方窗口内容 |                                 |
| profiles.list[].useAcrylic          | 终端背景半透明,类似磨砂玻璃效果 |
     |

  视觉对比:
  - ❌ 不启用: 纯色背景,不透明
  - ✅ 启用: 半透明模糊背景,更有现代感

  2️⃣ 标签页显示在标题栏

| 配置                                  | 效果                 |
| ------------------------------------- | -------------------- |
| showTabsInTitlebar: false             |                      |
| 标签页和标题栏分开,标签在终端窗口内部 |                      |
| showTabsInTitlebar: true              | 标签页集成到 Windows |
| 标题栏中,节省垂直空间                 |                      |

---
  ❌ 关闭窗格的方法

  你现在有 4 个 PowerShell 窗格,按以下步骤关闭:

● 关闭窗格的方法:

| 方法     | 操作                            |
| -------- | ------------------------------- |
| 快捷键   | Ctrl+Shift+W (关闭当前焦点窗格) |
| 鼠标操作 | 点击窗格标签的 × 按钮           |
| 菜单方式 | 右键窗格 → 关闭窗格             |

  💡 提示: 重复按 Ctrl+Shift+W 直到只剩一个窗格即可

---
  🔧 可添加的配置项

  Windows Terminal 支持的常用配置:

| 类别 | 配置项示例                                       |
| ---- | ------------------------------------------------ |
| 外观 | colorScheme、backgroundImage、fontSize、fontFace |
| 行为 | startingDirectory、closeOnExit、scrollbackSize   |
| 高级 | cursorShape、cursorColor、tabTitle               |
| 启动 | launchMode、initialRows、initialCols             |
| 性能 | experimental.rendering.forceFullRepaint          |

---
  现在让我为你添加 Git Bash 和 SSH 配置:

● Update(settings.json)
  ⎿  Updated settings.json with 27 additions
       62                    "hidden": false,
       63                    "name": "Ubuntu",
       64                    "source": "Microsoft.WSL"
       65 +              },
       66 +              {
       67 +                  "commandline":
          + "%ProgramFiles%\\Git\\bin\\bash.exe",
       68 +                  "font":
       69 +                  {
       70 +                      "face": "Lucida Console",
       71 +                      "size": 15,
       72 +                      "weight": "medium"
       73 +                  },
       74 +                  "guid":
          + "{574e775e-4f2d-5b68-ac87-86880c1b6a3f}",
       75 +                  "hidden": false,
       76 +                  "icon": "%ProgramFiles%\\Git\\mi
          + ngw64\\share\\git\\git-for-windows.ico",
       77 +                  "name": "Git Bash",
       78 +                  "startingDirectory":
          + "%USERPROFILE%"
       79 +              },
       80 +              {
       81 +                  "commandline": "ssh
          + root@8.145.33.108 -t \"cd /root/workspace && exec
          +  $SHELL -l\"",
       82 +                  "font":
       83 +                  {
       84 +                      "face": "Lucida Console",
       85 +                      "size": 15,
       86 +                      "weight": "medium"
       87 +                  },
       88 +                  "guid":
          + "{8a1f2e3c-4d5b-6a7b-8c9d-0e1f2a3b4c5d}",
       89 +                  "hidden": false,
       90 +                  "name": "SSH Root@8.145.33.108",
       91 +                  "startingDirectory":
          + "%USERPROFILE%"
       92                }
       93            ]
       94        },

● ✅ 配置已完成!

  我已经成功添加了两个新配置:

  5️⃣ Git Bash (第 5 个配置)

  - 名称: Git Bash
  - 路径: %ProgramFiles%\Git\bin\bash.exe
  - 启动目录: 用户主目录 (%USERPROFILE%)
  - 图标: Git for Windows 图标
  - 字体: Lucida Console, 15号

  6️⃣ SSH 连接 (第 6 个配置)

  - 名称: SSH Root@8.145.33.108
  - 命令: ssh root@8.145.33.108 -t "cd /root/workspace && exec
    $SHELL -l"
  - 功能: 连接后自动切换到 /root/workspace 目录
  - 字体: Lucida Console, 15号

---
  🎯 使用说明

  1. 重新打开 Windows Terminal 以加载新配置
  2. 点击 + 按钮或下拉菜单,你会看到:

    - Git Bash
    - SSH Root@8.145.33.108
  3. 关闭多余窗格: 按 Ctrl+Shift+W 直到只剩一个窗口

---
  ⚠️ 注意事项

  SSH 配置说明

  - -t 参数: 强制分配伪终端
  - cd /root/workspace: 切换到指定目录
  - exec $SHELL -l: 启动登录 shell,加载完整环境配置

  如果 SSH 连接需要密码

  首次连接会提示输入密码,你可以:
  1. 配置 SSH 密钥实现免密登录
  2. 使用 Windows 凭据管理器保存密码

---





RTF，好有趣，好像了解一下这个文件格式的内容。













