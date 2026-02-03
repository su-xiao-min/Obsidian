```
import { useState } from 'react';

export default function MyApp() {
  return (
    <div>
      <h1>独立更新的计数器</h1>
      <MyButton />
      <MyButton />
    </div>
  );
}

function MyButton() {
  const [count, setCount] = useState(0);

  function handleClick() {
    setCount(count + 1);
  }

  return (
    <button onClick={handleClick}>
      点了 {count} 次
    </button>
  );
}
```

为什么感觉这个东西看起来比我的Vue和蔼可亲多了呢、

我们也手搓一个计数器吧。

```
import { useState } from 'react';

export default function MyApp() {
  const [count, setCount] = useState(0);

  function handleClick() {
    setCount(count + 1);
  }

  return (
    <div>
      <h1>共同更新的计数器</h1>
      <MyButton count={count} onClick={handleClick} />
      <MyButton count={count} onClick={handleClick} />
    </div>
  );
}

function MyButton({ count, onClick }) {
  return (
    <button onClick={onClick}>
      点了 {count} 次
    </button>
  );
}

```

```
npm create vite@latest my-vite-react
```

```

```
