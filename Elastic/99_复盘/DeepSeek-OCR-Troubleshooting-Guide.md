# DeepSeek-OCR 部署问题与解决方案

## 📋 文档说明

本文档记录了DeepSeek-OCR在实际部署过程中遇到的所有问题、根本原因分析以及预防措施。**强烈建议在部署前完整阅读本文档，避免踩坑。**

---

## 🔴 问题一：网络下载速度极慢

### 问题描述
从GitHub releases下载以下文件时速度极慢（~40KB/s）：
- vLLM 0.8.5 wheel文件（204MB）
- Flash Attention wheel文件（185MB）

**预计下载时间：45-60分钟**

### 根本原因
- GitHub releases的CDN节点在某些地区访问速度慢
- 大文件下载不稳定，容易中断
- 企业网络可能限制GitHub访问

### 解决方案

#### 方案1：使用本地文件上传（推荐）✅
```bash
# 在其他网络好的环境下载
wget https://github.com/vllm-project/vllm/releases/download/v0.8.5/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl

# 打包成zip
zip vllm.zip vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl

# 上传到服务器
scp vllm.zip user@server:/hy-tmp/weight/
```

#### 方案2：使用国内镜像（部分可用）
```bash
# vLLM暂无稳定镜像，建议方案1
# Flash Attention可尝试:
pip install flash-attn --no-deps -i https://mirrors.aliyun.com/pypi/simple/
```

#### 方案3：使用代理（如果有）
```bash
export https_proxy=http://proxy-server:port
wget https://github.com/...
```

### ✅ 预防措施
1. **提前下载**：在部署前1天将所有依赖下载到本地
2. **准备离线包**：制作包含所有wheel的安装包
3. **使用局域网文件服务器**：搭建内部pip镜像

### 📦 需要提前下载的文件清单
```
/hy-tmp/offline_packages/
├── vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl (204MB)
├── flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl (185MB)
├── torch-2.6.0+cu118-*.whl
└── requirements.txt中的所有包
```

---

## 🔴 问题二：根分区磁盘空间不足

### 问题描述
pip安装过程中报错：
```
ERROR: [Errno 28] No space left on device
```

检查发现：
```
文件系统      大小  已用 可用 使用% 挂载点
overlay       30G   30G  756M  98%  /
```

**根分区只剩756MB，但数据分区/hy-tmp有48GB可用**

### 根本原因
1. Docker容器使用overlay文件系统，根分区默认30GB
2. pip默认使用`/root/.cache/pip`作为缓存目录（在根分区）
3. 之前的pip缓存占用了11GB空间
4. modelscope缓存占用了6.3GB空间

### 解决方案

#### 步骤1：清理缓存（紧急救援）✅
```bash
# 清理pip缓存（释放11GB）
rm -rf /root/.cache/pip/*

# 清理modelscope缓存（释放6.3GB）
rm -rf /root/.cache/modelscope/*

# 清理npm缓存（如果有）
rm -rf /root/.npm/*

# 验证空间
df -h /
```

#### 步骤2：设置pip缓存目录（永久解决）✅
```bash
# 在.bashrc或.zshrc中添加
export PIP_CACHE_DIR="/hy-tmp/pip_cache"
mkdir -p /hy-tmp/pip_cache

# 或每次安装时指定
pip install package --cache-dir=/hy-tmp/pip_cache
```

#### 步骤3：设置pip临时目录
```bash
# pip构建时使用大分区
export TMPDIR=/hy-tmp/tmp
mkdir -p /hy-tmp/tmp

# 使用
pip install package --build=/hy-tmp/tmp
```

### ✅ 预防措施

#### 部署前检查清单
```bash
# 1. 检查各分区空间
df -h

# 2. 找出大文件
du -sh /root/.cache/* | sort -hr | head -20

# 3. 设置环境变量（添加到~/.bashrc）
cat >> ~/.bashrc << 'EOF'
# pip缓存目录
export PIP_CACHE_DIR="/hy-tmp/pip_cache"
export TMPDIR="/hy-tmp/tmp"

# conda配置
export CONDA_PKGS_DIR="/hy-tmp/conda_pkgs"
EOF

source ~/.bashrc

# 4. 创建必要目录
mkdir -p /hy-tmp/pip_cache /hy-tmp/tmp /hy-tmp/conda_pkgs
```

