# FlatBuffer 测试

使用版本：v1.12.0
地址：https://github.com/google/flatbuffers/releases/tag/v1.12.0

## 笔记

### Schema

- 为了兼容，FlatBuffer `table`不允许删除字段，你可以将不需要的字段设置为`deprecated`

### Reading & Writing

- `struct`可以内联创建，`struct`是多个标量简单的组合，始终以内联方式存储

    ```
    monster.AddPos(builder, vec3.CreateVec3(builder, 1.0, 2.0, 3.0))
    ```

- `table`或其他 objects，不能嵌套创建，如果在`start`、`end`过程中创建，会抛出异常

