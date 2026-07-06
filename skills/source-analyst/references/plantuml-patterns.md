# PlantUML 活动图映射模式

从代码结构到 PlantUML 活动图语法的直接映射模式。

## if-else 条件判断

```java
if (condition) {
    actionA();
} else {
    actionB();
}
```

```plantuml
if (condition) then (yes)
    :actionA();
else (no)
    :actionB();
endif
```

## if-else if-else 多重条件

```java
if (condition1) {
    actionA();
} else if (condition2) {
    actionB();
} else {
    actionC();
}
```

```plantuml
if (condition1) then (yes)
    :actionA();
elseif (condition2) then (yes)
    :actionB();
else (no)
    :actionC();
endif
```

## for 循环

```java
for (Item item : itemList) {
    processItem(item);
}
```

```plantuml
while (has more items?) is (yes)
    :processItem();
endwhile (no)
```

> 对于 for 循环，通常使用 while 循环的语义来表达，这在活动图中更自然。

## switch 分支

```java
switch (status) {
    case A:
        handleA();
        break;
    case B:
        handleB();
        break;
    default:
        handleDefault();
        break;
}
```

```plantuml
switch (status)
case (A)
    :handleA();
case (B)
    :handleB();
case (default)
    :handleDefault();
endswitch
```

## 跨类调用

```java
// In ClassA
public void doWork() {
    // ...
    classB.performTask();
    // ...
}
```

```plantuml
|ClassA|
    :doWork entry;
|ClassB|
    :performTask();
|ClassA|
    :return from performTask;
```

> 通过切换到不同的**类泳道** `|ClassName|` 来表示对象间的协作。泳道代表类，而非方法。

## 主函数分区与注释

```java
public void mainFunction() {
    // ... main logic ...
}
```

```plantuml
partition "Function: mainFunction" {
  ' 这是对此函数核心逻辑的总结。
  ' 1. 它首先做什么。
  ' 2. 然后调用什么关键服务。

  :step 1;
  :step 2;
}
```