#### Docker部署时的处理
```dockerfile
# 在Dockerfile中设置
ENV PIP_CACHE_DIR=/app/cache
ENV TMPDIR=/app/tmp
RUN mkdir -p /app/cache /app/tmp

# 或使用volume挂载
docker run -v /host/tmp:/app/tmp ...
```

---

## 🔴 问题三：CUDA版本不匹配

### 问题描述
安装Flash Attention时报错：
```
RuntimeError: The detected CUDA version (12.1) mismatches the version
that was used to compile PyTorch (11.8).
```

**系统环境：**
- 系统CUDA: 12.1
- PyTorch编译版本: 11.8
- 需要的Flash Attention: CUDA 11.8版本

### 根本原因
1. 系统安装了新版本CUDA（12.1）
2. PyTorch是使用旧版本CUDA（11.8）编译的
3. Flash Attention需要与PyTorch匹配的CUDA版本
4. 从源码编译会检测系统CUDA版本，导致不匹配

### 解决方案

#### 方案1：下载预编译wheel（推荐）✅
```bash
# 必须下载匹配PyTorch CUDA版本的wheel
# PyTorch 2.6.0+cu118 → Flash Attention cu11版本

# 正确的文件名格式：
flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl
#             ^^^^ ^^^^^^^^^^  ^^^^^^^^  ^^^^  ^^^^
#             CUDA PyTorch版本  cxx_abi   Python 平台

# 安装
pip install flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl
```

#### 方案2：使用conda安装（备选）
```bash
# 可能自动处理CUDA版本匹配
conda install -c conda-forge flash-attn
```

### ✅ 预防措施

#### 部署前环境检查
```bash
# 1. 检查系统CUDA版本
nvidia-smi
# 或
nvcc --version

# 2. 检查PyTorch CUDA版本
python -c "import torch; print(torch.version.cuda)"

# 3. 确认版本匹配规则
# PyTorch cu118 → 需要 CUDA 11.x 的依赖
# PyTorch cu121 → 需要 CUDA 12.x 的依赖

# 4. 下载对应版本的预编译包
# 查看所有可用版本：
# https://github.com/Dao-AILab/flash-attention/releases
```

#### 版本对应表
| PyTorch版本 | 系统CUDA | Flash Attention版本 |
|-------------|----------|-------------------|
| torch+cu118 | 11.8或12.1 | flash_attn+cu11torch2.6 |
| torch+cu121 | 12.1 | flash_attn+cu12torch2.6 |

---

## 🔴 问题四：wheel文件损坏

### 问题描述
下载的vLLM wheel文件安装时报错：
```
ERROR: Wheel 'vllm' located at ... is invalid.
```

检查文件大小：
```
-rw-r--r-- 1 root root 40M ... vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl
```
**实际应该是204MB，但只有40MB**，说明下载未完成。

### 根本原因
1. 网络不稳定导致下载中断
2. wget未检测到下载失败
3. 文件不完整但仍被保存

### 解决方案

#### 步骤1：验证文件完整性
```bash
# 检查文件大小
ls -lh vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl

# 应该是204MB左右，如果明显偏小则损坏

# 尝试解压测试
unzip -t vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl
# 如果报错则文件损坏
```

#### 步骤2：重新下载
```bash
# 删除损坏文件
rm -f vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl

# 使用断点续传重新下载
wget -c https://github.com/...

# 或使用curl（更可靠）
curl -C - -O https://github.com/...
```

#### 步骤3：使用校验和验证（如果提供）
```bash
# GitHub releases通常提供SHA256
# 下载.sha256文件
wget https://github.com/.../vllm-0.8.5.sha256

# 验证
sha256sum -c vllm-0.8.5.sha256
```

### ✅ 预防措施

