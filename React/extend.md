我遇到一个TypeScript的问题，
我定义了一个函数，
它的参数的类型是file: File
但是我传递的时候是自定义了一个参数类型

```
            let sendFile = {
                fileMD5: uploadFile.md5,
                suffix: uploadFile.suffix,
                filePath: uploadFile.filePath,
                fileSize: uploadFile.fileSize,
                originName: uploadFile.name,
                ...uploadFile
            }
```

我应该怎么办？
因为这里的fileMD5对我来说非常重要。
