# JavaScript 写 React 常见问题

本文档记录从 JavaScript 迁移到 TypeScript + React 开发过程中的常见问题。

---

## 1. 缺少类型注解

### ❌ 问题代码
```typescript
// animation.ts
constructor(node) {
    this.node = node;
}

start(duration) {
    this.duration = duration;
}
```

### ✅ 正确写法
```typescript
constructor(node: HTMLElement) {
    this.node = node;
}

start(duration: number): void {
    this.duration = duration;
}
```

### 影响
- 没有类型检查，容易传入错误类型
- IDE 无法提供代码补全
- 运行时才发现错误

---

## 2. 类属性未声明

### ❌ 问题代码
```typescript
export class FadeInAnimation {
    constructor(node: HTMLElement) {
        this.node = node;  // TypeScript 报错：属性 'node' 不存在
    }
}
```

### ✅ 正确写法
```typescript
export class FadeInAnimation {
    node: HTMLElement;           // 必须提前声明
    startTime: number | null = null;
    frameId: number | null = null;
    duration: number = 0;

    constructor(node: HTMLElement) {
        this.node = node;
    }
}
```

### 影响
- TypeScript 编译错误
- 无法追踪属性类型

---

## 3. ref 缺少泛型类型

### ❌ 问题代码
```typescript
// App.tsx
const ref = useRef(null);  // 类型是 React.RefObject<unknown>
```

### ✅ 正确写法
```typescript
const ref = useRef<HTMLHeadingElement>(null);  // 类型明确
```

### 影响
- `ref.current` 类型是 `unknown`，无法访问 DOM 属性
- 没有智能提示和类型检查

---

## 4. 忘记 null 检查

### ❌ 问题代码
```typescript
useEffect(() => {
    const animation = new FadeInAnimation(ref.current);  // ref.current 可能为 null！
    animation.start(1000);
}, []);
```

### ✅ 正确写法
```typescript
useEffect(() => {
    const node = ref.current;
    if (!node) return;  // 必须先检查

    const animation = new FadeInAnimation(node);
    animation.start(1000);
}, []);
```

### 为什么需要？
- useEffect 可能在 DOM 渲染前执行
- 条件渲染时 ref.current 可能为 null
- 避免运行时错误

---

## 5. 导入路径问题

### ❌ 问题代码
```typescript
import { FadeInAnimation } from './animation.js';  // 不要加 .js
```

### ✅ 正确写法
```typescript
import { FadeInAnimation } from './animation';
```

### 原因
- TypeScript/Vite 会自动处理文件扩展名
- 手动添加可能导致模块解析问题

---

## 6. 方法返回类型缺失

### ❌ 问题代码
```typescript
start(duration: number) {
    // ...
}

stop() {
    // ...
}
```

### ✅ 正确写法
```typescript
start(duration: number): void {
    // ...
}

stop(): void {
    // ...
}
```

### 好处
- 明确方法不返回值
- 防止意外返回值
- 提高代码可读性

---

## 7. 类型不安全的操作

### ❌ 问题代码
```typescript
onProgress(progress: number): void {
    this.node.style.opacity = progress;  // 类型错误！
}

const timePassed = performance.now() - this.startTime;  // startTime 可能为 null
```

### ✅ 正确写法
```typescript
onProgress(progress: number): void {
    this.node.style.opacity = progress.toString();  // 转为字符串
}

const timePassed = performance.now() - (this.startTime || 0);  // 处理 null
```

### 影响
- TypeScript 编译错误
- 可能产生意外的 NaN

---

## 8. 缺少空值检查

### ❌ 问题代码
```typescript
stop(): void {
    cancelAnimationFrame(this.frameId);  // frameId 可能为 null
}
```

### ✅ 正确写法
```typescript
stop(): void {
    if (this.frameId !== null) {
        cancelAnimationFrame(this.frameId);
    }
}
```

---

## 总结：TypeScript 迁移检查清单

- [ ] 所有函数参数都有类型注解
- [ ] 所有方法都有返回类型注解
- [ ] 类属性提前声明
- [ ] ref 使用泛型类型
- [ ] 使用前进行 null 检查
- [ ] 避免 .js/.tsx 扩展名
- [ ] 处理可能的 null/undefined 值
- [ ] 使用严格的 TypeScript 配置

---

## 推荐的 tsconfig.json 配置

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

这些配置能帮助你在开发阶段就发现潜在问题！
