## Scope / decision

- [ ] Current **DEC-033** MAN mirror RTS micro MVP (or explicitly named future milestone)
- [ ] No Tauri/Rust/Vite gameplay/runtime reintroduced; one Godot 4.7.2 project
- [ ] Current `main` and open related PRs read before modification

## Mandatory DEC-034: upstream reuse evidence

**Before new code I searched existing project, Godot API, GitHub/AssetLib:**

- Existing Scalfagus code inspected:
- Built-in Godot node/API and official docs:
- GitHub/AssetLib alternatives inspected, URLs, license and compatibility:
- Decision: `REUSE_EXISTING` / `WRAP_GODOT` / `WRAP_GITHUB` / `GAME_DOMAIN_CODE`
- Wrapper/port, authoritative-game-boundary impact and alternatives rejected:
- Pinned source commit, release, LICENSE/notice (if an addon was added):
- Rollback/disable plan:

## Verification evidence

- [ ] `bash scripts/check.sh` run on Godot 4.7.2 (or **NOT RUN** with blocker)
- [ ] Added relevant headless commands/tests + actual outputs
- [ ] Manual RTS camera/selection/navigation screenshot/video test (or **NOT RUN**)
- [ ] For runtime addon: macOS, Windows, Linux and Web compatibility tested/documented (or specifically deferred)
- [ ] Human and bot orders use same validated game command path
- [ ] No resource duplication, hidden-map leakage, unauthorized actions or new client authority
- [ ] Update relevant architecture registry and source/licensing metadata

### Exact test commands/results and outstanding blockers

```
# No unverifiable PASS declarations: include log links or paste exact failure/status.
```