#### 下载后验证脚本
```bash
#!/bin/bash
# verify_download.sh

WHEEL_FILE=$1

# 检查文件是否存在
if [ ! -f "$WHEEL_FILE" ]; then
    echo "错误: 文件不存在"
    exit 1
fi

# 检查文件大小
SIZE=$(du -b "$WHEEL_FILE" | cut -f1)
echo "文件大小: $SIZE bytes"

# vLLM应该约204MB
if [ $SIZE -lt 200000000 ]; then
    echo "警告: 文件大小异常，可能下载不完整"
    exit 1
fi

# 尝试验证wheel格式
if unzip -t "$WHEEL_FILE" >/dev/null 2>&1; then
    echo "✅ 文件验证成功"
else
    echo "❌ 文件损坏，请重新下载"
    exit 1
fi
```

使用方法：
```bash
chmod +x verify_download.sh
./verify_download.sh vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl
```

---

## 🔴 问题五：ModuleNotFoundError: No module named 'flash_attn'

### 问题描述
运行测试时导入错误：
```python
from deepseek_ocr import DeepseekOCRForCausalLM
# ModuleNotFoundError: No module named 'flash_attn'
```

虽然已经安装了Flash Attention，但Python找不到该模块。

### 根本原因
1. 安装到了错误的Python环境
2. 使用了不同的conda环境
3. pip和python命令指向不同的环境

### 解决方案

#### 步骤1：确认当前环境
```bash
# 检查当前Python路径
which python
# /usr/local/miniconda3/envs/deepseek-ocr/bin/python

# 检查当前pip路径
which pip
# 应该与python在同一环境

# 如果不一致，使用python -m pip
python -m pip install ...
```

#### 步骤2：确认环境已激活
```bash
# 确保conda环境已激活
conda activate deepseek-ocr

# 验证
echo $CONDA_DEFAULT_ENV
# 应该显示: deepseek-ocr

# 检查Python版本
python --version
# Python 3.12.9
```

#### 步骤3：在正确环境重新安装
```bash
# 激活环境
conda activate deepseek-ocr

# 使用python -m pip确保安装到正确位置
python -m pip install flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl

# 验证
python -c "import flash_attn; print('✅ 安装成功')"
```

### ✅ 预防措施

#### 使用统一的工作流程
```bash
# 1. 创建环境时指定Python版本
conda create -n deepseek-ocr python=3.12.9 -y

# 2. 总是先激活环境
conda activate deepseek-ocr

# 3. 使用python -m pip而不是pip
python -m pip install package

# 4. 在脚本开头添加shebang和conda激活
#!/bin/bash
set -e
source /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate deepseek-ocr

python your_script.py
```

#### 创建安装验证脚本
```bash
#!/bin/bash
# verify_installation.sh

source /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate deepseek-ocr

echo "验证关键依赖..."
python << 'EOF'
import sys

packages = {
    'torch': 'PyTorch',
    'vllm': 'vLLM',
    'flash_attn': 'Flash Attention',
    'transformers': 'Transformers',
    'PIL': 'Pillow',
}

failed = []
for pkg, name in packages.items():
    try:
        __import__(pkg)
        print(f"✅ {name}")
    except ImportError:
        print(f"❌ {name}")
        failed.append(name)

if failed:
    print(f"\n缺少依赖: {', '.join(failed)}")
    sys.exit(1)
else:
    print("\n所有依赖安装正确！")
    sys.exit(0)
EOF
```

---

## 🔴 问题六：pip依赖冲突

### 问题描述
安装vLLM时报错：
```
ERROR: pip's dependency resolver does not currently take into account
all the packages that are installed.
```

虽然安装成功，但可能导致运行时问题。

### 根本原因
1. requirements.txt中指定了transformers==4.46.3
2. vLLM需要transformers>=4.51.1
3. 版本冲突但pip仍继续安装

### 解决方案

#### 方案1：忽略版本冲突（文档推荐）✅
```bash
# 这是官方文档承认的问题
# DeepSeek-OCR的vLLM实现和HuggingFace实现可以使用不同环境

# 如果只用vLLM版本，可以忽略此警告
pip install vllm==0.8.5 --no-deps
```

