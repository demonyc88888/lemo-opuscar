# Lemo-Opuscar on Codex（OpenAI）

这个 fork 的通用化适配之一：让 Lemo-Opuscar 在 Codex 里能装、能跑。
上游的 `styles/`、`core/` 与三份指南（`AGENTS.md` / `DIRECTOR.md` / `TECHNIQUE.md`）一行未改——Codex 原生读 `AGENTS.md`，SKILL.md 又是开放标准，所以 Codex 版只需要「把 skill 放到 Codex 扫得到的地方」。

## 为什么 Codex 几乎不用改

| 上游资产 | Codex 的对应机制 |
|---|---|
| 根目录 `AGENTS.md`（真正的 Agent 指令，上游 `CLAUDE.md` 也只是转发它） | Codex 原生读取仓库与目录链上的 `AGENTS.md` |
| `plugin/skills/lemo-opuscar/SKILL.md`（name/description 前言 + Markdown 正文） | Agent Skills 开放标准，Codex 同格式读取 |
| `scripts/setup.sh`（POSIX shell，git 稀疏克隆 + Node/Python 依赖） | 任何能跑 shell 的 Agent 都能执行；`LEMO_OPUSCAR_REPO` 变量可把库指向这个 fork |

## 安装方式一：clone 模式（最简单，先用这个验证）

```bash
git clone https://github.com/demonyc88888/lemo-opuscar.git
cd lemo-opuscar
codex   # 在仓库目录里启动 Codex，AGENTS.md 自动生效
```

然后直接说人话，例如：

> 用蓝图（Blueprint）风格给我做一支 30 秒的短片，讲我们院的装配式景墙节点，中文旁白，先给我看分镜。

成片项目会建在 `films/<name>/` 下，上游规则不变。

## 安装方式二：Skill 模式（任意目录可用）

Codex 扫描两处 skill：仓库级 `.agents/skills/` 与用户级 `~/.agents/skills/`。

- **跟随这个 fork 工作**：`.agents/skills/lemo-opuscar/` 已随仓库提供（由 `tools/sync-skill.sh` 从 `plugin/skills/` 生成），clone 后在仓库内即可用 `$lemo-opuscar` 显式调用，或让 Codex 按 description 自动匹配。
- **装到用户级（所有项目可用）**：

```bash
mkdir -p ~/.agents/skills
cp -R .agents/skills/lemo-opuscar ~/.agents/skills/
# 若 Codex 已在运行，重启一次让它重新扫描
```

Skill 模式下 setup.sh 会把风格库拉到 `~/lemo-opuscar`；想让它拉这个 fork 而不是上游，先设变量：

```bash
export LEMO_OPUSCAR_REPO=https://github.com/demonyc88888/lemo-opuscar.git
```

## 环境要求（与上游一致）

- Node 20+、ffmpeg、Python 3.11+（或 uv）；首次 `setup.sh deps` 会装 Node 依赖与 Playwright 的无头 Chromium，需要几分钟和网络。
- 配音分两档：离线 Kokoro（约 350MB 模型，带中文音色）或在线 edge-tts 中文音色（`core/tts/tts_zh.py`）；按上游 TECHNIQUE.md 的分档规则装，不要一上来全装。
- 一支片约 30–60 分钟 Agent 工时 + 相当量 Token（Codex 走 ChatGPT 订阅额度或 API 计量）。

## 已知限制（实测前不夸大）

- 风格是为 Claude Opus 调校的（上游 README 明示）。Codex 的模型在长程任务与审美自检上表现如何，**以 `compat/BENCHMARK.md` 的基准测试片实测为准**，本页不预先承诺成片质量等同 Claude 版。
- Codex 的 skill 附加元数据走 `agents/openai.yaml` sidecar（本仓库由 `adapters/codex/openai.yaml` 生成）；上游 SKILL.md 正文未做任何 Codex 私有改写，保证一份源多处通用。
- Windows 用户注意：setup.sh 是 POSIX shell，需在 Git Bash / WSL 里跑；生成文件中的符号链接不被使用（sync 脚本用真实拷贝，就是为了照顾 Windows）。

## 维护

上游更新后在本 fork 同步（Sync fork 或 `git fetch upstream && git merge upstream/main`），然后跑一遍：

```bash
sh tools/sync-skill.sh   # 从 plugin/skills 重新生成 .agents/skills 副本
```

改 skill 只改 `plugin/skills/lemo-opuscar/` 这一份源，不要直接改 `.agents/skills/` 里的生成副本。
