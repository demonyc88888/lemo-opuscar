# Lemo-Opuscar on WorkBuddy（腾讯）

这个 fork 的通用化适配之一：把 Lemo-Opuscar 装进腾讯 WorkBuddy。
WorkBuddy 的 Skill 与本仓库同为 SKILL.md 开放标准，官方支持「上传本地 zip 包安装技能，zip 内必须包含 SKILL.md」，所以内容层照样零改动；**这一版真正的未知数是运行环境**（见文末），状态如实标注：**已打包，待实测**。

## 安装

1. 从本 fork 的 [Releases](../../releases) 下载 zip（两个同内容、不同打包结构，任选其一，装不上就换另一个）：
   - `lemo-opuscar-workbuddy.zip`——SKILL.md 在 zip 根目录
   - `lemo-opuscar-workbuddy-folder.zip`——SKILL.md 在 `lemo-opuscar/` 文件夹内
2. 打开 WorkBuddy → 左侧 **专家·技能·连接器** → 技能模块 → 右上角 **添加技能** → **上传技能**，选择 zip，确认导入。
3. 导入后新建任务，点名技能再下指令，例如：

> 用 $lemo-opuscar 的技能，先别动手：告诉我你能不能在这个环境里运行 shell 命令、读写本地文件夹，并把 node、python3、ffmpeg 的版本号报给我。

## 先跑冒烟测试（重要）

完整拍片要求 Agent 能：跑 shell 装 Node 依赖与无头 Chromium、从 GitHub 拉风格库、下载约 350MB 的离线配音模型、连续渲染 30–60 分钟、把成片写回本地。WorkBuddy 的运行环境能不能扛这一整套，官方没有说明——**装完先按 [`workbuddy/SMOKE-TEST.md`](workbuddy/SMOKE-TEST.md) 的规程测一遍**，五关逐关记录结果，再决定用法：

- **五关全过** → 按完整流程用，与 Codex 版同一套指令（技能模式下让它先跑 `scripts/setup.sh`，并设 `LEMO_OPUSCAR_REPO=https://github.com/demonyc88888/lemo-opuscar.git` 让它拉这个 fork）。
- **卡在装依赖/长任务** → 降级为**轻量模式**：WorkBuddy 只做前期——选风格、写 TREATMENT 与分镜、生成风格帧讨论稿；真正的渲染回本地的 Claude Code / Codex 执行。轻量模式产出的 TREATMENT.md 可直接被另两个平台接手（都是同一份 AGENTS.md 流程）。
- **连 shell 都没有** → 这个平台只适合拿 SKILL.md 当风格咨询（问答选风格、写文案），不要指望它出片。

## 环境与费用

- WorkBuddy 的模型由平台提供（平台自有/合作模型），不是 Claude——风格是为 Claude Opus 调校的（上游 README 明示），成片质量以实测为准；基准测试片标准见 `compat/BENCHMARK.md`，跑完请把结果记入 `compat/results/`。
- WorkBuddy 有免费额度，超出后按平台规则计费（积分/会员长时任务档位），长渲染任务请先确认自己的档位够不够跑完一支片。

## 维护

技能包内容由 `tools/sync-skill.sh` 从唯一源 `plugin/skills/lemo-opuscar/` 生成到 `packages/workbuddy/lemo-opuscar/`（文件夹式），根目录式 zip 在发 Release 时直接对源目录打包。不要手改生成副本。
