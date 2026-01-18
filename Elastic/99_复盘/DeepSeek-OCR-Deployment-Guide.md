# DeepSeek-OCR 部署与使用指南

## 📋 目录
- [一、项目简介](#一项目简介)
- [二、部署步骤](#二部署步骤)
- [三、配置说明](#三配置说明)
- [四、使用方法](#四使用方法)
- [五、重要注意事项](#五重要注意事项)
- [六、微服务开发建议](#六微服务开发建议)

---

## 一、项目简介

### 1.1 项目概述
**DeepSeek-OCR** 是一个基于大语言模型的多模态OCR系统，结合了计算机视觉（SAM + CLIP编码器）与语言模型，具备以下能力：
- 文档OCR识别与结构保留
- 图片内容详细描述
- 动态分辨率处理（自动分块）
- 高吞吐量批处理

### 1.2 环境信息
| 项目 | 版本/配置 |
|------|----------|
| 操作系统 | Linux (内核 5.4.0+) |
| GPU | NVIDIA GeForce RTX 3090 (24GB显存) |
| CUDA | 11.8 (系统12.1向下兼容) |
| Python | 3.12.9 |
| PyTorch | 2.6.0+cu118 |
| vLLM | 0.8.5 |
| Flash Attention | 2.7.3 |

### 1.3 项目结构
```
/hy-tmp/
├── DeepSeek-OCR/                    # 项目源码
│   └── DeepSeek-OCR-master/
│       ├── DeepSeek-OCR-hf/         # HuggingFace实现
│       └── DeepSeek-OCR-vllm/       # vLLM实现（推荐）
├── deepseek-ocr-model/              # 模型权重（6.3GB）
├── input/                           # 输入文件目录
└── output/                          # 输出结果目录
```

---

## 二、部署步骤

### 2.1 环境准备

#### Step 1: 创建Conda环境
```bash
conda create -n deepseek-ocr python=3.12.9 -y
conda activate deepseek-ocr
```

#### Step 2: 安装PyTorch
```bash
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu118
```

#### Step 3: 安装vLLM
```bash
# 下载wheel文件并安装
pip install vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl
```

#### Step 4: 安装依赖
```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

#### Step 5: 安装Flash Attention
```bash
pip install flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl
```

### 2.2 模型准备

模型文件应放置在：`/hy-tmp/deepseek-ocr-model/`

包含文件：
- `config.json` - 模型配置
- `tokenizer.json` - 分词器
- `model-00001-of-000001.safetensors` - 模型权重（6.3GB）
- 其他配置文件

### 2.3 配置文件

编辑 `/hy-tmp/DeepSeek-OCR/DeepSeek-OCR-master/DeepSeek-OCR-vllm/config.py`：

```python
# 分辨率模式配置
BASE_SIZE = 1024      # 全局视图尺寸
IMAGE_SIZE = 640      # 局部视图尺寸
CROP_MODE = True      # 是否启用动态分块

# 性能配置
MIN_CROPS = 2         # 最小块数
MAX_CROPS = 6         # 最大块数（24GB显存建议6）
MAX_CONCURRENCY = 100 # 并发数
NUM_WORKERS = 64      # 预处理线程数

# 路径配置
MODEL_PATH = '/hy-tmp/deepseek-ocr-model'
INPUT_PATH = '/hy-tmp/input/test.jpg'
OUTPUT_PATH = '/hy-tmp/output'

# Prompt配置（根据任务选择）
PROMPT = '<image>\nFree OCR.'  # 纯OCR
# PROMPT = '<image>\n<|grounding|>Convert the document to markdown.'  # 文档转Markdown
# PROMPT = '<image>\nDescribe this image in detail.'  # 图片描述
```

---

## 三、配置说明

### 3.1 分辨率模式

| 模式 | BASE_SIZE | IMAGE_SIZE | CROP_MODE | 适用场景 |
|------|-----------|------------|-----------|----------|
| Tiny | 512 | 512 | False | 小图片，快速处理 |
| Small | 640 | 640 | False | 普通图片 |
| Base | 1024 | 1024 | False | 高分辨率图片 |
| Large | 1280 | 1280 | False | 超高分辨率 |
| **Gundam** | **1024** | **640** | **True** | **动态分块（推荐）** |

### 3.2 性能调优参数

#### 显存不足时调整：
```python
# 降低分块数
MAX_CROPS = 4  # 默认6

# 降低并发
MAX_CONCURRENCY = 50  # 默认100

# 降低GPU利用率（在run_dpsk_ocr_image.py中）
gpu_memory_utilization=0.65  # 默认0.75
```

#### 提升速度：
```python
# 增加预处理线程
NUM_WORKERS = 128  # 默认64

# 增加并发
MAX_CONCURRENCY = 200  # 需要足够显存
```

### 3.3 Prompt模式详解

#### 1. 纯文字提取（Free OCR）
```python
PROMPT = '<image>\nFree OCR.'
```
- **输出**：纯文本，无格式
- **速度**：最快
- **适用**：简单文字提取

#### 2. 文档转Markdown
```python
PROMPT = '<image>\n<|grounding|>Convert the document to markdown.'
```
- **输出**：Markdown格式，保留结构
- **特点**：识别标题、表格、段落
- **适用**：论文、报告、文档

#### 3. 图片详细描述
```python
PROMPT = '<image>\nDescribe this image in detail.'
```
- **输出**：自然语言描述
- **内容**：人物、服饰、场景、表情等
- **适用**：图片理解、内容分析

#### 4. 其他Prompt
```python
# 图表解析
PROMPT = '<image>\nParse the figure.'

# 目标定位
PROMPT = '<image>\nLocate <|ref|>xxxx<|/ref|> in the image.'

# OCR with layout
PROMPT = '<image>\n<|grounding|>OCR this image.'
```

---

## 四、使用方法

### 4.1 单图片处理

```bash
cd /hy-tmp/DeepSeek-OCR/DeepSeek-OCR-master/DeepSeek-OCR-vllm

# 1. 修改config.py中的INPUT_PATH
# 2. 选择合适的PROMPT
# 3. 运行
python run_dpsk_ocr_image.py
```

**输出文件：**
```
/hy-tmp/output/
├── result_ori.mmd          # 原始识别结果
├── result.mmd              # 最终处理结果（主要使用）
├── result_with_boxes.jpg   # 可视化标注图
└── images/                 # 提取的子图片
    └── 0.jpg
```

### 4.2 PDF批量处理

```bash
# 修改config.py
INPUT_PATH = '/hy-tmp/input/document.pdf'

# 运行
python run_dpsk_ocr_pdf.py
```

**性能：** 约2500 tokens/s（A100-40G，RTX 3090约1500-2000 tokens/s）

### 4.3 Python API调用

```python
import asyncio
from vllm import AsyncLLMEngine, SamplingParams
from vllm.engine.arg_utils import AsyncEngineArgs
from process.image_process import DeepseekOCRProcessor
from PIL import Image

# 初始化引擎
engine_args = AsyncEngineArgs(
    model='/hy-tmp/deepseek-ocr-model',
    hf_overrides={"architectures": ["DeepseekOCRForCausalLM"]},
    max_model_len=8192,
    trust_remote_code=True,
    gpu_memory_utilization=0.75,
)
engine = AsyncLLMEngine.from_engine_args(engine_args)

# 处理图片
image = Image.open('/path/to/image.jpg').convert('RGB')
prompt = '<image>\nFree OCR.'

sampling_params = SamplingParams(
    temperature=0.0,
    max_tokens=8192,
)

# 生成
request = {
    "prompt": prompt,
    "multi_modal_data": {"image": image}
}

async for output in engine.generate(request, sampling_params):
    print(output.outputs[0].text, end='', flush=True)
```

---

## 五、重要注意事项

### 5.1 显存管理

⚠️ **关键问题：**
- 模型占用：6.23 GB
- 推理峰值：约17-20 GB（24GB显存）
- Gundam模式（动态分块）会显著增加显存使用

**解决方案：**
1. 降低 `MAX_CROPS` (6→4)
2. 降低 `gpu_memory_utilization` (0.75→0.65)
3. 使用较小的分辨率模式（Small/Base）
4. 限制并发数量

### 5.2 性能优化

#### 首次运行慢（~30秒）
- 原因：CUDA图捕获
- 后续：只需3-5秒加载

#### 分辨率选择
- 小于640×640：不需要分块，最快
- 大于640×640：启用Gundam模式自动分块
- 超大图片：适当增加MAX_CROPS

### 5.3 输出结果解读

#### 特殊标记含义
```
<|ref|>image<|/ref|>           # 图片对象标记
<|det|>[[0,0,999,999]]<|/det|> # 坐标检测（归一化0-999）
<td></td>                       # 表格单元格
```

#### 文件选择
- **只需要文字** → `result.mmd`
- **调试查看** → `result_ori.mmd`
- **可视化检查** → `result_with_boxes.jpg`

### 5.4 常见问题

#### Q1: 为什么识别成"整张图片"？
**A:** Prompt模式不匹配。文档模式可能将非文档图片识别为图片对象。使用纯OCR或图片描述模式。

#### Q2: 显存不足（OOM）？
**A:** 按优先级：
1. 降低gpu_memory_utilization
2. 降低MAX_CROPS
3. 降低MAX_CONCURRENCY
4. 切换到Small/Base模式

#### Q3: 识别速度慢？
**A:**
- 首次运行正常（CUDA图捕获）
- 后续仍慢：降低MAX_CROPS或使用更小分辨率
- 考虑批处理（PDF模式）

#### Q4: 中文识别？
**A:** 模型支持多语言，包括中文。无需特殊配置。

---

## 六、微服务开发建议

### 6.1 架构设计

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │ HTTP
       ▼
┌─────────────────────┐
│   FastAPI Gateway   │  ← 微服务层
│  - 请求队列         │
│  - 并发控制         │
│  - 结果缓存         │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│  DeepSeek-OCR       │  ← 推理引擎
│  - vLLM Engine      │
│  - Model Loader     │
└─────────────────────┘
```

### 6.2 核心实现要点

#### 1. 引擎单例模式
⚠️ **不要每次请求都创建引擎！**

```python
# 全局初始化（启动时）
class OCREngine:
    _instance = None
    _engine = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    async def initialize(self):
        if self._engine is None:
            # 只初始化一次
            self._engine = AsyncLLMEngine.from_engine_args(...)
```

#### 2. 请求队列管理
```python
from asyncio import Queue

class RequestQueue:
    def __init__(self, max_concurrent=10):
        self.queue = Queue()
        self.semaphore = asyncio.Semaphore(max_concurrent)

    async def process(self, request):
        async with self.semaphore:
            # 限制并发数
            return await self._ocr_process(request)
```

#### 3. Base64图片处理
```python
import base64
from io import BytesIO

def base64_to_image(base64_str):
    # 支持 data:image/jpeg;base64, 前缀
    if ',' in base64_str:
        base64_str = base64_str.split(',')[1]

    img_data = base64.b64decode(base64_str)
    img = Image.open(BytesIO(img_data))
    return img.convert('RGB')
```

#### 4. 异步处理
```python
from fastapi import FastAPI, UploadFile, BackgroundTasks

app = FastAPI()

@app.post("/ocr")
async def ocr_endpoint(
    file: UploadFile,
    prompt: str = "<image>\nFree OCR.",
    background_tasks: BackgroundTasks = None
):
    # 读取图片
    contents = await file.read()
    img = Image.open(BytesIO(contents)).convert('RGB')

    # 异步处理
    task_id = str(uuid.uuid4())
    background_tasks.add_task(
        process_ocr_async,
        task_id,
        img,
        prompt
    )

    return {"task_id": task_id, "status": "processing"}

@app.get("/result/{task_id}")
async def get_result(task_id: str):
    # 从缓存获取结果
    result = await redis.get(f"ocr:{task_id}")
    return result
```

### 6.3 API设计建议

#### 接口定义
```python
from pydantic import BaseModel

class OCRRequest(BaseModel):
    image: str  # Base64或URL
    mode: str = "ocr"  # ocr | document | describe
    language: str = "auto"  # auto | zh | en

class OCRResponse(BaseModel):
    task_id: str
    status: str  # processing | completed | failed
    result: Optional[str]
    error: Optional[str]

@app.post("/api/v1/ocr", response_model=OCRResponse)
async def ocr_api(request: OCRRequest):
    pass
```

#### 模式映射
```python
MODE_PROMPTS = {
    "ocr": "<image>\nFree OCR.",
    "document": "<image>\n<|grounding|>Convert the document to markdown.",
    "describe": "<image>\nDescribe this image in detail.",
    "figure": "<image>\nParse the figure."
}
```

### 6.4 性能优化

#### 1. 批处理支持
```python
@app.post("/api/v1/ocr/batch")
async def batch_ocr(files: List[UploadFile]):
    # 批量处理，共享引擎
    images = [await load_image(f) for f in files]

    # vLLM支持批处理
    results = await engine.batch_generate(images)
    return results
```

#### 2. 结果缓存
```python
import hashlib

def cache_key(image_bytes, mode):
    return hashlib.md5(image_bytes + mode.encode()).hexdigest()

# Redis缓存
cached = await redis.get(f"ocr:{cache_key}")
if cached:
    return cached
```

#### 3. GPU利用率监控
```python
import pynvml

pynvml.nvmlInit()
handle = pynvml.nvmlDeviceGetHandleByIndex(0)
info = pynvml.nvmlDeviceGetMemoryInfo(handle)

if info.used / info.total > 0.9:
    # 触发降级策略
    reduce_concurrency()
```

### 6.5 部署建议

#### Docker配置
```dockerfile
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# 安装Python和依赖
RUN apt-get update && apt-get install -y python3.10

# 复制环境
COPY environment.yml /app/
RUN conda env create -f /app/environment.yml

# 暴露端口
EXPOSE 8000

# 启动服务
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### Docker Compose
```yaml
version: '3.8'
services:
  deepseek-ocr:
    image: deepseek-ocr:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    ports:
      - "8000:8000"
    environment:
      - CUDA_VISIBLE_DEVICES=0
      - MODEL_PATH=/models/deepseek-ocr
    volumes:
      - ./models:/models
      - ./cache:/cache
```

#### 负载均衡
```python
# 多GPU部署
app = FastAPI()

# 为每个GPU创建引擎
engines = []
for gpu_id in range(torch.cuda.device_count()):
    os.environ["CUDA_VISIBLE_DEVICES"] = str(gpu_id)
    engine = OCREngine(gpu_id=gpu_id)
    await engine.initialize()
    engines.append(engine)

# 轮询分配
current_engine = 0

@app.post("/ocr")
async def ocr_endpoint(...):
    global current_engine
    engine = engines[current_engine]
    current_engine = (current_engine + 1) % len(engines)

    return await engine.process(...)
```

### 6.6 监控与日志

```python
import logging
from prometheus_client import Counter, Histogram

# 监控指标
ocr_requests = Counter('ocr_requests_total', 'Total OCR requests')
ocr_duration = Histogram('ocr_duration_seconds', 'OCR processing time')
ocr_errors = Counter('ocr_errors_total', 'Total OCR errors')

@app.post("/ocr")
@ocr_duration.time()
async def ocr_endpoint(...):
    ocr_requests.inc()
    try:
        result = await process_ocr(...)
        return result
    except Exception as e:
        ocr_errors.inc()
        logger.error(f"OCR failed: {e}")
        raise
```

---

## 七、快速参考

### 7.1 常用命令

```bash
# 激活环境
conda activate deepseek-ocr

# 查看GPU状态
nvidia-smi

# 运行单图片OCR
cd /hy-tmp/DeepSeek-OCR/DeepSeek-OCR-master/DeepSeek-OCR-vllm
python run_dpsk_ocr_image.py

# 运行PDF处理
python run_dpsk_ocr_pdf.py

# 查看结果
cat /hy-tmp/output/result.mmd
```

### 7.2 配置速查

| 需求 | 配置 |
|------|------|
| 最快速度 | `CROP_MODE=False`, `BASE_SIZE=640` |
| 最高精度 | `CROP_MODE=True`, `BASE_SIZE=1024` |
| 节省显存 | `MAX_CROPS=2`, `gpu_memory_utilization=0.6` |
| 纯文字 | `PROMPT='<image>\nFree OCR.'` |
| 文档结构 | `PROMPT='<image>\n<|grounding|>Convert to markdown.'` |
| 图片描述 | `PROMPT='<image>\nDescribe in detail.'` |

### 7.3 故障排除

| 问题 | 解决方案 |
|------|----------|
| CUDA OOM | 降低`gpu_memory_utilization`或`MAX_CROPS` |
| 导入错误 | 确认`flash-attn`已安装 |
| 结果为空 | 检查`PROMPT`模式和图片格式 |
| 速度慢 | 首次运行正常，或降低分辨率 |

---

## 八、联系方式

- **部署日期**: 2025-12-28
- **GPU**: RTX 3090 (24GB)
- **测试状态**: ✅ 通过

**最后更新**: 2025-12-28
