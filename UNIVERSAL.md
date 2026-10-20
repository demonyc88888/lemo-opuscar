# Lemo-Opuscar · 通用版（Universal）

这个 fork 在不改动上游任何文件（`styles/`、`core/`、指南原文）的前提下，把 Lemo-Opuscar 从「Claude Code 专用」扩成「多 Harness 通用」：内容与引擎本来就与模型无关，真正要补的只是各平台的打包与说明。原理与盘点见各级 `adapters/` 文档。

上游：[lemomo-ai/lemo-opuscar](https://github.com/lemomo-ai/lemo-opuscar)（MIT；样片 CC BY 4.0）。

## 兼容矩阵（只写实测，跑过才算数——验收标准见 `compat/BENCHMARK.md`）

| Harness | 模型 | 安装方式 | 状态 |
|---|---|---|---|
| Claude Code | Claude Opus | 上游插件市场 / clone | 上游官方版本 |
| Codex | GPT-5 系 Codex | clone（AGENTS.md 直用）/ `.agents/skills` | **已打包，基准片待测** |
| DeepSeek Harness（dsh） | DeepSeek V4 等 | clone 模式先行 | 待适配 |
| WorkBuddy（腾讯） | 平台模型 | SKILL.md zip 上传（fork Releases 下载） | **已打包，运行环境待实测** |

## 各平台入口

- Codex：[`adapters/CODEX.md`](adapters/CODEX.md)
- WorkBuddy：[`adapters/WORKBUDDY.md`](adapters/WORKBUDDY.md)（含 [`冒烟测试规程`](adapters/workbuddy/SMOKE-TEST.md)）
- DeepSeek Harness：待补（`adapters/DEEPSEEK-DSH.md`）

## 一份源，多处生成

Skill 只有一份源：`plugin/skills/lemo-opuscar/`。平台副本由脚本生成、不手改：

```bash
sh tools/sync-skill.sh   # 生成 .agents/skills/lemo-opuscar/（含 Codex 的 agents/openai.yaml）
```

同步上游后重跑一次该脚本即可。Skill 模式下拉库地址可用 `LEMO_OPUSCAR_REPO` 指向本 fork。

## 基准测试

所有「支持」声明以 `compat/BENCHMARK.md` 的统一测试片（蓝图风格，20–30 秒）实测结果为准，结果存 `compat/results/`。