#### 方案2：使用兼容的版本
```bash
# 升级transformers（可能需要测试兼容性）
pip install transformers>=4.51.1

# 或者降级vLLM（如果有对应版本）
pip install vllm==0.9.0  # 较新版本可能修复
```

### ✅ 预防措施

#### 分离环境（推荐）
```bash
# 为vLLM和HF创建不同环境
conda create -n deepseek-ocr-vllm python=3.12.9 -y
conda create -n deepseek-ocr-hf python=3.12.9 -y

# vLLM环境：使用vLLM实现
conda activate deepseek-ocr-vllm
pip install vllm==0.8.5 ...

# HF环境：使用HuggingFace实现
conda activate deepseek-ocr-hf
pip install transformers==4.46.3 ...
```

---

## 🔴 问题七：显存不足（OOM）

### 问题描述
运行时报错：
```
torch.cuda.OutOfMemoryError: CUDA out of memory.
```

或推理过程中程序崩溃。

### 根本原因
1. Gundam模式（CROP_MODE=True）会显著增加显存使用
2. MAX_CROPS=6对于大图片可能超出24GB显存
3. gpu_memory_utilization=0.75 + KV Cache + 激活值超出显存

### 解决方案

#### 紧急降级方案
```python
# 在config.py中修改
MAX_CROPS = 4  # 从6降到4
MAX_CONCURRENCY = 50  # 从100降到50
```

#### 在run_dpsk_ocr_image.py中调整
```python
engine_args = AsyncEngineArgs(
    ...
    gpu_memory_utilization=0.65,  # 从0.75降到0.65
)
```

#### 切换分辨率模式
```python
# 如果Gundam模式仍然OOM
# 切换到Base模式（无分块）
BASE_SIZE = 1024
IMAGE_SIZE = 1024
CROP_MODE = False
```

### ✅ 预防措施

#### 显存监控脚本
```bash
#!/bin/bash
# monitor_gpu.sh

watch -n 1 'nvidia-smi --query-gpu=memory.used,memory.free,utilization.gpu --format=csv,noheader,nounits'
```

#### 根据图片大小动态选择模式
```python
def select_mode(image_path):
    from PIL import Image
    img = Image.open(image_path)
    width, height = img.size

    # 小图片：不需要分块
    if width <= 1024 and height <= 1024:
        return {"BASE_SIZE": 1024, "IMAGE_SIZE": 1024, "CROP_MODE": False}

    # 中等图片：Gundam模式，少量分块
    elif width <= 1920 and height <= 1920:
        return {"BASE_SIZE": 1024, "IMAGE_SIZE": 640, "CROP_MODE": True, "MAX_CROPS": 4}

    # 大图片：Gundam模式，充分分块
    else:
        return {"BASE_SIZE": 1024, "IMAGE_SIZE": 640, "CROP_MODE": True, "MAX_CROPS": 6}
```

#### 显存预留策略
```python
# 计算安全配置
total_gpu_memory_gb = 24  # RTX 3090

# 各部分占用估算
model_weights_gb = 6.5
kv_cache_gb = total_gpu_memory_gb * 0.75 * 0.6  # KV Cache占可用显存的60%
activation_gb = 1.0

# 计算gpu_memory_utilization
safe_utilization = (total_gpu_memory_gb - model_weights_gb - activation_gb) / total_gpu_memory_gb
# 约等于0.7-0.75

# 如果OOM，逐步降低
for util in [0.75, 0.70, 0.65, 0.60, 0.55]:
    try:
        # 尝试运行
        ...
        break
    except OOM:
        continue
```

---

## 🔴 问题八：首次运行很慢

### 问题描述
首次运行时等待时间很长（~30秒），以为程序卡死了。

```
INFO: Capturing CUDA graph shapes: 0%|...| 100%
```

### 根本原因
vLLM在首次运行时会进行CUDA图捕获优化，为不同批次大小预编译CUDA核函数。这个过程：
- 捕获35个不同batch size的CUDA图
- 每个图需要编译和验证
- 总共耗时约15-20秒

### 解决方案

