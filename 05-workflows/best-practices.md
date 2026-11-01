> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code 모범 사례

> Claude Code를 더 효과적으로 활용하는 방법: Claude가 볼 수 없는 정보를 알려 주고, 실행할 확인 수단을 제공하고, 예외가 있어서는 안 되는 규칙을 강제합니다.

Claude Code는 대부분의 경우 새 세션에서 입력한 첫 번째 평범한 프롬프트만으로도 별도의 설정 없이 올바르게 작동하도록 만들어졌습니다.

예를 들면 다음과 같습니다.

* 명령을 하나하나 승인하지 않아도 안전하게 실행되도록, 새 터미널 및 VS Code 세션은 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서 시작되며, 위험한 작업은 실행 전에 분류기가 검토합니다.
* 독립적인 작업이 병렬로 진행되는 동안 메인 대화가 집중된 상태를 유지하도록, Claude는 서브에이전트에 작업을 위임하고 꼭 필요할 때만 확인을 요청합니다.
* 사용자가 직접 관리하지 않아도 긴 세션을 계속 이어갈 수 있도록, 컨텍스트 윈도우가 가득 차기 전에 대화가 자동으로 압축됩니다.

이 페이지에서는 기본값만으로 충분하지 않을 때 해야 할 일을 다룹니다. 이는 보통 프로젝트에 Claude가 코드만으로는 알 수 없는 지식, 규칙, 제약 조건이 있을 때 발생합니다.

* 누군가의 머릿속에만 있는 배포 프로세스
* 절대 읽어서는 안 되는 파일
* 어떤 작업이든 완료로 인정되기 전에 반드시 통과해야 하는 검사
* 넘지 말아야 하는 예산

어떤 기본값도 프로젝트에 관한 이런 사항을 알 수 없으므로, 바로 이 지점에서 약간의 설정이 큰 효과를 발휘합니다.

세션이 예상대로 진행되지 않을 때는 거의 항상 다음 중 하나에 해당합니다.

