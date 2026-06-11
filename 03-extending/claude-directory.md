> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# .claude 디렉토리 탐색

> Claude Code가 CLAUDE.md, settings.json, hooks, skills, commands, subagents, workflows, rules, auto memory를 읽는 위치입니다. 프로젝트의 .claude 디렉토리와 홈 디렉토리의 ~/.claude를 탐색합니다.

Claude Code는 프로젝트 디렉토리와 홈 디렉토리의 `~/.claude`에서 지침, 설정, skills, subagents, 메모리를 읽습니다. 프로젝트 파일을 git에 커밋하여 팀과 공유합니다. `~/.claude`의 파일은 모든 프로젝트에 적용되는 개인 설정입니다.

Windows에서 `~/.claude`는 `%USERPROFILE%\.claude`로 확인됩니다. [`CLAUDE_CONFIG_DIR`](/ko/env-vars)을 설정하면, 이 페이지의 모든 `~/.claude` 경로가 대신 해당 디렉토리 아래에 있습니다.

대부분의 사용자는 `CLAUDE.md`와 `settings.json`만 편집합니다. 디렉토리의 나머지는 선택 사항입니다. 필요에 따라 skills, rules, subagents를 추가합니다.

<h2 id="explore-the-directory">
  디렉토리 탐색
</h2>

트리의 파일을 클릭하여 각 파일이 무엇을 하는지, 언제 로드되는지, 예제를 확인합니다.

<h2 id="what-s-not-shown">
  표시되지 않는 항목
</h2>

탐색기는 작성하고 편집하는 파일을 다룹니다. 관련된 몇 가지 파일은 다른 위치에 있습니다.

