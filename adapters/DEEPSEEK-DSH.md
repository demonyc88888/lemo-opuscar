# Lemo-Opuscar on DeepSeek Harness（dsh）

这个 fork 的通用化适配之一：让 Lemo-Opuscar 跑在 DeepSeek 官方开源 Agent 框架 DSH 上。
适配依据是 2026-10-20 对官方文档的实测（npm `@deepseek-ai/dsh` 0.2.1-rc.2，MIT；仓库 deepseek-ai/deepseek-harness）：

- dsh **原生读取仓库 AGENTS.md**（`dsh-agent-instructions` 会在 agent 的 cwd 下发现 AGENTS.md 风格指令文件）——上游的 AGENTS.md 是这套技能真正的大脑，clone 模式零改动即用。
- dsh 的本地 skill 发现是 6 级 rank，其中第 1 级是项目 `<git 根>/.dsh/skills`，第 2 级是 `<git 根>/.agents/skills`——**Codex 版的副本它也扫得到**，所以本 fork 只用生成脚本多补一个 rank 最高的 `.dsh/skills` 副本即可。

## 安装 dsh（一次性）

```bash
npm i @deepseek-ai/dsh
npx @deepseek-ai/dsh web   # Web UI，默认 http://127.0.0.1:3080
```

在 Web UI 里配模型：DeepSeek 官方 API（密钥卡片）或第三方 provider（anthropic / openai / moonshotai / zai / openai-codex），凭据存于 `$DSH_HOME/.credentials.yaml`。国内用户图便宜走 DeepSeek 模型是这条路线的核心价值。

## 用法一：clone 模式（最简单）

```bash
git clone https://github.com/demonyc88888/lemo-opuscar.git
cd lemo-opuscar
dsh --profile <你的profile> "用蓝图（Blueprint）风格给我做一支 30 秒短片，讲我们院的装配式景墙节点，中文旁白"
```

AGENTS.md 自动生效；完整流程（TREATMENT → 风格帧 → 成片 → DIRECTOR.md §11 自检）与上游一致。

## 用法二：skill 模式（任意目录可用）

skill 已随仓库生成在两处发现路径（都由 `tools/sync-skill.sh` 从 `plugin/skills/` 单一源头生成）：

- `.dsh/skills/lemo-opuscar/`（rank 100，项目级最高优先级）
- `.agents/skills/lemo-opuscar/`（rank 200，与 Codex 共用；里面的 `agents/openai.yaml` 是 Codex 专属，dsh 只读 SKILL.md，不影响）

把任一目录拷到用户级发现路径即可全项目使用：`<dshHome>/skills` 或 `<agentsHome>/skills`（rank 400/500）。skill 模式下 setup.sh 会拉风格库到 `~/lemo-opuscar`，先设：

```bash
export LEMO_OPUSCAR_REPO=https://github.com/demonyc88888/lemo-opuscar.git
```

## 环境要求（与上游一致）

Node 20+、ffmpeg、Python 3.11+；首次 `setup.sh deps` 装 Node 依赖与 Playwright 无头 Chromium；离线 Kokoro 配音约 350MB 模型（或在线 edge-tts 中文）。一支片 30–60 分钟 Agent 工时 + 相当量 Token——dsh 配 DeepSeek 模型时这是三条路线里成本最低的。

## 已知限制（实测前不夸大）

- dsh 本身是 **0.2.x 开发者预览版**（官方未承诺会话格式向后兼容）；`engines.dsh` 约束语义是 `>=0.2.0 <0.3.0`，升级大版本可能要重新验证。
- 风格为 Claude Opus 调校（上游 README 明示）。DeepSeek 模型在审美自检与长程任务纪律上的表现**未验证**，这是本路线最大的问号——先按 `compat/BENCHMARK.md` 跑蓝图基准片定级再推广，验收标准与 Codex 版同一份。
- SKILL.md 的 frontmatter 未加 dsh 专有键（缺省 `disable-model-invocation` / `user-invocable` 均为 true，模型与用户均可调用），保持一份源多处通用。

## 维护

上游同步后跑一遍 `sh tools/sync-skill.sh` 即可（三份副本一起再生）。Cordis bundle（npm 包形式）发布是后续可选方向：需要真机验证 patch schema 再做，不在此版范围。