* Claude가 의도와 다른 것을 만들었거나, 매 세션 시작마다 같은 사실을 다시 찾아내야 합니다. 저장소를 읽어서는 얻을 수 없는 정보가 부족한 것입니다. [Claude가 볼 수 없는 것 알려 주기](#tell-claude-what-it-cant-see)를 참조하십시오.
* Claude가 완료했다고 했지만 실제로는 완전히 끝나지 않았습니다. 대개 자신의 작업을 확인할 방법이 없었기 때문입니다. [Claude에게 실행할 확인 수단 제공하기](#give-claude-a-check-to-run)를 참조하십시오.
* Claude가 이 저장소에서 절대 일어나서는 안 되는 일을 했거나, 반드시 거쳐야 하는 단계를 건너뛰었습니다. 프롬프트만으로는 어느 쪽도 보장할 수 없습니다. [예외가 있어서는 안 되는 규칙 강제하기](#enforce-the-rules-that-cant-have-exceptions)를 참조하십시오.
* Claude가 올바르게 처리했지만, 작업의 가치에 비해 너무 많은 시간, 토큰, 권한 프롬프트가 들었습니다. [기본값 변경하기](#change-a-default)를 참조하십시오.

[사용자 없이 Claude 실행하기](#let-claude-run-without-you)에서는 같은 네 가지 사항을 무인 실행에 적용하며, [더 이상 하지 않아도 되는 것](#what-you-can-stop-doing)에서는 최신 모델 덕분에 불필요해진 조언을 정리합니다.

> [!NOTE]
>
> 팀 전체를 위한 설정은 별도 페이지에서 다룹니다: [조직을 위한 Claude Code 설정](https://code.claude.com/docs/ko/admin-setup.md).

## 결정론적 지시와 비결정론적 지시

Claude Code에 제공하는 모든 지시는 다음 중 하나입니다.

1. 비결정론적: 지시를 작성하면 Claude(모델)가 이를 읽습니다. 프롬프트, `CLAUDE.md`, 스킬이 여기에 해당합니다. 그런 다음 모델이 이 정보로 무엇을 할지 결정합니다. 모델은 대개 명령을 따르며, 최신 모델은 많은 컨텍스트 없이도 의도를 잘 파악하지만, 지시를 따른다는 *보장*은 없습니다. 여전히 어떤 일을 하지 않기로 하거나 다른 일을 할 수 있습니다.
2. 결정론적: 지시를 구성하면 Claude Code(하네스)가 이를 *반드시* 실행합니다. 훅, 거부 규칙, 관리형 설정이 여기에 해당합니다. Claude Code는 모델이 무엇을 하기로 결정했든 관계없이 매번 이를 적용합니다.

Claude Code의 대부분의 기능은 두 가지 형태로 모두 제공됩니다.

| | 비결정론적 (Claude가 결정) | 결정론적 (Claude Code가 강제) |
| :- | :- | :- |
| 무엇을 할지 | 프롬프트, `CLAUDE.md`, Claude가 스스로 사용하는 스킬 | 훅, 그리고 사용자만 시작할 수 있는 스킬 |
| 무엇에 접근할 수 있는지 | 자동 모드의 분류기 | 거부 규칙, [strict 모드](https://code.claude.com/docs/ko/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)의 샌드박스, 관리형 설정 |
| 언제 완료되는지 | 증거 요청, `/goal`, `/code-review` | 테스트, 타입 검사, `Stop` 훅, CI |
| 얼마나 소비하는지 | effort 수준, Claude 자체의 작업 속도 | `-p`와 함께 쓰는 `--max-turns` 또는 [`--max-budget-usd`](https://code.claude.com/docs/ko/cli-reference), 직접 설정한 [지출 한도](https://code.claude.com/docs/ko/costs.md) |
| 최종 결정권은 누구에게 있는지 | Claude가 수행한 작업에 대한 요약 | 브랜치 보호, 병합을 승인하는 사람 |

대부분의 경우에는 Claude가 결정하도록 하는 것이 좋습니다. 거의 모든 지침에는 예외가 있으며, 최신 모델은 눈앞의 코드를 읽고 지침이 상황에 맞는지 판단하는 데 능숙합니다. 실제 코드를 보고 있는 Claude가 미리 작성해 둔 규칙보다 대개 더 나은 판단을 내릴 수 있습니다.

결정론적 방식은 모델이 무엇을 결정하든 특정 일이 *항상* 일어나도록(또는 절대 일어나지 않도록) 보장하고 싶을 때 사용합니다. 대단한 일일 필요는 없습니다. 자동 모드는 이미 프로덕션 배포나 다른 사람의 작업을 덮어쓰는 force push 같은 [심각한 작업을 차단합니다](https://code.claude.com/docs/ko/permission-modes.md#what-the-classifier-blocks-by-default). 대개는 *해당* 프로젝트에 특화된 것이며, 원하는 만큼 세부적일 수 있습니다.

* `src/gen/`의 생성된 클라이언트는 절대 편집하지 않기
* 파일을 생성한 후에는 항상 라이선스 헤더 스크립트 실행하기

둘 중 어느 것이든 `CLAUDE.md`나 프롬프트에 한 줄로 적을 수 있었고, Claude는 거의 매번 이를 따랐을 것입니다. 하지만 아무리 강하게 표현하더라도, 특정 턴에서 Claude가 그 줄을 따를지는 여전히 Claude의 판단에 달려 있습니다.

> [!TIP]
>
> `CLAUDE.md`의 어떤 줄에 계속 강조를 추가하는데도 Claude가 여전히 놓친다면, 그 줄은 훅으로 옮겨야 한다는 신호입니다. 반대도 마찬가지입니다. 단순한 선호 사항에 대한 훅이 있다면 삭제하고 Claude가 결정하도록 하십시오.

## Claude가 볼 수 없는 것 알려 주기

> [!TIP]
>
> Claude가 저장소를 읽어서 찾을 수 없는 것, 또는 그렇지 않으면 매 세션마다 다시 찾아내는 데 시간을 써야 하는 것만 적어 두십시오.

Claude는 모든 작업을 코드를 읽는 것으로 시작하며, 최신 모델은 이 일에 *매우* 능숙합니다. 파일 구조, 규칙, 테스트 프레임워크, 기존 컴포넌트의 구성 방식을 찾아내며, 대개 사용자가 설명하는 것보다 더 빠릅니다. 즉, Claude를 위해 적어 두고 싶은 내용 대부분을 Claude는 이미 알고 있습니다.

Claude가 찾을 수 없는 것은 애초에 저장소에 없었던 정보입니다.

* 팀이 회의에서 내린 결정
* 한 사람의 머릿속에만 있는 배포 프로세스
* 통합 테스트에 필요한 환경 변수

저장소에 *있기는* 하지만 찾으려면 몇 분간 파고들어야 하는 정보도 있으며, Claude는 매 세션 시작마다 그 작업을 다시 해야 합니다.

Claude를 위해 무언가를 적기 전에 해 볼 만한 좋은 테스트가 있습니다.

1. 코드를 읽어서 이것을 찾을 수 있는가?
2. 실제로 찾아보러 갈 것인가?

둘 다 '예'라면 적지 마십시오.

### 구체적인 프롬프트 작성하기

구체적인 프롬프트가 도움이 되는 것도 같은 이유입니다. Claude가 아직 갖고 있지 않은 정보를 제공하기 때문입니다. 파일 이름을 지정하고, 증상을 설명하고, "수정됨"이 어떤 모습인지 처음부터 밝히면 대개 나중에 한 차례의 수정을 줄일 수 있습니다.

두 가지 합리적인 접근 방식 사이의 선호도도 마찬가지입니다. Claude는 코드에서 이를 읽어 낼 수 없으므로, 어느 쪽을 택할지 중요하다면 처음부터 말하십시오.

| 이렇게 하는 대신 | 이렇게 해 보십시오 |
| :- | :- |
| *"로그인 버그 수정해 줘"* | *"사용자들이 세션 시간 초과 후 로그인이 실패한다고 보고했어. src/auth/의 토큰 새로 고침을 살펴보고, 문제를 재현하는 실패하는 테스트를 작성한 다음 수정해 줘"* |
| *"캘린더 위젯 추가해 줘"* | *"HotDogWidget.php의 패턴을 따라서 월을 선택하고 연도 간에 페이지를 넘길 수 있는 캘린더 위젯을 만들어 줘. 새 라이브러리는 쓰지 마"* |

Claude에게 필요한 것을 이미 가지고 있다면, 설명하는 대신 직접 넘겨주십시오.

* 파일: `@`와 경로를 입력하여 메시지에 [파일 내용을 포함](https://code.claude.com/docs/ko/common-workflows.md#reference-files-and-directories)합니다.
* 이미지: 디자인이나 오류의 스크린샷을 프롬프트에 붙여 넣습니다.
* 명령 출력: 셸에서 `cat error.log | claude -p "what's going on here"`로 파이프합니다.

`think step by step`나 `be thorough` 같은 문구는 키워드가 아니라 일반적인 프롬프트 텍스트입니다. Claude가 얼마나 깊이 생각할지를 조절하는 주요 수단은 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)이며, [모델과 effort 변경하기](#change-the-model-and-effort)에서 다룹니다. 이런 표현은 effort 설정 범위 안에서 Claude를 약간 유도할 수는 있지만, 설정 수준을 넘어서게 하지는 못합니다.

여전히 도움이 되는 문구 하나는 `be ambitious`입니다. Claude는 사용자가 얼마나 기대하는지 알 수 없기 때문에 요청을 보수적으로 해석하고 요청을 충족하는 최소한의 것을 만드는 경향이 있습니다. 엣지 케이스를 처리하고 자연스러운 후속 작업까지 포함한 더 완전한 버전을 원한다면 그렇게 말하십시오.

```text theme={null}
build the settings page from the mockup. be ambitious: empty and error states, the save flow wired up, keyboard navigation, not just the layout
```

이는 얼마나 깊이 생각할지가 아니라, 사용자만 알고 있는 범위를 Claude에게 알려 주는 것입니다.

그리고 특정 문제를 수정하는 것이 아니라 탐색 중이라면 `what would you improve in this file?` 같은 모호한 프롬프트도 전혀 문제없습니다. 진행하면서 조금 더 수정하게 되겠지만, 그것이 감수할 부분입니다.

### 먼저 Claude와 브레인스토밍하기

아직 원하는 것이 정확히 무엇인지 모르더라도 프롬프트를 입력하기 전에 모든 것을 정리할 필요는 없습니다. 대신 Claude에게 인터뷰를 요청하십시오.

```text theme={null}
I want to add rate limiting to the public API but haven't thought it through yet. Interview me until you could write the spec, then write it to SPEC.md.
```

Claude는 아직 확정하지 않은 부분에 대해 객관식 질문을 합니다. 사용자별 한도와 키별 한도 중 무엇을 쓸지, 한도를 초과한 요청은 어떻게 처리할지, 무엇이 범위 밖인지 등입니다. 답변이 모여 사양이 될 때까지 질문을 계속합니다.

`SPEC.md`가 만들어지면 새 세션을 시작하여 이를 바탕으로 구현하십시오. 그러면 깨끗한 컨텍스트와 문서화된 완료 기준을 가지고 구현을 시작할 수 있습니다. 이 파일은 나중에 [Claude에게 실행할 확인 수단 제공하기](#give-claude-a-check-to-run)에서 리뷰어에게 가리킬 파일이기도 합니다.

### CLAUDE.md를 짧게 유지하기

Claude Code는 모든 세션에 [`CLAUDE.md`](https://code.claude.com/docs/ko/memory)를 로드합니다. 즉, 파일의 모든 줄이 관련 여부와 관계없이 *모든* 작업에서 Claude의 주의력을 조금씩 차지합니다. 그래서 이 파일은 Claude가 코드 자체에서 파악할 수 없는 내용만 담을 때 가장 효과적입니다.

* 이 저장소에서 작업을 확인하는 방법: 정확한 테스트, 타입 검사, 린트 명령과 단일 테스트 파일을 실행하는 방법
* 코드가 오해를 일으키는 부분: 곳곳에 있지만 새 코드에서는 따라 하면 안 되는 오래된 패턴, 사용되지 않는 것처럼 보이지만 실제로는 사용되는 디렉터리
* 저장소에 없는 결정 사항: 팀이 어떤 오류 헬퍼를 쓰기로 정했는지, 배포가 어떻게 이루어지는지, 무엇이 마이그레이션 리뷰를 필요로 하는지
* 이미 두 번 이상 수정해야 했던 모든 것

이 테스트를 통과한 `CLAUDE.md`는 짧게 유지됩니다.

```markdown CLAUDE.md theme={null}
# Commands
- Install: pnpm install
- Run one test file: pnpm vitest run path/to/file.test.ts
- Typecheck: pnpm tsc --noEmit

# Conventions
- Use the error helpers in src/lib/errors.ts, never throw raw strings
- src/legacy/ is still live but don't copy its patterns into new code

# Gotchas
- Integration tests need DATABASE_URL set, see .env.example
```

세션에서 `/context`를 실행하여 Claude가 파일을 로드했는지 확인하십시오.

타입 검사 줄에는 명령만 있다는 점에 주목하십시오. Claude는 작업하면서 자신의 작업을 확인할 수 있도록 명령을 알아야 합니다. Claude가 작업을 마치기 전에 타입 검사 통과를 Claude Code가 *강제*하도록 하려면 [`Stop` 훅](#enforce-the-check-with-a-stop-hook)을 사용해야 합니다. 이 파일에 `Always typecheck before you finish` 같은 줄을 넣으면 대부분은 작동하지만 매번 작동하지는 않습니다.

파일을 처음부터 작성할 필요는 없습니다.

* `/init`은 코드베이스에서 시작 버전을 생성합니다. 거기서부터는 대부분 줄을 삭제하는 작업입니다. [메모리 가이드](https://code.claude.com/docs/ko/memory.md#write-effective-instructions)에서는 200줄 미만으로 유지할 것을 권장합니다.
* `/doctor`는 Claude가 [이미 코드에서 파악할 수 있는](https://code.claude.com/docs/ko/memory.md#my-claude-md-is-too-large) 내용에 대한 삭제를 제안합니다.
* `/doctor prompt-audit`은 이전 모델을 위해 작성된 지시, 더 이상 존재하지 않는 파일을 가리키는 지시, [서로 모순되는](https://code.claude.com/docs/ko/memory.md#audit-your-instruction-files) 지시를 표시합니다.

개인 선호 사항은 `CLAUDE.md` 대신 `CLAUDE.local.md`에 넣고, 저장소에 포함되지 않도록 이 파일을 `.gitignore`에 추가합니다.

> [!NOTE]
>
> `CLAUDE.md`에 *분명히 있는* 줄을 Claude가 계속 무시한다면, IMPORTANT를 추가해도 해결되지 않을 가능성이 높습니다. 파일이 너무 길어져서 그 줄이 묻히고 있거나, 그 줄이 예외가 있어서는 안 되는 규칙인 경우입니다. 후자라면 [훅](#enforce-the-rules-that-cant-have-exceptions)으로 옮겨야 합니다.

### 코드베이스의 특정 부분에만 규칙 적용하기

규칙이 코드베이스의 한 부분에서만 중요하다면, `paths:` 필터와 함께 [`.claude/rules/`](https://code.claude.com/docs/ko/memory#path-specific-rules)에 넣어 Claude가 실제로 그 부분에서 작업할 때만 로드되도록 하십시오. 예를 들어 다음 `.claude/rules/api.md`는 `src/api/` 아래의 TypeScript 파일에 대해 로드됩니다.

```markdown .claude/rules/api.md theme={null}
---
paths:
  - "src/api/**/*.ts"
---
- Validate request bodies with the zod schemas in src/api/schemas/, don't hand-roll checks
- Every new endpoint needs an entry in openapi.yaml, CI fails without it
```

### 팀 절차를 스킬에 넣기

더 뛰어난 모델은 엔지니어링에 대해 더 많이 알고 있지만, *해당* 팀이 릴리스를 어떻게 하는지, 장애 대응 런북에 무엇이 적혀 있는지, API 문서를 어떻게 작성하기를 원하는지는 알지 못합니다. 이런 종류의 지식은 [스킬](https://code.claude.com/docs/ko/skills.md)에 넣습니다. 스킬은 `.claude/skills/<name>/SKILL.md`에 저장된 절차나 팀 지식입니다.

이런 용도에서는 스킬이 `CLAUDE.md`보다 컨텍스트 부담도 적습니다. Claude가 스스로 시작할 수 있는 스킬의 경우, Claude는 모든 세션에서 이름과 설명만 보고, 작업에 필요할 때만 [전체 파일을 읽습니다](https://code.claude.com/docs/ko/skills.md#skill-content-lifecycle). 스킬에 들어 있는 긴 릴리스 절차는 `CLAUDE.md`에 있을 때처럼 관련 없는 버그 수정 작업에 부담을 주지 않습니다.

> [!NOTE]
>
> `CLAUDE.md`의 원칙은 스킬에도 적용됩니다. Claude가 스스로 찾을 수 없는 것만 적어 두십시오.

실제로 릴리스를 만드는 것처럼 부수 효과가 있는 워크플로에는 `disable-model-invocation: true`를 추가하십시오. 그러면 Claude는 [스스로 스킬을 시작할 수 없으며](https://code.claude.com/docs/ko/skills.md#control-who-invokes-a-skill), 사용자가 직접 `/release`를 입력할 때만 실행됩니다. `.claude/skills/release/SKILL.md`로 저장하면 다음과 같은 모습일 수 있습니다.

```markdown .claude/skills/release/SKILL.md theme={null}
---
name: release
description: Cut a new release. Bumps the version, writes the changelog entry, tags it and pushes the tag so CI can publish.
disable-model-invocation: true
---
1. Make sure you're on main with a clean tree. If not, stop and ask.
2. Run `pnpm changeset version` and commit the result.
3. Summarize the PRs merged since the last tag into CHANGELOG.md, one line each, user-facing changes only.
4. Tag `v<new version>` and push the tag. CI publishes from there, never publish from your machine.
```

### Claude에게 필요한 도구 연결하기

Claude가 볼 수 없는 정보 중 일부는 이슈 트래커나 오류 대시보드처럼 아예 다른 시스템에 있습니다. 해당 시스템에 CLI가 있다면 대개 그것이 가장 쉬운 연결 방법입니다. 예를 들어 `gh`가 설치되어 있고 로그인되어 있으면, Claude는 별다른 설명 없이도 풀 리퀘스트를 열고 리뷰 댓글을 읽습니다. Claude가 처음 보는 CLI라면 `--help`를 알려 주는 것으로 충분합니다.

CLI가 없는 시스템에는 [MCP](https://code.claude.com/docs/ko/mcp.md)가 있습니다. 셸에서 서버를 추가합니다.

```bash theme={null}
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

그러면 서버가 세션 안의 `/mcp`에 표시됩니다. 연결된 서버는 사용하지 않을 때도 도구 이름과 지시를 컨텍스트에 추가하므로, 그곳에서 [필요 없는 서버를 끄는](https://code.claude.com/docs/ko/mcp.md#disable-a-server-without-removing-it) 것이 좋습니다.

그리고 타입 언어로 작업한다면, [코드 인텔리전스 플러그인](https://code.claude.com/docs/ko/plugins/code-intelligence.md)을 사용하면 Claude가 여러 파일을 읽으며 정의를 찾는 대신 바로 정의로 이동할 수 있습니다.

## Claude에게 실행할 확인 수단 제공하기

Claude는 작업이 완료된 것처럼 보일 때 멈춥니다. 작업이 실제로 완료되었는지 알려 주는 실행 수단이 없다면, Claude가 의지할 수 있는 것은 "완료된 것처럼 보인다"는 판단뿐입니다. 실제로는 사용자가 테스트 스위트 역할을 하게 되며, 모든 실수는 사용자가 우연히 알아차릴 때까지 그대로 남아 있습니다.

통과 또는 실패를 반환하는 무언가를 제공하면 Claude가 그 루프를 스스로 닫을 수 있습니다. 변경을 수행하고, 확인을 실행하고, 무언가 깨졌다면 출력을 읽고 수정한 뒤 다시 확인을 실행합니다.

> [!TIP]
>
> Claude에게 실행할 수 있고 통과 또는 실패를 반환하는 무언가를 제공하십시오. 이것이 있으면 Claude는 스스로 계속 작업할 수 있고, 사용자는 지켜볼 필요가 없습니다.

Claude가 결과를 읽을 수만 있다면 확인 수단은 거의 무엇이든 될 수 있습니다.

* 테스트 파일
* 빌드의 종료 코드
* 린터
* 출력을 고정값과 비교하는 스크립트
* 목업과 나란히 놓은 [브라우저 스크린샷](https://code.claude.com/docs/ko/chrome.md)

저장소에 이미 이런 것이 있다면, `CLAUDE.md`에서 가장 유용한 한 줄은 그것을 실행하는 명령입니다.

확인을 얼마나 엄격하게 할지는 사용자가 정합니다. 선택지는 Claude가 스스로 판단하는 것부터 Claude Code가 강제하는 것까지 있습니다.

* 프롬프트에서: `run the auth tests after, and keep going until they pass`. Claude가 언제 충분한지 스스로 판단합니다. 이 방법은 설정 없이 지금 바로 모든 작업에서 작동합니다.
* 목표로: [`/goal all tests in tests/auth pass and lint is clean`](https://code.claude.com/docs/ko/goal)은 매 턴 후 별도의 모델이 대화를 기준으로 확인하는 조건을 설정하며, Claude는 조건이 충족될 때까지 계속 작업합니다. 세션 안에서 직접 이것이 필요한 경우는 드뭅니다. 긴 백그라운드 실행에서 중요합니다. 그런 실행에서는 Claude가 아직 남은 항목이 있는데도 진행 상황 요약으로 턴을 끝내는 경우가 있는데, 목표가 Claude를 다시 작업으로 돌려보냅니다.
* Stop 훅으로: [`Stop` 훅](https://code.claude.com/docs/ko/hooks#stop)은 Claude가 턴을 끝내려 할 때마다 스크립트를 실행하고, 스크립트가 종료 코드 2로 끝나면 Claude를 다시 작업으로 돌려보냅니다. 이는 Claude Code(하네스)가 강제하므로, 타입 검사가 통과하거나 [차단 한도](https://code.claude.com/docs/ko/hooks.md#stop-input)에 도달할 때까지 턴이 끝나지 않습니다. [아래에 예제](#enforce-the-check-with-a-stop-hook)가 있습니다.
* 코드를 작성하지 않은 쪽이: 터미널에서 [`/code-review`](https://code.claude.com/docs/ko/code-review-local)는 대화를 본 적 없는 새 서브에이전트에서 diff를 리뷰합니다. 코드를 만들어 낸 추론에 영향을 받지 않습니다.

어떤 방법을 사용하든 Claude에게 *증거*를 요청하십시오. 실행한 명령과 그 출력, 또는 스크린샷입니다. "모든 테스트 통과"라는 말만으로는 알 수 있는 것이 거의 없으며, 출력을 읽는 것이 직접 확인을 다시 실행하는 것보다 빠릅니다. 지켜보지 않은 세션이라면 그것이 유일한 증거이기도 합니다.

> [!TIP]
>
> Claude가 완료했다고 하면 세션에서 [`/verify`](https://code.claude.com/docs/ko/skills#run-and-verify-your-app)를 실행할 수도 있습니다. 그러면 Claude가 앱을 빌드하고 실행하여 결과를 확인합니다. 이를 통해 테스트와 타입 검사가 놓치는 종류의 문제를 잡아낼 수 있습니다.

### 사양을 기준으로 리뷰하기

리뷰가 일반적인 버그를 찾기보다 계획을 기준으로 작업을 확인하기를 원한다면, 리뷰 프롬프트를 직접 작성하십시오.

```text theme={null}
use a subagent to review the rate limiter diff against SPEC.md, check every requirement is implemented and the listed edge cases have tests, report gaps that affect correctness and skip style
```

> [!NOTE]
>
> 프롬프트에서 `skip style` 부분을 빼지 마십시오. 문제를 찾으라는 요청을 받은 리뷰어는 항상 *무언가*를 찾아냅니다. 모든 지적 사항을 고치다 보면 불필요한 추상화 계층과 일어날 수 없는 경우에 대한 테스트가 추가됩니다.

### Stop 훅으로 확인 강제하기

타입 검사 규칙의 `Stop` 훅 버전은 `.claude/settings.json`에 몇 줄만 추가하면 됩니다. 종료 코드 2가 중지를 차단합니다. 명령이 stderr로 출력하는 내용은 Claude가 아직 끝낼 수 없는 이유로 Claude에게 전달되므로, 컴파일러 출력을 그곳으로 리디렉션합니다.

```json .claude/settings.json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "pnpm tsc --noEmit 1>&2 || exit 2" }
        ]
      }
    ]
  }
}
```

작동을 확인하려면 Claude에게 타입을 깨뜨리는 변경을 요청하십시오. Claude는 작업을 마치는 대신 컴파일러 오류를 돌려받고 `tsc`가 통과할 때까지 계속 작업합니다. 훅이 그 사이에 도구 호출 없이 [연속으로 여덟 번 중지를 차단](https://code.claude.com/docs/ko/hooks.md#stop-input)하면, Claude Code는 다음 차단을 재정의하고 턴을 끝냅니다. 상한을 높이려면 [`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오.

## 예외가 있어서는 안 되는 규칙 강제하기

> [!TIP]
>
> 무언가가 매번 일어나야 한다면 훅, 거부 규칙, 관리형 설정으로 만드십시오. `CLAUDE.md`는 지침을 위한 것이며, Claude는 어떤 지침이 적용되지 않는다고 판단할 수 있습니다.

현재 `CLAUDE.md`에 있을 법한 세 가지 규칙을 생각해 보십시오. `Never read .env`, `Always run the formatter after editing`, `Don't touch the migrations folder`. Claude는 거의 매번 이를 따릅니다. "거의"로는 충분하지 않은 몇 가지는 `CLAUDE.md`에서 빼내어 Claude Code(하네스)가 직접 적용하는 구성으로 옮기십시오. 그러면 그때부터 결과는 모델이 무엇을 기억하거나 결정하는지에 좌우되지 않습니다.

### 훅으로 단계 강제하기

[훅](https://code.claude.com/docs/ko/hooks-guide.md)은 Claude 루프의 정해진 시점에 사용자가 지정한 무언가를 실행합니다. 도구 호출 전후, Claude가 멈추려 할 때, 세션이 시작될 때 등입니다. 그 무언가는 다음과 같을 수 있습니다.

* 셸 명령 (일반적인 경우)
* HTTP 엔드포인트로의 POST
* MCP 서버 중 하나에 대한 도구 호출
* 모델이 결정하도록 하는 [`prompt` 또는 `agent` 훅](https://code.claude.com/docs/ko/hooks#hook-handler-fields)

`prompt` 또는 `agent` 훅은 *다른 모델*에게 결정을 요청하므로 역시 결정론적이지 않습니다. 실제로 강제하려면 `command` 또는 `http` 훅을 사용하고, 훅 자체가 충돌하거나 시간 초과될 때도 작업을 중지해야 한다면 [`onFailure: "block"`](https://code.claude.com/docs/ko/hooks#block-the-action-when-a-hook-fails)을 추가하십시오. 예를 들어 커밋에서 시크릿을 검사하는 훅이라면, 스캐너가 중단된 동안 검사되지 않은 커밋을 통과시키기보다는 차단하는 편이 낫습니다.

다음은 포매터 규칙을 `PostToolUse` 훅으로 만든 것입니다. 모든 `Edit` 또는 `Write` 후에 실행되며, Claude가 규칙을 기억하는지는 더 이상 중요하지 않습니다. Claude가 실행하는 것이 아니기 때문입니다.

```json .claude/settings.json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "npx prettier --write --ignore-unknown \"$(jq -r '.tool_input.file_path')\"" }
        ]
      }
    ]
  }
}
```

훅을 확인하려면 Claude에게 Prettier가 포맷하는 파일에 들여쓰기가 잘못된 줄을 추가하도록 요청하십시오. 저장된 파일은 들여쓰기가 수정된 상태로 돌아옵니다.

마이그레이션 규칙은 `migrations/` 아래의 모든 경로에 대해 종료 코드 2로 끝나는 [`PreToolUse` 훅](https://code.claude.com/docs/ko/hooks-guide#block-edits-to-protected-files)이 됩니다. 직접 작성할 필요는 없습니다. `write a hook that blocks edits to the migrations folder`를 프롬프트로 입력하면 되고, `/hooks`에서 결과를 확인할 수 있습니다. 다만 지나치게 사용하지는 마십시오. 훅은 예외가 *전혀* 없는 규칙을 위한 것이며, `Prefer named exports`에는 예외가 많으므로 이런 규칙은 `CLAUDE.md`에 남겨 둡니다.

### 권한 규칙과 샌드박스로 접근 제한하기

[권한 규칙](https://code.claude.com/docs/ko/permissions.md)은 Claude가 무엇을 실행하고, 읽고, 가져올 수 있는지를 결정합니다. `deny` 규칙은 자동 모드와 `bypassPermissions`를 포함한 모든 권한 모드에서 유지되며, 바로 이 때문에 `.env` 규칙은 여기에 속합니다.

```json .claude/settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(pnpm tsc --noEmit)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "Read(./.env.local)", "Read(./secrets/**)"]
  }
}
```

이를 저장하면 Claude에게 `.env`에 무엇이 있는지 물어도 `Read` 도구를 통해서든 `cat .env`를 통해서든 실패합니다.

규칙은 의도가 아니라 도구 호출과 일치하므로, 경계가 어디인지 알아 두는 것이 좋습니다.

* `Read` 규칙은 `cat .env`를 *잡아냅니다*. Claude Code가 [일반적인 파일 읽기 명령](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 인식하기 때문입니다.
* 파일을 여는 스크립트는 잡아내지 못합니다.
* 도메인에 대한 `WebFetch` 거부 규칙은 샌드박스가 켜져 있지 않은 한 같은 도메인으로의 `curl`에는 아무 효과가 없습니다.

파일 시스템이나 네트워크 접근을 OS 수준에서 제한하려면 세션에서 `/sandbox`로 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md)를 켜십시오. 샌드박스는 macOS, Linux, WSL2에서 Claude의 셸 명령을 격리하며 [`Read` 거부 규칙과 `WebFetch(domain:...)` 규칙도 반영](https://code.claude.com/docs/ko/sandboxing#permission-rules)하므로, 보안 관련 사항이라면 둘 다 사용하는 것이 좋습니다.

기본적으로 Claude는 차단된 명령을 샌드박스 밖에서 재시도하도록 여전히 요청할 수 있으며, 그 요청은 일반적인 권한 흐름을 거칩니다. `/sandbox`의 **Overrides** 탭에 있는 [strict 샌드박스 모드](https://code.claude.com/docs/ko/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)는 이 재시도를 끕니다.

> [!WARNING]
>
> 자동 모드는 엄격한 규칙이 아니라 각 작업을 판단하는 분류기 모델입니다. 판단에 능숙하지만, 모든 판단이 그렇듯 틀릴 수 있습니다. 또한 무엇을 위험하게 취급할지 조정할 수 있고, 조직이 이를 완전히 끌 수도 있으므로, "절대" 규칙은 거부 규칙이나 훅에 두어야 합니다.

### 규칙을 적용할 대상 선택하기

규칙이 어디에 있는지에 따라 누구에게 적용되는지가 결정됩니다.

* `.claude/settings.local.json`과 `~/.claude/settings.json`은 본인에게만 적용됩니다. 명령에 대해 **Yes, and don't ask again**을 선택하면 Claude Code는 해당 규칙을 로컬 파일에 저장합니다.
* `.claude/settings.json`과 그 안의 훅은 저장소에 속합니다. 커밋하면 저장소에서 작업하는 모든 사람에게 적용됩니다. 거부 규칙은 즉시 적용됩니다. `allow` 규칙은 각 사람이 해당 폴더의 [신뢰 대화 상자](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)를 수락할 때까지 대기하며, [워크스페이스 신뢰](https://code.claude.com/docs/ko/hooks.md#workspace-trust)는 훅이 각자의 머신에서 언제 실행되기 시작할지도 결정합니다.
* [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)은 조직에 속합니다. 관리 콘솔, MDM 또는 `managed-settings.json` 파일에서 제공되며, 어떤 개인 설정 파일로도 재정의할 수 없으므로 보안 팀의 정책을 둘 수 있는 유일한 곳입니다. 이를 설정하는 담당자라면 [조직을 위한 Claude Code 설정](https://code.claude.com/docs/ko/admin-setup.md)을 참조하십시오.

범위가 무엇이든 강제되는 항목은 적게 유지하십시오. 모든 훅과 거부 규칙은 가끔 작동해서는 안 될 때 작동하며, 누군가는 각각을 유지 관리해야 합니다. 그런 항목이 40개에 이른다면, 대부분은 Claude가 스스로 판단할 수 있었던 선호 사항일 가능성이 높습니다.

## 기본값 변경하기

> [!TIP]
>
> 작업에 필요 이상으로 시간, 토큰, 중단이 들기 전까지는 기본값을 그대로 두어도 충분합니다. 그런 일이 생기면 세션에서 `/usage`를 실행하여 어디에 소비되었는지 확인하십시오.

새 세션은 이미 몇 가지 결정을 대신 내립니다.

* 대화형 터미널 및 VS Code 세션은 자동 모드에서 시작합니다.
* 대부분의 플랜과 제공업체에서 [Claude Opus 5.5를 medium effort로](https://code.claude.com/docs/ko/model-config.md#default-model-setting) 실행합니다.
* 이유가 있다고 판단하면 서브에이전트에 작업을 위임합니다.
* 대화가 길어지면 압축합니다.

대부분의 경우 이런 것들을 신경 쓸 필요가 없습니다. 작업에 필요 이상의 비용이 든다면, 대개 이 네 가지 중 하나가 원인입니다.

### 권한 모드 변경하기

권한 범위의 양쪽 끝에는 모두 비용이 있습니다.

* **Manual 모드**: 읽기 전용이 아닌 모든 편집과 명령을 직접 승인합니다. 안전하지만, 열 번째 프롬프트쯤 되면 읽지 않고 승인하게 되며, 자리를 비운 동안에는 아무것도 진행되지 않습니다.
* **`bypassPermissions`**: 거부 및 확인 규칙에 해당하지 않는 모든 것을 승인하며, 일회용 컨테이너에서만 의미가 있습니다.

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)는 그 중간에 있으며, 대화형 터미널 및 VS Code 세션이 [시작되는 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in)입니다. Claude는 일상적인 승인을 위해 멈추지 않고 작업하며, 별도의 분류기 모델이 작업이 실행되기 전에 [정해진 순서](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)로 확인합니다. 분류기는 [사람이 막기를 원할 만한 것](https://code.claude.com/docs/ko/permission-modes.md#what-the-classifier-blocks-by-default)에 집중합니다.

* `curl | bash`
* 프로덕션 배포 및 마이그레이션
* 다른 사람의 작업을 덮어쓰는 force push
* 외부 엔드포인트로 전송되는 민감한 데이터
* 사용자가 아니라 Claude가 읽은 콘텐츠에 의해 유도된 것으로 보이는 작업

분류기가 무언가를 차단하면 알림이 표시되고, 해당 작업은 `/permissions`의 **Recently denied** 아래에 나타나며, 그곳에서 수동 승인으로 재시도할 수 있습니다. [연속 세 번 차단](https://code.claude.com/docs/ko/permission-modes.md#when-auto-mode-falls-back)(또는 총 20번)되면 자동 모드는 일시 중지되고 다시 확인을 요청하는 방식으로 돌아갑니다.

이 중 어느 것도 결정론적 통제를 대체하지 않습니다. 분류기는 그 *이후에* 실행되기 때문입니다. 거부 및 확인 규칙과 `PreToolUse` 훅은 분류기가 무엇이든 보기 전에 적용되므로, 거부 규칙은 다른 모든 곳과 똑같이 자동 모드에서도 차단합니다. 샌드박스는 여전히 [샌드박스가 감싸는 셸 명령](https://code.claude.com/docs/ko/sandboxing.md#what-runs-outside-the-sandbox)을 격리합니다.

> [!NOTE]
>
> 대화에서 `don't push until I've reviewed`라고 말할 수도 있으며, 분류기는 [이를 차단 신호로 취급합니다](https://code.claude.com/docs/ko/permission-modes.md#boundaries-you-state-in-conversation). 그래도 이는 트랜스크립트를 읽는 모델이며, 대화가 압축될 때 그 문장이 사라질 수 있으므로 중요한 것은 거부 규칙에 두어야 합니다.

반대 문제는 분류기가 해당 환경에서는 일상적인 작업을 반복해서 막는 경우입니다. 매번 수동으로 승인하는 대신, `autoMode.allow`에 추가하거나 [자동 모드 구성](https://code.claude.com/docs/ko/auto-mode-config.md)에서 신뢰할 수 있는 인프라를 설명하십시오. 패턴이 아닌 평이한 영어로 작성하며, [`/auto-mode-setup`](https://code.claude.com/docs/ko/auto-mode-config#generate-environment-entries)이 프로젝트와 최근 세션을 바탕으로 `environment` 부분의 초안을 작성해 줄 수 있습니다.

```json ~/.claude/settings.json theme={null}
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Source control: github.com/example-org and every repo under it",
      "Trusted internal domains: *.internal.example.com"
    ],
    "allow": [
      "$defaults",
      "Deploying to the staging namespace is fine, it's isolated from production and resets nightly"
    ]
  }
}
```

> [!WARNING]
>
> 설정하는 모든 목록에 `"$defaults"`를 유지하십시오. 이것이 없으면 입력한 항목이 해당 목록의 기본 제공 규칙에 추가되는 대신 이를 *대체*합니다. `environment`와 `allow`에서는 기본 제공 컨텍스트와 예외를 잃게 되며, `soft_deny` 목록에서 이를 빼면 force push와 프로덕션 배포에 대한 기본 제공 차단이 사라집니다.
>
> 또한 `autoMode` 블록은 프로젝트가 아니라 `~/.claude/settings.json`에 있어야 합니다. 분류기는 프로젝트 설정의 `autoMode`를 무시하기 때문입니다.

모든 편집과 명령을 실행 전에 보고 싶다면, 세션에서 `Shift+Tab`을 눌러 Manual을 포함한 권한 모드를 순환하거나, 셸에서 `claude --permission-mode manual`로 시작하십시오. 그리고 Manual에서 확인 요청이 너무 잦다면, `/fewer-permission-prompts`가 최근 트랜스크립트에서 자주 쓰이는 읽기 전용 Bash 및 MCP 호출을 찾아 `.claude/settings.json`의 허용 목록에 추가합니다.

### 모델과 effort 변경하기

[Effort](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)는 Claude가 얼마나 오래 생각할지를 조절하는 주요 수단이며, 예전에 프롬프트 문구로 하던 일 대부분을 대체합니다. Claude Opus 5.5, Sonnet 5.5, Haiku 5.5의 기본값은 `medium`이며, 범위가 명확한 일상적인 기능 작업에는 이것으로 충분합니다. 세션에서 `/effort`로 조정할 만한 경우는 다음과 같습니다.

* 놓치기 쉬운 경우에 따라 결과의 정확성이 좌우된다면 `/effort high` 또는 `/effort xhigh`로 높이십시오. 직접 작성하지 않은 코드의 버그, 불안정한 테스트, Claude가 이전 형태를 읽는 모든 곳을 찾아야 하는 스키마 변경 등을 생각해 보십시오. 그러면 Claude는 답하기 전에 더 많은 엣지 케이스를 확인하고 작업을 더 많이 검증하며, 추가 시간과 토큰은 여기에 쓰입니다.
* 빠르게 주고받으면서 어차피 결과를 하나하나 검토하는 경우에는 `/effort low`로 낮추십시오. 브레인스토밍, 첫 스케치, 몇 개 파일에 걸친 이름 변경 등입니다. Claude가 더 빨리 출발점을 제공하며, 모든 단계를 사용자가 조종하고 있으므로 추가 숙고는 기다리는 시간 외에는 크게 달라지게 하지 않았을 것입니다.
* `max`는 보안 취약점 탐색처럼 Claude가 사용자 없이 끝까지 파고들기를 원하는 어려운 문제에만 사용하십시오. 일반적인 작업에서는 지나치게 생각하는 경향이 있어서, `high`가 줬을 답보다 나을 것이 없는 답에 더 많은 비용을 지불하게 됩니다.
* 다른 부분은 일상적인 작업 중에 까다로운 질문 하나처럼 다음 메시지에만 필요하다면, 설정을 바꾸는 대신 해당 프롬프트에 [`ultrathink`](https://code.claude.com/docs/ko/model-config#use-ultrathink-for-one-off-deep-reasoning)를 넣으십시오.

모델 자체의 경우, 기본값인 Opus 5.5가 대부분의 코딩을 잘 처리하고 Sonnet은 일상적인 작업에서 비용이 적게 듭니다. [Claude Fable 5.1](https://code.claude.com/docs/ko/model-config.md#work-with-fable)은 `/model fable`로 명시적으로 선택하면 사용할 수 있고, Haiku는 간단한 작업을 하는 서브에이전트에 잘 맞습니다. 플랜 및 제공업체별 전체 목록은 [모델 구성](https://code.claude.com/docs/ko/model-config.md)에 있습니다.

### 서브에이전트의 비용 알기

Claude는 스스로 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)에 작업을 위임합니다.

* 광범위한 코드베이스 검색은 기본 제공 Explore 에이전트로 넘어갑니다.
* 부수적인 작업은 fork 모드가 켜져 있는 동안(기본값) [분기](https://code.claude.com/docs/ko/sub-agents.md#fork-the-current-conversation)됩니다.
* Claude가 시작하는 서브에이전트는 기본적으로 백그라운드에서 실행되므로 메인 대화가 계속 진행됩니다.

이 중 무엇도 직접 요청할 필요는 거의 없지만, 무엇을 얻고 비용이 얼마나 드는지 알아 두면 도움이 됩니다.

서브에이전트는 다음과 같은 상황에서 효과를 발휘합니다.

* 독립적인 작업을 동시에 실행하여 전체 작업을 더 빨리 끝내기
* 전체 테스트 실행이나 광범위한 검색처럼 긴 출력이 메인 대화에 들어오지 않게 하기. 그렇지 않으면 세션의 나머지 내내 따라다닙니다
* 코드가 어떻게 작성되었는지 보지 않은 리뷰어 확보하기
* 읽을 수는 있지만 편집할 수는 없는 리뷰어처럼, 메인 세션보다 적은 도구로 작업 수행하기

비용은 주로 토큰입니다. 모든 서브에이전트는 자체 요청을 보내며, 이는 메인 대화와 같은 사용량에 포함됩니다. 때로는 시간도 듭니다. 새 서브에이전트는 대화에 이미 있던 컨텍스트를 먼저 수집해야 하므로, 현재 위치에서 작업하는 것보다 *더 느릴* 수 있습니다.

그리고 기본적으로 같은 작업에 같은 모델(또는 더 작은 모델)을 사용합니다. 병렬 처리나 새로운 시각은 얻을 수 있지만, 더 똑똑한 답을 얻지는 못합니다.

비용을 줄이려면 다음을 고려하십시오.

* 모듈을 import하는 파일을 수집하거나 문서의 링크를 확인하는 것처럼 작업이 단순하다면 서브에이전트 정의에 [`model: haiku`](https://code.claude.com/docs/ko/sub-agents#choose-a-model)를 설정하십시오. 그런 작업에는 큰 모델이 필요 없으며, Haiku는 요청당 비용이 훨씬 적습니다.
* 짧은 요약을 반환하도록 요청하여, 결과 20개가 결국 컨텍스트를 채우지 않도록 하십시오.
* `/usage`를 확인하여 각 서브에이전트 유형이 사용량에서 차지하는 비중을 보고, 어떤 것이 비용만큼의 가치를 하는지 판단하십시오.
* `.claude/agents/`의 사용자 지정 서브에이전트에 `tools: Read, Grep, Glob`만 부여하십시오. 그러면 아무것도 편집할 수 없는 리뷰어가 되며, 그 제한은 프롬프트로 요청되는 것이 아니라 Claude Code가 강제합니다.

그 리뷰어는 짧은 파일 하나, `.claude/agents/reviewer.md`입니다.

```markdown .claude/agents/reviewer.md theme={null}
---
name: reviewer
description: Reviews changed files against the spec they were built from. Use after implementing a feature, before opening the PR.
tools: Read, Grep, Glob
---
You're reviewing code you didn't write. Compare the changed files against the spec you're given,
check that every requirement is implemented and the listed edge cases have tests,
and report only the gaps that affect correctness. Skip style.
```

Claude에게 `have the reviewer compare the rate limiter against SPEC.md`라고 요청하면, 누락된 부분이 세션으로 돌아오고 Claude가 이를 수정할 수 있습니다.

### 비용과 컨텍스트 줄이기

대부분의 최신 모델이 1M 토큰 윈도우를 가지고 있고 그 상한 근처에서 압축이 이루어지므로, 컨텍스트가 부족해지는 경우는 드뭅니다. 그래도 필요 없는 컨텍스트에 *비용을 지불*할 수는 있습니다. 모든 요청은 전체 대화를 보내므로, 관련 없는 작업 세 개가 쌓인 세션은 네 번째 작업의 매 턴마다 세 작업을 모두 다시 읽습니다. 이는 [캐시가 유효한 동안에는 할인되며](https://code.claude.com/docs/ko/costs.md#why-usage-climbs-in-a-long-session) 캐시가 만료되면 정가가 적용됩니다.

[`/usage`](https://code.claude.com/docs/ko/costs)가 가장 먼저 확인할 곳입니다. Pro, Max, Ultra, Team, Enterprise에서는 사용량을 스킬, 서브에이전트, 플러그인, MCP 서버별로 분류해 보여 줍니다. 또한 긴 컨텍스트나 잦은 캐시 미스 같은 패턴이 사용량의 10%를 넘으면 이를 표시합니다. 그다음 일반적인 해결 방법은 다음과 같습니다.

* 관련 없는 작업 사이에는 `/clear`를 실행하십시오. 비용이 들지 않으며, 다음 작업이 이전 작업의 기록에 계속 비용을 지불하지 않게 됩니다. `/clear oauth-migration`은 떠나는 세션에 이름을 붙여 나중에 다시 돌아올 수 있게 합니다.
* `/compact keep the API changes and the test commands`처럼 초점을 지정하여 `/compact`를 실행하십시오. 긴 세션에서는 `/compact` 자체가 큰 요청입니다. 요약하기 위해 전체 대화를 읽기 때문이며, 캐시가 만료된 후라면 더욱 그렇습니다.
* 백그라운드 작업을 주시하십시오. `/loop`, 매 턴 후 실행되는 목표 확인, Claude 자체의 서브에이전트는 모두 사용자가 입력하지 않는 동안에도 계속 요청을 보냅니다.

> [!NOTE]
>
> [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md)는 구독에서는 약 1시간, API 키, 클라우드 제공업체, 사용량 크레딧에서는 5분간 유지됩니다. 서브에이전트는 변경하지 않는 한 5분입니다.
>
> 1시간 캐시에서는 약 200K 토큰을 넘은 세션이 유휴 상태로 있으면 캐시가 만료되기 직전에 압축되므로, 점심 식사 후에는 요약에서 이어서 작업하게 됩니다. 기록이 전혀 필요 없다면 새 세션이 여전히 비용이 적게 듭니다.

## 세션 조종하기

> [!TIP]
>
> 처음 1분을 지켜보고, Claude가 엇나가는 순간 `Esc`를 누르고, 두 번의 수정이 실패하면 세 번째 수정 대신 `/clear`를 실행하고 더 나은 프롬프트를 작성하십시오.

어떤 구성도 처음 1분을 지켜보다가 Claude가 의도하지 않은 방향으로 갈 때 개입하는 것을 대체할 수는 없습니다. 이를 위한 수단은 몇 가지뿐이며, 숙지해 둘 가치가 있습니다.

* `Esc`는 Claude를 작업 도중에 멈추고 그 시점까지의 모든 것을 유지하므로, 작업을 잃지 않고 방향을 바꿀 수 있습니다.
* `/rewind` 또는 빈 프롬프트에서 `Esc`를 두 번 누르면 [rewind 메뉴](https://code.claude.com/docs/ko/checkpointing.md#rewind-and-summarize)가 열리며, 코드나 대화 또는 둘 다를 이전 프롬프트로 되돌릴 수 있습니다. 덕분에 더 과감한 접근을 먼저 시도하고 잘 되지 않으면 되돌리는 것이 위험하지 않습니다. 같은 메뉴에서 오래된 대화의 일부를 요약할 수도 있습니다.
* `/clear`는 처음부터 다시 시작합니다. 같은 것을 두 번 수정했는데도 여전히 틀리다면, 세 번째 수정은 Claude가 계속 다시 읽어야 하는 실패한 시도 두 개가 이미 담긴 대화에 내용을 더할 뿐입니다. `/clear`와 함께 알게 된 내용을 반영한 새 프롬프트 하나가 거의 항상 더 효과적입니다.

> [!WARNING]
>
> 체크포인트는 메인 대화에서 Claude가 자체 파일 도구로 편집한 파일을 대상으로 하므로, Bash 명령만 건드린 파일은 [복원되지 않습니다](https://code.claude.com/docs/ko/checkpointing.md#bash-command-changes-not-tracked). 체크포인트는 git을 대체하는 것이 아니라 git과 함께 작동합니다.

더 작은 수단 두 가지가 있습니다. [`/btw`](https://code.claude.com/docs/ko/interactive-mode#side-questions-with-%2Fbtw)는 기록에 아무것도 추가하지 않고 간단한 질문에 답합니다. 그리고 며칠에 걸친 작업의 경우, 세션에서 `/rename oauth-migration`으로 이름을 붙이면 나중에 셸에서 [`claude --resume oauth-migration`](https://code.claude.com/docs/ko/sessions#resume-by-session-id-or-name)으로 체크포인트를 포함하여 다시 이어서 작업할 수 있습니다. `claude --continue`는 가장 최근 세션을 재개합니다.

## 사용자 없이 Claude 실행하기

> [!TIP]
>
> 실행을 무인 상태로 두기 전에, 완료가 무엇인지 알고, 자신의 작업을 확인할 수 있고, 접근해야 할 것에만 접근할 수 있는지 확인하십시오. 턴 수나 지출에 상한을 두고, 마지막에는 사람이 결과를 승인하도록 하십시오.

사용자가 실수를 잡아 줄 수 없게 되면 이 페이지의 모든 내용이 조금 더 중요해집니다. 지켜보고 있을 때는 Claude가 일부 컨텍스트를 놓쳐도 큰 문제가 아닙니다. 한두 메시지 안에 알아차리고 알려 주면 됩니다. 잠자리에 들기 전에 시작한 실행에서는 아무도 알려 주지 않으며, 다음 날 아침에야 Claude가 밤새 잘못된 가정 위에 작업을 쌓아 왔다는 사실을 알게 됩니다.

작업을 스스로 실행되도록 두기 전에, 해당 작업을 염두에 두고 다음 다섯 가지 질문을 검토해 보는 것이 좋습니다.

1. 완료가 무엇인지 아는가? 목표 조건, 사양 파일, 또는 통과시켜야 하는 실패하는 테스트.
2. 자신의 작업을 확인할 수 있는가? 테스트 스위트, `Stop` 훅, 일종의 리뷰 단계.
3. 무엇에 접근할 수 있는가? 권한 규칙, `dontAsk`, 샌드박스, 워크트리, 푸시할 수 있는 단 하나의 브랜치.
4. 무엇이 실행을 멈추는가? `--max-turns`, `--max-budget-usd`, 지출 한도.
5. 결과는 어디로 가고, 누가 승인하는가? PR, 댓글 또는 요약, 그리고 병합, 배포 또는 되돌릴 수 없는 그 밖의 모든 것을 승인하는 사람.

일단 실행되면 Claude는 긴 작업을 스스로 끝까지 수행합니다. 사용자에게 남는 일은 작업을 시작하는 것, 이번에는 "완료"가 무엇을 의미하는지 정하는 것, 그리고 마지막에 병합을 승인하는 것입니다.

### 스크립트에서 Claude 실행하기

[`claude -p "prompt"`](https://code.claude.com/docs/ko/headless)는 한 번 실행하고 종료합니다. 이것이 Claude Code가 CI 작업, git 훅, 셸 루프에서 사용되는 방식입니다.

스크립트에서는 거의 항상 몇 가지 플래그를 더 사용하게 됩니다.

* [`--bare`](https://code.claude.com/docs/ko/headless#start-faster-with-bare-mode)는 저장소와 머신 모두의 훅, 스킬, 플러그인, MCP 서버, `CLAUDE.md` 파일을 건너뛰므로, 실행이 어디서 이루어지든 동일하게 동작합니다. 또한 claude.ai 로그인을 전혀 사용하지 않습니다. 인증은 `ANTHROPIC_API_KEY`, `--settings`로 전달하는 파일의 `apiKeyHelper`, 또는 클라우드 제공업체의 자격 증명에서 가져옵니다.
* `--append-system-prompt`, `--mcp-config`, `--settings`는 실행에 *실제로* 필요한 것을 명시적으로 전달합니다.
* `--allowedTools`는 도구를 사전 승인하며, [`--permission-mode dontAsk`](https://code.claude.com/docs/ko/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)는 그 밖에 확인을 요청했을 모든 작업을 거부합니다.
* `--output-format json`은 파싱할 단일 결과 객체를 제공하며, `--verbose`와 함께 `stream-json`을 사용하면 이벤트가 발생할 때마다 스트리밍합니다.

이를 모두 합치면 다음과 같습니다.

```bash theme={null}
for file in $(cat files.txt); do
  claude --bare -p "Migrate $file to the new logger API and commit. Reply OK or FAIL." \
    --allowedTools "Read,Edit,Bash(git add *),Bash(git commit *)" \
    --permission-mode dontAsk \
    --max-turns 20
done
```

실행이 끝나면 Claude는 `OK` 또는 `FAIL`로 응답하며, 턴 한도에 도달한 실행은 대신 오류와 함께 종료됩니다. 먼저 파일 세 개로 시도해 보고, 무엇이 잘못되는지 확인하고, 프롬프트를 수정한 다음 나머지를 실행하십시오.

`--permission-mode auto`를 전달하면 `-p`에서도 자동 모드가 작동합니다. 비대화형 실행에서는 분류기 차단이 해당 작업 하나만 거부하고 Claude는 계속 진행하며, 반복된 차단이 터미널에서처럼 실행을 일시 중지하지 않습니다. 이에 의존하기 전에 [그 경우 임계값이 어떻게 적용되는지](https://code.claude.com/docs/ko/permission-modes.md#repeated-block-thresholds) 읽어 보십시오.

### 일정이나 이벤트에 따라 실행 시작하기

일단 실행이 시작되면 Claude는 나머지를 스스로 처리할 수 있습니다. Claude가 할 수 없는 단 한 가지는 *시작*을 결정하는 것이므로, 무언가가 시작해 주어야 합니다. 사용자, 타이머, 또는 실패한 CI 검사나 새 PR 같은 이벤트입니다.

열려 있는 세션 안에서는 일정 간격으로 프롬프트를 반복하는 [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks#run-a-prompt-repeatedly-with-%2Floop)를 사용합니다.

```text theme={null}
/loop 15m check CI on this branch, and if it's red pull the failing job's log, fix it and push
```

각 실행은 같은 세션의 또 다른 턴이므로, 긴 대화에서 계속 실행되도록 두지 마십시오. 노트북이 닫혀 있는 동안 일어나야 하는 작업에는 [`/schedule`](https://code.claude.com/docs/ko/routines#create-from-the-cli)이 타이머로 실행되는 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)을 설정합니다. API 키가 아닌 claude.ai 로그인이 필요합니다. Claude에게 요청하여 GitHub 이벤트 트리거를 추가하거나, [claude.ai/code/routines](https://claude.ai/code/routines)에서 API 트리거를 추가할 수 있습니다.

> [!WARNING]
>
> 클라우드 예약 작업을 실행되도록 두기 전에, [작업이 우회할 수 없는 GitHub 브랜치 규칙](https://code.claude.com/docs/ko/routines.md#repositories-and-branch-permissions)으로 `main`을 보호하십시오. 그리고 새로운 작업은 무인 상태로 신뢰하기 전에 처음 몇 번의 실행을 지켜보십시오.

### 세션 병렬로 실행하기

여러 작업을 동시에 진행할 때는 편집이 충돌하지 않도록 각각에 별도의 체크아웃을 제공하십시오. [`claude -w feature-auth`](https://code.claude.com/docs/ko/worktrees#start-claude-in-a-worktree)는 새 워크트리에서 세션을 시작하고, [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md#work-in-parallel-with-sessions)은 이러한 세션 여러 개를 나란히 실행하며, [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 머신 대신 클라우드에서 실행합니다.

워크트리는 새 체크아웃이므로 `.env` 같은 gitignore된 파일이 없고 의존성도 설치되어 있지 않습니다. 전자의 경우, 필요한 gitignore된 파일을 저장소 루트의 [`.worktreeinclude`](https://code.claude.com/docs/ko/worktrees#copy-gitignored-files-into-worktrees)에 나열하면(`.gitignore`와 같은 구문) Claude Code가 생성하는 모든 워크트리에 이를 복사합니다.

```text .worktreeinclude theme={null}
.env
.env.local
config/dev-credentials.json
```

작은 파일만 넣으십시오. 링크가 아니라 복사하므로, 여기에 `node_modules`를 넣으면 워크트리마다 전체 복사본이 생깁니다. 큰 디렉터리에는 [`worktree.symlinkDirectories`](https://code.claude.com/docs/ko/settings-reference#worktree-symlinkdirectories) 설정을 사용하거나, `CLAUDE.md`에 설치 명령을 적어 두어 Claude가 새 체크아웃에서 시작할 때마다 실행하도록 하십시오.

이를 직접 정리해야 하는 경우는 거의 없습니다.

* 이름 없는 워크트리 세션을 종료하면, 워크트리에 아무것도 없는 경우 Claude Code가 [워크트리를 제거합니다](https://code.claude.com/docs/ko/worktrees.md#clean-up-worktrees). 이름이 있는 세션이나 변경 사항이 있는 세션의 경우 어떻게 할지 묻습니다.
* 서브에이전트 워크트리는 서브에이전트가 변경 없이 끝나면 사라집니다.
* 남겨진 서브에이전트 및 백그라운드 세션 워크트리는 `cleanupPeriodDays`보다 오래되고 작업 내용이 없으면 정리됩니다.

> [!NOTE]
>
> `claude -p --worktree` 실행은 묻지 않고 종료되므로 직접 정리해야 합니다. `git worktree remove <path>`로 제거하고, 워크트리가 잠겨 있어 git이 거부하면 먼저 `git worktree unlock <path>`를 실행하십시오.

여러 파일에 걸친 하나의 큰 기계적 변경에는 [`/batch migrate every handler to the v2 response helpers`](https://code.claude.com/docs/ko/commands)가 작업을 5\~30개 단위로 나누고 계획을 보여 줍니다. 그런 다음 각 단위를 자체 워크트리에서 실행하고 각각에 대해 PR을 엽니다. 셸에서는 [`claude agents`](https://code.claude.com/docs/ko/agent-view)(아직 리서치 프리뷰)가 머신의 백그라운드에서 실행 중인 모든 것을 한 화면에서 보여 줍니다.

두 번째 세션은 가장 쉽게 얻을 수 있는 독립적인 리뷰어이기도 합니다. 한 세션이 속도 제한기를 작성하고, 다른 세션은 작성 과정을 보지 않은 채 `@src/middleware/rateLimiter.ts`를 리뷰하며, 사용자가 그 결과를 첫 번째 세션에 붙여 넣습니다. `/code-review`와 같은 아이디어이며, 메시지를 사용자가 전달하는 것입니다.

## 더 이상 하지 않아도 되는 것

다음 항목은 모두 작성 당시에는 좋은 조언이었습니다. 대부분은 모델이 아직 안정적으로 할 수 없던 일을 우회하기 위한 방법이었고, 이제 모델이 그 수준에 도달했습니다. 몇 가지가 아직 습관으로 남아 있다면, 이를 버려도 되는 이유는 다음과 같습니다.

| 이전 조언 | 더 이상 필요 없는 이유 |
| :- | :- |
| 컨텍스트 윈도우가 주요 제약이므로 적극적으로 관리하라 | 대부분의 최신 모델은 1M 토큰 윈도우를 가지고 있고 압축이 자동으로 이루어지므로 컨텍스트가 부족해지는 경우는 드뭅니다. 그래도 작업 사이에 `/clear`를 실행할 가치는 있습니다. 집중된 컨텍스트가 더 나은 답을 주고 비용도 적게 들기 때문입니다. |
| Claude가 계속 놓치는 지시에 IMPORTANT나 대문자를 추가하라 | 이전 모델은 때때로 강조가 필요했습니다. 최신 모델은 평이하게 작성된 줄을 따르며, 강조를 쌓으면 주로 Claude가 규칙을 과도하게 적용하게 됩니다. 굽힐 수 없는 규칙이라면 훅이나 거부 규칙으로 만드십시오. 긴 파일에서 그 줄이 묻히고 있다면 파일을 줄여야 합니다. |
| 컨텍스트 윈도우를 보호하기 위해 서브에이전트를 사용하라 | 컨텍스트 부족은 이제 거의 문제가 되지 않습니다. 서브에이전트는 여전히 병렬 작업, 시끄러운 출력 격리, 독립적인 리뷰에 훌륭하지만, 각각 추가 토큰이 듭니다. |
| 더 나은 답을 얻으려면 서브에이전트에 위임하라 | 같은 작업을 서브에이전트에 넘긴다고 답이 더 나아지지는 않습니다. 새 리뷰어는 사용자의 추론을 보지 않았기 때문에 도움이 되지만, 이는 위임과는 다른 것입니다. |
| 프롬프트에 `think hard`, `think harder`, `be thorough` 넣기 | 그 역할은 effort가 담당합니다. 이런 문구는 effort를 높이는 키워드가 아니라, effort 설정 범위 안에서 Claude를 약간 유도하는 일반적인 프롬프트 텍스트입니다. `ultrathink`는 여전히 작동합니다. effort 설정을 건드리지 않고 해당 턴 한 번에 대해 더 깊은 추론을 요청합니다. |
| Claude에게 계속하라고, 완료될 때까지 반복하라고, 게으름 피우지 말라고 말하라 | 최신 모델은 대개 별도 지시 없이도 합의된 작업을 끝까지 수행하며, 그런 문구는 멈춤을 해결하기보다 과잉 작업을 일으킬 가능성이 더 큽니다. Claude에게 통과해야 할 확인 수단을 제공하는 것은 다른 문제이며, 여전히 할 가치가 있습니다. 실행이 너무 일찍 멈추면 `continue`라고 말하고, 아무도 지켜보지 않는 실행에서는 `/goal`이나 `Stop` 훅이 이를 강제합니다. |
| `CLAUDE.md`에 아키텍처와 파일 구조를 설명하라 | Claude는 저장소를 직접 읽습니다. 저장소에 없는 것만 적어 두십시오. |

이 페이지의 다른 조언도 언젠가 쓸데없는 일처럼 느껴지기 시작한다면, 그것 역시 이 표에 들어가야 한다는 신호일 가능성이 높습니다.

## 관련 리소스

* [Claude Code 작동 방식](https://code.claude.com/docs/ko/how-claude-code-works.md): 루프, 도구, 시작 시 로드되는 항목
* [컨텍스트 윈도우 살펴보기](https://code.claude.com/docs/ko/context-window.md): 세션에서 무엇이 공간을 차지하고 언제 로드되는지
* [Claude Code 확장](https://code.claude.com/docs/ko/features-overview.md): 스킬, 훅, MCP, 서브에이전트, 플러그인 중에서 선택하기
* [권한 모드 선택](https://code.claude.com/docs/ko/permission-modes.md) 및 [권한 구성](https://code.claude.com/docs/ko/permissions.md)
* [비용 효과적으로 관리하기](https://code.claude.com/docs/ko/costs.md)
* [프로그래밍 방식으로 Claude Code 실행하기](https://code.claude.com/docs/ko/headless.md) 및 [클라우드 예약 작업으로 작업 자동화하기](https://code.claude.com/docs/ko/routines.md)
* 팀 리더 및 관리자용: [조직을 위한 Claude Code 설정](https://code.claude.com/docs/ko/admin-setup.md)