#### 方案1：耐心等待（正常现象）✅
```
这是正常的优化过程，只需要忍受一次
```

#### 方案2：禁用CUDA图（不推荐）
```python
engine_args = AsyncEngineArgs(
    ...
    enforce_eager=True,  # 跳过CUDA图捕获
)
```
**缺点：**推理速度会显著下降（约2-3倍）

#### 方案3：预加载模型
```bash
# 服务启动时预先触发CUDA图捕获
python preload_model.py
```

```python
# preload_model.py
async def warmup(engine):
    """预热引擎，触发CUDA图捕获"""
    dummy_image = Image.new('RGB', (640, 640), color='white')

    sampling_params = SamplingParams(
        temperature=0.0,
        max_tokens=100,
    )

    request = {
        "prompt": "<image>\nWarmup.",
        "multi_modal_data": {"image": dummy_image}
    }

    # 触发CUDA图捕获
    async for _ in engine.generate(request, sampling_params):
        pass

    print("✅ 模型预热完成")
```

### ✅ 预防措施

#### 添加进度提示
```python
import sys
import time

def print_progress(stage, total, current):
    percent = current / total * 100
    bar = '█' * int(percent / 2) + '░' * (50 - int(percent / 2))
    sys.stdout.write(f'\r{stage}: [{bar}] {percent:.1f}%')
    sys.stdout.flush()

# 在捕获CUDA图时
for i in range(35):
    print_progress("CUDA图捕获", 35, i+1)
    # ... capture ...
print()  # 换行
```

#### 服务启动时的优化流程
```python
# 1. 服务启动
print("🚀 启动DeepSeek-OCR服务...")

# 2. 加载模型
print("📦 加载模型权重...")
engine = load_engine()

# 3. 捕获CUDA图
print("⚡ 优化CUDA核函数（首次运行，需30秒）...")
await warmup(engine)

# 4. 服务就绪
print("✅ 服务就绪，可以接受请求")
```

---

## 🔴 问题九：识别结果为空或不准确

### 问题描述
1. 纯文字图片识别成 `<|ref|>image<|/ref|>...`
2. 识别结果不完整
3. 丢失某些文字

### 根本原因
**Prompt模式不匹配**

不同场景需要不同的Prompt：
- 文档OCR → 文档转Markdown Prompt
- 纯文字提取 → Free OCR Prompt
- 图片理解 → 描述Prompt

### 解决方案

#### 问题1：文档被识别为"整张图片"
```python
# ❌ 错误：使用了文档模式对非文档图片
PROMPT = '<image>\n<|grounding|>Convert the document to markdown.'

# ✅ 正确：使用纯OCR模式
PROMPT = '<image>\nFree OCR.'
```

#### 问题2：需要保留文档结构
```python
# ❌ 错误：使用了纯OCR
PROMPT = '<image>\nFree OCR.'

# ✅ 正确：使用文档模式
PROMPT = '<image>\n<|grounding|>Convert the document to markdown.'
```

#### 问题3：想要图片描述
```python
# ✅ 使用描述模式
PROMPT = '<image>\nDescribe this image in detail.'
```

### Prompt模式对照表

| 图片类型 | 推荐Prompt | 输出格式 |
|----------|-----------|----------|
| 简单文字图片 | `<image>\nFree OCR.` | 纯文本 |
| 论文/报告 | `<image>\n<|grounding|>Convert the document to markdown.` | Markdown |
| 海报/截图 | `<image>\nFree OCR.` | 纯文本 |
| 人物照片 | `<image>\nDescribe this image in detail.` | 自然语言描述 |
| 图表/流程图 | `<image>\nParse the figure.` | 结构化描述 |
| 需要定位物体 | `<image>\nLocate <|ref|>目标<|/ref|>` | 坐标+描述 |

### ✅ 预防措施

