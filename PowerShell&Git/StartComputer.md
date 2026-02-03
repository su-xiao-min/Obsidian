```PowerShell
# 基本重启
Restart-Computer

# 基本关机
Stop-Computer

# 强制关机
Stop-Computer -Force


```

然后，想要休眠的话，
我们最好还是使用

```powershell
# 使用 shutdown 命令
shutdown /h
```

这命令真好，
有一堆参数可以使用

```powershell
tncet  MLeetCode  ➜ (master)  ♥ 23:07  shutdown
Usage: C:\Windows\system32\shutdown.exe [/i | /l | /s | /sg | /r | /g | /a | /p | /h | /e | /o] [/hybrid] [/soft] [/fw] [/f]
    [/m \\computer][/t xxx][/d [p|u:]xx:yy [/c "comment"]]

    No args    Display help. This is the same as typing /?.
    /?         Display help. This is the same as not typing any options.
    /i         Display the graphical user interface (GUI).
               This must be the first option.
    /l         Log off. This cannot be used with /m or /d options.
    /s         Shutdown the computer.
    /sg        Shutdown the computer. On the next boot, if Automatic Restart Sign-On
               is enabled, automatically sign in and lock last interactive user.
               After sign in, restart any registered applications.
    /r         Full shutdown and restart the computer.
    /g         Full shutdown and restart the computer. After the system is rebooted,
               if Automatic Restart Sign-On is enabled, automatically sign in and
               lock last interactive user.
               After sign in, restart any registered applications.
    /a         Abort a system shutdown.
               This can only be used during the time-out period.
               Combine with /fw to clear any pending boots to firmware.
    /p         Turn off the local computer with no time-out or warning.
               Can be used with /d and /f options.
    /h         Hibernate the local computer.
               Can be used with the /f option.
    /hybrid    Performs a shutdown of the computer and prepares it for fast startup.
               Must be used with /s option.
    /fw        Combine with a shutdown option to cause the next boot to go to the
               firmware user interface.
    /e         Document the reason for an unexpected shutdown of a computer.
    /o         Go to the advanced boot options menu and restart the computer.
               Must be used with /r option.
    /m \\computer Specify the target computer.
    /t xxx     Set the time-out period before shutdown to xxx seconds.
               The valid range is 0-315360000 (10 years), with a default of 30.
               If the timeout period is greater than 0, the /f parameter is
               implied.
    /c "comment" Comment on the reason for the restart or shutdown.
               Maximum of 512 characters allowed.
    /f         Force running applications to close without forewarning users.
               The /f parameter is implied when a value greater than 0 is
               specified for the /t parameter.
    /d [p|u:]xx:yy  Provide the reason for the restart or shutdown.
               p indicates that the restart or shutdown is planned.
               u indicates that the reason is user defined.
               If neither p nor u is specified the restart or shutdown is
               unplanned.
               xx is the major reason number (positive integer less than 256).
               yy is the minor reason number (positive integer less than 65536).

此计算机上的原因:
(E = 预期 U = 意外 P = 计划内，C = 自定义)
类别    主要    次要    标题

 U      0       0       Other (Unplanned)
E       0       0       Other (Unplanned)
E P     0       0       Other (Planned)
 U      0       5       Other Failure: System Unresponsive
E       1       1       Hardware: Maintenance (Unplanned)
E P     1       1       Hardware: Maintenance (Planned)
E       1       2       Hardware: Installation (Unplanned)
E P     1       2       Hardware: Installation (Planned)
E       2       2       Operating System: Recovery (Unplanned)
E P     2       2       Operating System: Recovery (Planned)
  P     2       3       Operating System: Upgrade (Planned)
E       2       4       Operating System: Reconfiguration (Unplanned)
E P     2       4       Operating System: Reconfiguration (Planned)
  P     2       16      Operating System: Service pack (Planned)
        2       17      Operating System: Hot fix (Unplanned)
  P     2       17      Operating System: Hot fix (Planned)
        2       18      Operating System: Security fix (Unplanned)
  P     2       18      Operating System: Security fix (Planned)
E       4       1       Application: Maintenance (Unplanned)
E P     4       1       Application: Maintenance (Planned)
E P     4       2       Application: Installation (Planned)
E       4       5       Application: Unresponsive
E       4       6       Application: Unstable
 U      5       15      System Failure: Stop error
 U      5       19      Security issue (Unplanned)
E       5       19      Security issue (Unplanned)
E P     5       19      Security issue (Planned)
E       5       20      Loss of network connectivity (Unplanned)
 U      6       11      Power Failure: Cord Unplugged
 U      6       12      Power Failure: Environment
  P     7       0       Legacy API shutdown
tncet  MLeetCode  ➜ (master)  ♥ 23:08 

```

真的看不懂一点，🕐
然后，
我刚才尝试了一下

```powershell
# Windows 10/11 推荐方法
Start-Process "rundll32.exe" -ArgumentList "powrprof.dll,SetSuspendState 0,1,0"

# 或者
powercfg -h on  # 确保休眠已启用
rundll32.exe powrprof.dll,SetSuspendState 0,1,0

```

我特别想知道这个命令到底做了什么事情，
到底什么是WMI/CIM，
然后还有就是 这个 `rundll32` & `powercfg` 又是什么东西。
这东西怎么用起来这么麻烦呢？k

看不懂一点，
刚刚输入了这个命令，
然后电脑就，
深度休眠了，
按开机键都没有用，

但是，
其实这个都影响不大，
问题是，
我
`shutdown /r /t 300`
但是忘记使用
`shutdown /a`
凉凉。
