



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