#### 创建模式选择辅助工具
```python
def auto_select_prompt(image_path, user_intent=None):
    """
    根据图片特征和用户意图自动选择Prompt

    Args:
        image_path: 图片路径
        user_intent: 用户意图（如果有明确需求）

    Returns:
        str: 推荐的Prompt
    """
    from PIL import Image

    img = Image.open(image_path)
    width, height = img.size

    # 用户有明确意图
    if user_intent == "ocr":
        return '<image>\nFree OCR.'
    elif user_intent == "document":
        return '<image>\n<|grounding|>Convert the document to markdown.'
    elif user_intent == "describe":
        return '<image>\nDescribe this image in detail.'

    # 根据图片特征推断
    aspect_ratio = width / height

    # 宽幅或长幅，可能是文档
    if aspect_ratio > 2 or aspect_ratio < 0.5:
        if width > 2000 or height > 2000:
            return '<image>\n<|grounding|>Convert the document to markdown.'

    # 正方形或接近正方形
    return '<image>\nFree OCR.'
```

---

## 🔴 问题十：配置文件修改繁琐

### 问题描述
每次处理不同图片都需要：
1. 编辑config.py
2. 修改INPUT_PATH
3. 选择PROMPT
4. 运行脚本

容易出错且效率低。

### 解决方案

#### 方案1：命令行参数化
```python
# run_dpsk_ocr_cli.py
import argparse
from config import Config

def main():
    parser = argparse.ArgumentParser(description='DeepSeek-OCR CLI')
    parser.add_argument('--input', required=True, help='输入图片路径')
    parser.add_argument('--output', default='/hy-tmp/output', help='输出目录')
    parser.add_argument('--mode', choices=['ocr', 'document', 'describe'],
                       default='ocr', help='识别模式')

    args = parser.parse_args()

    # 动态设置Prompt
    PROMPTS = {
        'ocr': '<image>\nFree OCR.',
        'document': '<image>\n<|grounding|>Convert the document to markdown.',
        'describe': '<image>\nDescribe this image in detail.',
    }

    # 运行
    process_ocr(
        input_path=args.input,
        output_path=args.output,
        prompt=PROMPTS[args.mode]
    )
```

使用：
```bash
python run_dpsk_ocr_cli.py \
    --input /path/to/image.jpg \
    --mode ocr \
    --output /path/to/output
```

#### 方案2：配置文件模板
```bash
# 创建多个配置文件
cp config.py config_ocr.py      # 纯OCR配置
cp config.py config_document.py # 文档配置
cp config.py config_describe.py # 描述配置

# 修改每个配置的PROMPT

# 运行时指定
python run_dpsk_ocr_image.py --config config_ocr.py
```

#### 方案3：交互式选择
```python
# run_interactive.py
def interactive_mode():
    print("请选择模式:")
    print("1. 纯OCR（快速文字提取）")
    print("2. 文档转Markdown（保留结构）")
    print("3. 图片详细描述")

    choice = input("请输入选项 (1/2/3): ").strip()

    modes = {
        '1': 'ocr',
        '2': 'document',
        '3': 'describe'
    }

    mode = modes.get(choice, 'ocr')

    input_path = input("请输入图片路径: ").strip()

    return process_ocr(input_path, mode)
```

### ✅ 预防措施

#### 创建统一的入口脚本
```bash
#!/bin/bash
# deepseek_ocr.sh - 一键运行脚本

MODE=${1:-ocr}        # 默认ocr模式
INPUT=${2:-}          # 图片路径
OUTPUT=${3:-/hy-tmp/output}  # 输出目录

if [ -z "$INPUT" ]; then
    echo "用法: $0 <模式> <图片路径> [输出目录]"
    echo ""
    echo "模式选项:"
    echo "  ocr      - 纯文字提取"
    echo "  document - 文档转Markdown"
    echo "  describe - 图片描述"
    echo ""
    echo "示例:"
    echo "  $0 ocr /path/to/image.jpg"
    echo "  $0 document /path/to/document.pdf /custom/output"
    exit 1
fi

source /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate deepseek-ocr

cd /hy-tmp/DeepSeek-OCR/DeepSeek-OCR-master/DeepSeek-OCR-vllm

# 根据模式设置Prompt
case $MODE in
  ocr)
    PROMPT='<image>\nFree OCR.'
    ;;
  document)
    PROMPT='<image>\n<|grounding|>Convert the document to markdown.'
    ;;
  describe)
    PROMPT='<image>\nDescribe this image in detail.'
    ;;
  *)
    echo "未知模式: $MODE"
    exit 1
    ;;
esac

# 临时修改config.py
sed -i.bak "s|^PROMPT = .*|PROMPT = '$PROMPT'|" config.py
sed -i.bak "s|^INPUT_PATH = .*|INPUT_PATH = '$INPUT'|" config.py
sed -i.bak "s|^OUTPUT_PATH = .*|OUTPUT_PATH = '$OUTPUT'|" config.py

# 运行
python run_dpsk_ocr_image.py

# 恢复config.py
mv config.py.bak config.py

echo "✅ 处理完成，结果保存在: $OUTPUT"
```

