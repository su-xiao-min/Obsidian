你遇到的情况是：**在错误的分支（比如 `main` 或 `develop`）上直接开发并提交了代码，而本应该先 `checkout` 到一个新分支再开发**。别担心，这种情况很常见，而且 Git 提供了非常方便的工具来“搬移”这些提交。

下面是解决步骤（假设你当前还在包含你提交的分支上）：

---

### ✅ 方法一：把你的提交“移动”到新分支（推荐）

1. **创建一个新分支，指向你当前的提交**  
   ```bash
   git checkout -b new-feature-branch
   ```
   这会基于你当前的 HEAD（即你刚刚 commit 的位置）创建一个新分支，并切换过去。

2. **回到原来的分支（比如 main）**  
   ```bash
   git checkout main
   ```

3. **把原分支的 HEAD 重置回你 commit 之前的状态**  
   ```bash
   git reset --hard HEAD~1
   ```
   > ⚠️ 注意：如果你有多个提交，把 `HEAD~1` 改成 `HEAD~n`（n 是你提交的数量），或者更安全地使用具体的 commit hash：
   > ```bash
   > git reset --hard <之前的commit-hash>
   > ```

   这样，你的提交就只存在于 `new-feature-branch` 中，而 `main` 分支恢复干净。

4. **验证一下**  
   ```bash
   git log --oneline -5
   ```
   确保 `main` 分支没有你的提交，而 `new-feature-branch` 有。

---

### 🔁 方法二：如果你已经 push 到远程（且别人可能已拉取）

如果**已经 push 到远程仓库**（比如 GitHub/GitLab），并且可能有其他人基于这个错误分支工作，那么 **不要用 `reset --hard`**，因为这会改写历史，造成协作混乱。

此时建议：

1. 在当前分支创建新分支（保留你的提交）：
   ```bash
   git checkout -b new-feature-branch
   ```

2. 回到原分支（如 main）：
   ```bash
   git checkout main
   ```

3. **撤销（revert）你的提交，而不是重置**：
   ```bash
   git revert <你的commit的hash>
   ```
   这会生成一个“反向提交”，把代码改回去，但保留历史记录，对团队协作更安全。

4. push 这个 revert 提交：
   ```bash
   git push origin main
   ```

---

### 🛡️ 小贴士：以后如何避免？

- 养成习惯：`git pull` 后立即 `git checkout -b your-branch`
- 设置 Git 钩子或 IDE 提醒（比如在 main 分支禁止直接 commit）
- 使用 `git status` 确认当前分支再开始写代码

---

如果你告诉我：
- 当前在哪个分支？
- 一共 commit 了几次？
- 是否已经 `push` 到远程？

我可以给你更精确的命令 😊
