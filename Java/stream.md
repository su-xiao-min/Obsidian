



```java
Map<Long, Task> taskMap = tasks.stream().collect(Collectors.toMap(Task::getId, task -> task));
```

好好看的一个Map啊，下一次我也这样制造Map。

项目里面时不时可以看到一些stream的好看的用法，

早上做题的时候，也看到了一个有趣的解法[49. 字母异位词分组 - 力扣（LeetCode）](https://leetcode.cn/problems/group-anagrams/solutions/2718519/ha-xi-biao-fen-zu-jian-ji-xie-fa-pythonj-1ukv/?envType=study-plan-v2&envId=top-100-liked)



```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        return new ArrayList<>(
            Arrays.stream(strs)
                  .collect(Collectors.groupingBy(s -> {
                      char[] sortedS = s.toCharArray();
                      Arrays.sort(sortedS);
                      return new String(sortedS);
                  }))
                  .values()
        );
    }
}
```

太好看了！

主打一个优雅永不过时，
所以我就开始学习stream了，
感觉之前对于这个东西用得一直都不多诶。

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        // 按行读取配置文件:
        List<String> props = List.of("profile=native", "debug=true", "logging=warn", "interval=500");
        Map<String, String> map = props.stream()
                // 把k=v转换为Map[k]=v:
                .map(kv -> {
                    String[] ss = kv.split("\\=", 2);
                    return Map.of(ss[0], ss[1]);
                })
                // 把所有Map聚合到一个Map:
                .reduce(new HashMap<String, String>(), (m, kv) -> {
                    m.putAll(kv);
                    return m;
                });
        // 打印结果:
        map.forEach((k, v) -> {
            System.out.println(k + " = " + v);
        });
    }
}
```

我草，还可以这样操作！reduce还能这样玩……