| 파일                      | 위치                  | 목적                                                                                                                                                                                 |
| ----------------------- | ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `managed-settings.json` | 시스템 수준, OS에 따라 다름   | 재정의할 수 없는 엔터프라이즈 강제 설정입니다. [서버 관리 설정](/ko/server-managed-settings)을 참조하세요.                                                                                                         |
| `CLAUDE.local.md`       | 프로젝트 루트             | 이 프로젝트에 대한 개인 기본 설정으로, CLAUDE.md와 함께 로드됩니다. 수동으로 생성하고 `.gitignore`에 추가합니다.                                                                                                         |
| 설치된 플러그인                | `~/.claude/plugins` | 복제된 마켓플레이스, 설치된 플러그인 버전, 플러그인별 데이터로, `claude plugin` 명령으로 관리됩니다. 고아 버전은 플러그인 업데이트 또는 제거 후 7일 후에 삭제됩니다. [플러그인 캐싱](/ko/plugins-reference#plugin-caching-and-file-resolution)을 참조하세요. |

`~/.claude`는 또한 작업할 때 Claude Code가 작성하는 데이터를 보유합니다. 트랜스크립트, 프롬프트 기록, 파일 스냅샷, 캐시, 로그입니다. 아래의 [애플리케이션 데이터](#application-data)를 참조하세요.

<h2 id="choose-the-right-file">
  올바른 파일 선택
</h2>

다양한 종류의 사용자 정의는 다양한 파일에 있습니다. 이 표를 사용하여 변경 사항이 어디에 속하는지 찾습니다.

| 원하는 작업                       | 편집                                       | 범위         | 참조                                        |
| :--------------------------- | :--------------------------------------- | :--------- | :---------------------------------------- |
| Claude에 프로젝트 컨텍스트 및 규칙 제공    | `CLAUDE.md`                              | 프로젝트 또는 전역 | [메모리](/ko/memory)                         |
| 특정 도구 호출 허용 또는 차단            | `settings.json` `permissions` 또는 `hooks` | 프로젝트 또는 전역 | [권한](/ko/permissions), [Hooks](/ko/hooks) |
| 도구 호출 전후에 스크립트 실행            | `settings.json` `hooks`                  | 프로젝트 또는 전역 | [Hooks](/ko/hooks)                        |
| 세션에 대한 환경 변수 설정              | `settings.json` `env`                    | 프로젝트 또는 전역 | [설정](/ko/settings#available-settings)     |
| 개인 재정의를 git에서 제외             | `settings.local.json`                    | 프로젝트만      | [설정 범위](/ko/settings#settings-files)      |
| `/name`으로 호출하는 프롬프트 또는 기능 추가 | `skills/<name>/SKILL.md`                 | 프로젝트 또는 전역 | [Skills](/ko/skills)                      |
| 자신의 도구가 있는 특화된 subagent 정의   | `agents/*.md`                            | 프로젝트 또는 전역 | [Subagents](/ko/sub-agents)               |
| 스크립트에서 많은 subagent 조율        | `workflows/*.js`                         | 프로젝트 또는 전역 | [동적 워크플로우](/ko/workflows)                 |
| MCP를 통해 외부 도구 연결             | `.mcp.json`                              | 프로젝트만      | [MCP](/ko/mcp)                            |
| Claude가 응답을 포맷하는 방식 변경       | `output-styles/*.md`                     | 프로젝트 또는 전역 | [출력 스타일](/ko/output-styles)               |

<h2 id="file-reference">
  파일 참조
</h2>

이 표는 탐색기가 다루는 모든 파일을 나열합니다. 프로젝트 범위 파일은 `.claude/` 아래의 리포지토리에 있습니다 (또는 `CLAUDE.md`, `.mcp.json`, `.worktreeinclude`의 경우 루트에 있음). 전역 범위 파일은 `~/.claude/`에 있으며 모든 프로젝트에 적용됩니다.

<Note>
  이 파일에 입력한 내용을 재정의할 수 있는 여러 가지가 있습니다.

  * 조직에서 배포한 [관리 설정](/ko/server-managed-settings)이 모든 것보다 우선합니다.
  * `--permission-mode` 또는 `--settings`와 같은 CLI 플래그는 해당 세션에 대해 `settings.json`을 재정의합니다.
  * 일부 환경 변수는 동등한 설정보다 우선하지만, 이는 다양합니다. 각각에 대해 [환경 변수 참조](/ko/env-vars)를 확인하세요.

  전체 순서는 [설정 우선순위](/ko/settings#settings-precedence)를 참조하세요.
</Note>

파일 이름을 클릭하여 위의 탐색기에서 해당 노드를 엽니다.

| 파일                                                  | 범위        | 커밋 | 기능                                                                      | 참조                                                              |
| --------------------------------------------------- | --------- | -- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| [`CLAUDE.md`](#ce-claude-md)                        | 프로젝트 및 전역 | ✓  | 매 세션마다 로드되는 지침                                                          | [메모리](/ko/memory)                                               |
| [`rules/*.md`](#ce-rules)                           | 프로젝트 및 전역 | ✓  | 주제 범위 지침, 선택적으로 경로 제한                                                   | [규칙](/ko/memory#organize-rules-with-claude/rules/)              |
| [`settings.json`](#ce-settings-json)                | 프로젝트 및 전역 | ✓  | 권한, hooks, 환경 변수, 모델 기본값                                                | [설정](/ko/settings)                                              |
| [`settings.local.json`](#ce-settings-local-json)    | 프로젝트만     |    | 개인 재정의, 자동 gitignored                                                   | [설정 범위](/ko/settings#settings-files)                            |
| [`.mcp.json`](#ce-mcp-json)                         | 프로젝트만     | ✓  | 팀 공유 MCP 서버                                                             | [MCP 범위](/ko/mcp#mcp-installation-scopes)                       |
| [`.worktreeinclude`](#ce-worktreeinclude)           | 프로젝트만     | ✓  | 새 worktrees로 복사할 Gitignored 파일                                          | [Worktrees](/ko/worktrees#copy-gitignored-files-into-worktrees) |
| [`skills/<name>/SKILL.md`](#ce-skills)              | 프로젝트 및 전역 | ✓  | `/name`으로 호출되거나 자동 호출되는 재사용 가능한 프롬프트                                    | [Skills](/ko/skills)                                            |
| [`commands/*.md`](#ce-commands)                     | 프로젝트 및 전역 | ✓  | 단일 파일 프롬프트; skills와 동일한 메커니즘                                            | [Skills](/ko/skills)                                            |
| [`output-styles/*.md`](#ce-output-styles)           | 프로젝트 및 전역 | ✓  | 사용자 정의 시스템 프롬프트 섹션                                                      | [출력 스타일](/ko/output-styles)                                     |
| [`agents/*.md`](#ce-agents)                         | 프로젝트 및 전역 | ✓  | 자신의 프롬프트와 도구가 있는 subagent 정의                                            | [Subagents](/ko/sub-agents)                                     |
| [`workflows/*.js`](#ce-workflows)                   | 프로젝트 및 전역 | ✓  | Claude가 작성하고 `/workflows`에서 저장한 동적 워크플로우 스크립트; 각 파일은 `/<name>` 명령어가 됩니다 | [동적 워크플로우](/ko/workflows)                                       |
| [`agent-memory/<name>/`](#ce-agent-memory)          | 프로젝트 및 전역 | ✓  | Subagents의 지속적 메모리                                                      | [지속적 메모리](/ko/sub-agents#enable-persistent-memory)              |
| [`~/.claude.json`](#ce-claude-json)                 | 전역만       |    | 앱 상태, OAuth, UI 토글, 개인 MCP 서버                                           | [전역 설정](/ko/settings#global-config-settings)                    |
| [`projects/<project>/memory/`](#ce-global-projects) | 전역만       |    | 자동 메모리: Claude의 세션 간 자체 메모                                              | [자동 메모리](/ko/memory#auto-memory)                                |
| [`keybindings.json`](#ce-keybindings)               | 전역만       |    | 사용자 정의 키보드 단축키                                                          | [키바인딩](/ko/keybindings)                                         |
| [`themes/*.json`](#ce-themes)                       | 전역만       |    | 사용자 정의 색상 테마                                                            | [사용자 정의 테마](/ko/terminal-config#create-a-custom-theme)          |

<h2 id="troubleshoot-configuration">
  설정 문제 해결
</h2>

설정, hook, 파일이 적용되지 않으면, [설정 디버그](/ko/debug-your-config)에서 검사 명령과 증상 우선 조회 표를 참조하세요.

<h2 id="application-data">
  애플리케이션 데이터
</h2>

작성하는 설정 외에도 `~/.claude`는 세션 중에 Claude Code가 작성하는 데이터를 보유합니다. 이 파일은 일반 텍스트입니다. 도구를 통과하는 모든 항목은 디스크의 트랜스크립트에 저장됩니다: 파일 내용, 명령 출력, 붙여넣은 텍스트입니다.

<h3 id="cleaned-up-automatically">
  자동으로 정리됨
</h3>

아래 경로의 파일은 [`cleanupPeriodDays`](/ko/settings#available-settings)보다 오래되면 시작 시 삭제됩니다. 기본값은 30일입니다.

| `~/.claude/` 아래 경로                           | 내용                                                                                    |
| -------------------------------------------- | ------------------------------------------------------------------------------------- |
| `projects/<project>/<session>.jsonl`         | 전체 대화 트랜스크립트: 모든 메시지, 도구 호출, 도구 결과                                                    |
| `projects/<project>/<session>/subagents/`    | [Subagent](/ko/sub-agents) 대화 트랜스크립트로, 상위 세션 트랜스크립트가 만료될 때 함께 제거됨                     |
| `projects/<project>/<session>/tool-results/` | 별도 파일로 유출된 대형 도구 출력                                                                   |
| `file-history/<session>/`                    | Claude가 변경한 파일의 편집 전 스냅샷으로, [checkpoint 복원](/ko/checkpointing)에 사용됨                   |
| `plans/`                                     | [plan mode](/ko/permission-modes#analyze-before-you-edit-with-plan-mode) 중에 작성된 계획 파일 |
| `debug/`                                     | 세션별 디버그 로그로, `--debug`로 시작하거나 `/debug`를 실행할 때만 작성됨                                    |
| `paste-cache/`, `image-cache/`               | 대형 붙여넣기 및 첨부 이미지의 내용                                                                  |
| `session-env/`                               | 세션별 환경 메타데이터                                                                          |
| `tasks/`                                     | 작업 도구로 작성된 세션별 작업 목록                                                                  |
| `shell-snapshots/`                           | Bash 도구에서 사용하는 캡처된 셸 환경입니다. 정상 종료 시 제거됩니다. 스윕은 충돌 후 남겨진 항목을 정리합니다.                    |
| `backups/`                                   | 설정 마이그레이션 전에 `~/.claude.json`의 타임스탬프 복사본                                              |
| `feedback-bundles/`                          | 제3자 공급자에서 `/feedback`으로 작성된 수정된 트랜스크립트 아카이브로, Anthropic 계정 팀에 전송하기 위함                 |
| `todos/`, `statsig/`, `logs/`                | 이전 버전의 레거시 디렉토리입니다. 더 이상 작성되지 않습니다. 스윕은 내용을 제거한 후 빈 디렉토리를 제거합니다.                      |

<h3 id="kept-until-you-delete-them">
  삭제할 때까지 유지됨
</h3>

다음 경로는 자동 정리 대상이 아니며 무기한 지속됩니다.

| `~/.claude/` 아래 경로     | 내용                                                                                           |
| ---------------------- | -------------------------------------------------------------------------------------------- |
| `history.jsonl`        | 입력한 모든 프롬프트로, 타임스탬프 및 프로젝트 경로 포함. 위쪽 화살표 회상에 사용됨.                                            |
| `stats-cache.json`     | `/usage`로 표시된 집계 토큰 및 비용 계산                                                                  |
| `remote-settings.json` | 조직의 [서버 관리 설정](/ko/server-managed-settings)의 캐시된 복사본입니다. 조직이 설정한 경우에만 존재합니다. 각 시작 시 새로고침됩니다. |

기타 작은 캐시 및 잠금 파일은 사용하는 기능에 따라 나타나며 안전하게 삭제할 수 있습니다.

<h3 id="plaintext-storage">
  일반 텍스트 저장소
</h3>

트랜스크립트 및 기록은 저장 시 암호화되지 않습니다. OS 파일 권한이 유일한 보호입니다. 도구가 `.env` 파일을 읽거나 명령이 자격 증명을 인쇄하면, 해당 값이 `projects/<project>/<session>.jsonl`에 작성됩니다. 노출을 줄이려면:

* `cleanupPeriodDays`를 낮춰 트랜스크립트를 유지하는 기간을 단축합니다.
* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](/ko/env-vars) 환경 변수를 설정하여 모든 모드에서 트랜스크립트 및 프롬프트 기록 작성을 건너뜁니다. 비대화형 모드에서는 대신 `-p`와 함께 `--no-session-persistence`를 전달하거나 Agent SDK에서 `persistSession: false`를 설정할 수 있습니다.
* [권한 규칙](/ko/permissions)을 사용하여 자격 증명 파일의 읽기를 거부합니다.

<h3 id="clear-local-data">
  로컬 데이터 지우기
</h3>

`claude project purge`를 실행하여 한 프로젝트에 대해 Claude Code가 보유한 상태를 삭제합니다. 이 명령은 Claude Code v2.1.124 이상이 필요합니다. 다음을 삭제합니다:

* `projects/` 아래의 트랜스크립트 및 자동 메모리
* 세션별 `tasks/`, `debug/`, `file-history/` 항목
* `history.jsonl`의 일치하는 프롬프트 라인
* `~/.claude.json`의 프로젝트 항목

이 명령은 전체 삭제 계획을 인쇄하고 항목을 제거하기 전에 확인을 요청합니다.

삭제하지 않고 계획을 미리 봅니다:

```bash theme={null}
claude project purge ~/work/my-repo --dry-run
```

단일 확인 프롬프트로 삭제합니다:

```bash theme={null}
claude project purge ~/work/my-repo
```

경로를 생략하여 대화형 목록에서 프로젝트를 선택합니다.

스크립트에서 사용하기 위해 확인 프롬프트를 건너뜁니다:

```bash theme={null}
claude project purge ~/work/my-repo --yes
```

경로 대신 `--all`을 전달하여 한 번에 모든 프로젝트의 상태를 제거합니다. 이는 `history.jsonl`을 필터링하지 않고 완전히 삭제합니다. `-i`를 전달하여 삭제 계획을 한 번에 하나씩 단계별로 진행합니다.

이 명령은 프로젝트 범위가 아니므로 `shell-snapshots/` 및 `backups/`는 그대로 두고 계획 출력에서 이에 대해 경고합니다. 주어진 경로와 일치하는 상태가 없으면 상태 1로 종료됩니다.

위의 애플리케이션 데이터 경로를 언제든지 손으로 삭제할 수 있습니다. 새 세션은 영향을 받지 않습니다. 아래 표는 과거 세션에서 손실되는 항목을 보여줍니다.

| 삭제                                                                                                                                                                                           | 손실 항목                         |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `~/.claude/projects/`                                                                                                                                                                        | 과거 세션의 재개, 계속, 되감기            |
| `~/.claude/history.jsonl`                                                                                                                                                                    | 위쪽 화살표 프롬프트 회상                |
| `~/.claude/file-history/`                                                                                                                                                                    | 과거 세션의 checkpoint 복원          |
| `~/.claude/stats-cache.json`                                                                                                                                                                 | `/usage`로 표시된 과거 합계           |
| `~/.claude/remote-settings.json`                                                                                                                                                             | 없음. 다음 시작 시 다시 가져옵니다.         |
| `~/.claude/debug/`, `~/.claude/plans/`, `~/.claude/paste-cache/`, `~/.claude/image-cache/`, `~/.claude/session-env/`, `~/.claude/tasks/`, `~/.claude/shell-snapshots/`, `~/.claude/backups/` | 사용자 대면 항목 없음                  |
| `~/.claude/todos/`, `~/.claude/statsig/`, `~/.claude/logs/`                                                                                                                                  | 없음. 현재 버전에서 작성되지 않는 레거시 디렉토리. |

`~/.claude.json`, `~/.claude/settings.json`, `~/.claude/plugins/`를 삭제하지 마세요. 이들은 인증, 기본 설정, 설치된 플러그인을 보유합니다.

<h2 id="related-resources">
  관련 리소스
</h2>

* [Claude의 메모리 관리](/ko/memory): CLAUDE.md, rules, auto memory 작성 및 구성
* [설정 구성](/ko/settings): 권한, hooks, 환경 변수, 모델 기본값 설정
* [Skills 생성](/ko/skills): 재사용 가능한 프롬프트 및 워크플로우 구축
* [Subagents 구성](/ko/sub-agents): 자신의 컨텍스트가 있는 특화된 에이전트 정의
