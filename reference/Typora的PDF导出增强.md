
```html
<style>
/* 自定义页眉样式 */
@page {
    margin-top: 100px; /* 为页眉图片留出空间 */
    
    @top-left {
        content: "";
        background-image: url('file://E:/I/logo.jpg');
        background-size: contain;
        background-repeat: no-repeat;
        width: 150px;
        height: 50px;
    }
}
</style>
```