使用：
```bash
chmod +x deepseek_ocr.sh

# 纯OCR
./deepseek_ocr.sh ocr /hy-tmp/input/test.jpg

# 文档模式
./deepseek_ocr.sh document /hy-tmp/input/doc.pdf

# 图片描述
./deepseek_ocr.sh describe /hy-tmp/input/photo.jpg
```

---

## 📊 部署问题总结

### 问题分类统计

| 类别 | 问题数量 | 严重程度 |
|------|----------|----------|
| 网络相关 | 2 | ⚠️ 中等 |
| 磁盘空间 | 2 | 🔴 严重 |
| 版本兼容 | 2 | 🔴 严重 |
| 配置使用 | 4 | ⚠️ 中等 |

### 关键教训

#### ✅ 部署前必做检查清单
```bash
#!/bin/bash
echo "=== DeepSeek-OCR 部署前检查 ==="

# 1. 磁盘空间
echo "检查磁盘空间..."
ROOT_FREE=$(df / | tail -1 | awk '{print $4}')
if [ $ROOT_FREE -lt 5242880 ]; then  # 小于5GB
    echo "❌ 根分区空间不足（<5GB），请先清理"
    exit 1
fi
echo "✅ 磁盘空间充足"

# 2. Python版本
echo "检查Python版本..."
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
if [ "$PYTHON_VERSION" != "3.12.9" ]; then
    echo "⚠️ Python版本不是3.12.9，可能有问题"
fi

# 3. CUDA
echo "检查CUDA..."
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ 未检测到NVIDIA驱动"
    exit 1
fi
echo "✅ CUDA可用"

# 4. 缓存目录设置
echo "设置缓存目录..."
export PIP_CACHE_DIR="/hy-tmp/pip_cache"
export TMPDIR="/hy-tmp/tmp"
mkdir -p /hy-tmp/pip_cache /hy-tmp/tmp
echo "✅ 缓存目录已设置"

# 5. 验证文件
echo "检查依赖文件..."
for file in \
    "/hy-tmp/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl" \
    "/hy-tmp/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl"
do
    if [ ! -f "$file" ]; then
        echo "❌ 缺少文件: $file"
        exit 1
    fi
done
echo "✅ 所有依赖文件就绪"

echo ""
echo "=== ✅ 所有检查通过，可以开始部署 ==="
```

### 🎯 最佳实践建议

#### 1. 离线部署包准备
```bash
# 创建完整的离线安装包
mkdir -p deepseek-ocr-offline
cd deepseek-ocr-offline

# 1. 复制wheel文件
cp /path/to/vllm*.whl .
cp /path/to/flash_attn*.whl .

# 2. 下载所有Python依赖
pip download -r requirements.txt -d ./pypi_packages

# 3. 打包
tar czf deepseek-ocr-offline.tar.gz .

# 4. 在目标机器上解压
tar xzf deepseek-ocr-offline.tar.gz
cd deepseek-ocr-offline

# 5. 本地安装
pip install --no-index --find-links=pypi_packages -r requirements.txt
pip install vllm*.whl --no-deps
pip install flash_attn*.whl --no-build-isolation
```

#### 2. 自动化部署脚本
```bash
#!/bin/bash
# auto_deploy.sh - 一键部署脚本

set -e  # 遇到错误立即退出

echo "🚀 开始部署DeepSeek-OCR..."

# 步骤1：环境检查
./pre_check.sh || exit 1

# 步骤2：创建conda环境
echo "创建conda环境..."
conda create -n deepseek-ocr python=3.12.9 -y

# 步骤3：激活环境
source /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate deepseek-ocr

# 步骤4：设置环境变量
cat >> ~/.bashrc << 'EOF'
# DeepSeek-OCR环境变量
export PIP_CACHE_DIR="/hy-tmp/pip_cache"
export TMPDIR="/hy-tmp/tmp"
export CONDA_PKGS_DIR="/hy-tmp/conda_pkgs"
EOF

source ~/.bashrc

# 步骤5：清理旧缓存
rm -rf /root/.cache/pip/*
rm -rf /root/.cache/modelscope/*

# 步骤6：安装PyTorch
echo "安装PyTorch..."
pip install torch==2.6.0 torchvision==0.21.0 \
    --index-url https://download.pytorch.org/whl/cu118

# 步骤7：安装依赖
echo "安装依赖包..."
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 步骤8：安装vLLM和Flash Attention
echo "安装vLLM和Flash Attention..."
pip install ./vllm*.whl --no-deps
pip install ./flash_attn*.whl --no-build-isolation

# 步骤9：验证安装
echo "验证安装..."
python verify_installation.py || exit 1

# 步骤10：测试运行
echo "运行测试..."
python run_dpsk_ocr_image.py

echo ""
echo "✅ 部署完成！"
```

#### 3. 监控与日志
```python
# logging_config.py
import logging
from logging.handlers import RotatingFileHandler
import os

def setup_logging():
    """配置日志系统"""
    log_dir = "/hy-tmp/logs"
    os.makedirs(log_dir, exist_ok=True)

    # 创建logger
    logger = logging.getLogger("deepseek_ocr")
    logger.setLevel(logging.INFO)

    # 文件处理器（自动轮转）
    file_handler = RotatingFileHandler(
        f"{log_dir}/ocr.log",
        maxBytes=10*1024*1024,  # 10MB
        backupCount=5
    )
    file_handler.setLevel(logging.INFO)

    # 控制台处理器
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)

    # 格式化
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger

# 使用
logger = setup_logging()
logger.info("DeepSeek-OCR 服务启动")
```

---

## 📞 获取帮助

如果遇到本文档未涵盖的问题：

1. **检查日志**：查看 `/hy-tmp/logs/ocr.log`
2. **验证环境**：运行 `verify_installation.sh`
3. **查看GPU状态**：运行 `nvidia-smi`
4. **检查磁盘空间**：运行 `df -h`

### 诊断信息收集
```bash
#!/bin/bash
# collect_diagnostic_info.sh

OUTPUT="/hy-tmp/diagnostic_info.txt"

echo "=== DeepSeek-OCR 诊断信息 ===" > $OUTPUT
echo "生成时间: $(date)" >> $OUTPUT
echo "" >> $OUTPUT

echo "=== 系统信息 ===" >> $OUTPUT
uname -a >> $OUTPUT
echo "" >> $OUTPUT

echo "=== GPU信息 ===" >> $OUTPUT
nvidia-smi >> $OUTPUT
echo "" >> $OUTPUT

echo "=== 磁盘空间 ===" >> $OUTPUT
df -h >> $OUTPUT
echo "" >> $OUTPUT

echo "=== Python环境 ===" >> $OUTPUT
conda activate deepseek-ocr
python --version >> $OUTPUT
echo "" >> $OUTPUT

echo "=== 已安装包 ===" >> $OUTPUT
pip list >> $OUTPUT
echo "" >> $OUTPUT

echo "=== CUDA版本 ===" >> $OUTPUT
python -c "import torch; print(f'PyTorch CUDA: {torch.version.cuda}')" >> $OUTPUT
nvcc --version >> $OUTPUT
echo "" >> $OUTPUT

echo "✅ 诊断信息已保存到: $OUTPUT"
```

---

**文档版本**: v1.0
**最后更新**: 2025-12-28
**适用版本**: DeepSeek-OCR + vLLM 0.8.5
