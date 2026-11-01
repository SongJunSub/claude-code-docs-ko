> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 모노레포 또는 대규모 코드베이스에서 Claude Code 설정하기

> 중첩된 CLAUDE.md 파일, 스파스 워크트리, 코드 인텔리전스, 패키지별 스킬을 사용하여 모노레포 및 대규모 단일 트리 코드베이스에 대해 Claude Code를 구성하여 Claude가 작업 중인 코드에 집중하도록 유지합니다.

대규모 코드베이스는 수백만 줄의 코드가 있는 하나의 저장소이거나 많은 패키지가 있는 모노레포일 수 있습니다. Claude Code는 모든 규모에서 작동하지만, 코드베이스가 커질수록 더 작은 프로젝트를 위해 조정된 기본값이 컨텍스트 윈도우를 작업과 관련 없는 지침 및 파일 읽기로 채워서 토큰 비용을 증가시키고 Claude의 성능을 저하시킬 수 있습니다.

이 가이드는 개별 개발자와 엔지니어링 팀이 Claude를 작업이 영향을 미치는 코드베이스의 일부로 범위를 지정하는 방법을 보여줍니다. 각 섹션은 설정이 개인 머신에 개인적인지 저장소에 커밋되는지 명시합니다.

## 이 가이드에서 다루는 내용

아래의 [표](#settings-on-this-page)는 각 설정과 그것이 수행하는 작업을 나열합니다. 그 다음의 [파일 트리](#the-example-monorepo)는 이 페이지의 모든 코드 샘플이 참조하는 예제 모노레포입니다.

### 이 페이지의 설정

아래의 각 설정은 독립적입니다. 서로를 대체하지 않고 계층화되므로 저장소에 맞는 것을 적용하십시오. [Claude를 시작할 위치 선택](#choose-where-to-start-claude)은 설정 파일이 어디에 있는지 결정하므로 먼저 읽으십시오. [모두 함께 사용](#put-it-together)은 모두 결합된 것을 보여줍니다.

| 원하는 것 | 사용 |
| :- | :- |
| 모든 하위 시스템을 다루는 하나의 루트 파일 대신 터치하는 코드에 대한 규칙만 로드 | 디렉토리별 [CLAUDE.md 파일](#layer-claude-md-files-by-directory) |
| 작업하지 않는 패키지의 CLAUDE.md 파일 제외 | [`claudeMdExcludes`](#exclude-irrelevant-claude-md-files) |
| Claude가 빌드 출력, 생성된 코드, 벤더된 종속성 열기 차단 | `permissions.deny`의 [`Read` 거부 규칙](#block-reads-of-generated-and-vendored-code) |
| 파일 스캔 대신 언어 서버를 통해 기호의 정의 또는 호출자 찾기 | [코드 인텔리전스 플러그인](#reduce-file-reads-with-code-intelligence) |
| Claude가 워크트리를 생성할 때 작업에 필요한 디렉토리만 체크아웃 | [`worktree.sparsePaths`](#check-out-only-the-directories-you-need) |
| 같은 세션에서 형제 패키지 또는 다른 저장소 읽기 및 편집 | [`--add-dir`](#grant-access-across-packages-or-repositories) 또는 `additionalDirectories` |
| Claude에 관련이 있을 때만 로드되는 한 영역에 특정한 절차 제공 | 디렉토리별 [skills](#add-per-directory-skills) |
| 많은 디렉토리별 CLAUDE.md 파일을 모든 사람이 설치하는 하나의 규칙 세트로 대체 | 내부 마켓플레이스의 [플러그인](#centralize-conventions-when-layering-stops-scaling) |

> [!TIP]
>
> 모든 저장소에서 컨텍스트를 작게 유지하는 워크플로 기법은 [Claude Code 모범 사례](https://code.claude.com/docs/ko/best-practices.md)를 참조하십시오. 한 가지 예로 파일 읽기가 기본 대화에 포함되지 않도록 [서브에이전트에서 탐색을 실행](https://code.claude.com/docs/ko/best-practices.md#know-what-subagents-cost)하는 방법이 있습니다. 조직의 모든 개발자에게 기본 구성을 배포하려면 [조직을 위해 Claude Code 설정](https://code.claude.com/docs/ko/admin-setup.md)을 참조하십시오.

### 예제 모노레포

이 페이지의 예제는 세 개의 패키지가 있는 모노레포를 참조합니다. 동일한 패턴은 대규모 단일 트리 코드베이스에서 작동합니다. 예제가 `packages/api/`를 사용하는 경우 `src/backend/` 또는 `lib/core/`와 같은 자신의 하위 시스템 디렉토리로 대체하십시오.

```text theme={null}
monorepo/
  CLAUDE.md                     # 루트 지침
  packages/
    api/
      CLAUDE.md                 # API 특정 지침
      .claude/skills/
      src/
    web/
      CLAUDE.md                 # 프론트엔드 특정 지침
      .claude/skills/
      src/
    shared/
      CLAUDE.md                 # 공유 라이브러리 지침
      src/
```

## Claude를 시작할 위치 선택

`claude`를 시작하는 위치는 Claude가 추가 권한 부여 없이 읽고 편집할 수 있는 파일, 시작 시 로드되는 CLAUDE.md 파일, 적용되는 프로젝트 설정을 결정합니다.

| 시작 위치 | 파일 액세스 | 시작 시 로드된 CLAUDE.md | 사용 시기 |
| :- | :- | :- | :- |
| 저장소 루트 | 모든 파일 | 루트만; 하위 디렉토리 파일은 요청 시 로드 | 작업이 여러 패키지 또는 하위 시스템에 걸쳐 있음 |
| 하위 디렉토리 | 더 많은 권한을 부여할 때까지 해당 하위 트리만 | 해당 디렉토리의 모든 상위 항목 | 작업이 하나의 패키지 또는 하위 시스템으로 범위가 지정됨 |

`.claude/settings.json`의 프로젝트 설정은 CLAUDE.md 파일이 상속되는 방식처럼 상위 디렉토리에서 상속되지 않습니다. 세션이 읽는 `.claude/settings.json`이 어느 디렉토리에 있는지는 [Claude Code가 각 파일을 찾는 위치](https://code.claude.com/docs/ko/settings.md#where-claude-code-looks-for-each-file)를 참조하십시오.

아래의 각 섹션은 설정 파일이 저장소 루트에 있는지 시작하는 하위 디렉토리에 있는지, 커밋되는지 로컬로 유지되는지 명시합니다.

## 디렉토리별로 CLAUDE.md 파일 계층화

대규모 코드베이스에서 저장소 루트의 단일 CLAUDE.md는 모든 하위 시스템의 규칙을 다루도록 성장하는 경향이 있어서 현재 작업과 관련 없는 지침에 컨텍스트 비용이 들거나, 너무 일반적이어서 유용하지 않게 됩니다. 지침을 디렉토리별 파일에 분산시키면 Claude는 저장소 전체 규칙과 작업 중인 코드의 규칙만 로드합니다.

Claude Code는 시작 시 작업 디렉터리와 모든 상위 디렉터리의 모든 [CLAUDE.md](https://code.claude.com/docs/ko/memory.md) 파일을 로드한 다음, 각 하위 디렉터리의 파일은 [필요할 때](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load) 로드합니다. 루트 파일은 저장소 전체 규칙을 설정하고 각 하위 디렉터리는 자신의 규칙을 추가합니다.

일반적인 분할은 두 가지 수준입니다:

* **루트 `CLAUDE.md`**: 코딩 표준 및 커밋 규칙과 같이 모든 곳에 적용되는 지침
* **하위 디렉토리별 `CLAUDE.md`**: 해당 영역의 스택에 특정한 규칙. 모노레포에서는 패키지당 하나입니다. 대규모 단일 트리에서는 `src/db/` 또는 `src/api/`와 같은 하위 시스템당 하나입니다.

이 파일들을 저장소에 커밋하여 팀원들이 상속받도록 하십시오. 각 디렉토리의 소유자는 일반적으로 해당 파일을 유지합니다.

이미 체크인된 파일을 축소하려면 [`/doctor` 점검](https://code.claude.com/docs/ko/memory#my-claude-md-is-too-large)을 실행하십시오. 루트 `CLAUDE.md`는 모든 패키지에 적용되는 규칙을 보유합니다:

```markdown CLAUDE.md theme={null}
모노레포 루트가 아닌 패키지 디렉터리에서 패키지 스크립트를 실행하십시오.
커밋 제목 앞에 패키지 이름을 붙이십시오. 예를 들어 `api: add rate limiting`.
packages/*/generated/ 아래의 파일을 편집하지 마십시오. 대신 패키지에서 `npm run codegen`을 실행하십시오.
```

각 하위 디렉토리의 `CLAUDE.md`, 여기서는 `packages/api/CLAUDE.md`는 해당 영역의 규칙을 추가합니다:

```markdown packages/api/CLAUDE.md theme={null}
아무것이든 실행하기 전에 `.env.example`을 `.env`로 복사하십시오. 테스트와 개발 서버는 이것 없이 실패합니다.
Knex 쿼리 빌더로 데이터베이스 쿼리를 작성하십시오. 경로 핸들러에 원시 SQL 문자열을 넣지 마십시오.
마이그레이션이 병합된 후에는 편집하지 마십시오. 대신 새로운 마이그레이션을 추가하십시오.
```

`packages/api/`에서 Claude를 시작하면 `packages/api/CLAUDE.md`와 루트 `CLAUDE.md`를 모두 로드합니다. Claude는 로컬 지침을 저장소 전체 규칙과 함께 보며, `packages/web/`의 지침은 컨텍스트에 없습니다. 비모노레포 트리의 모든 하위 디렉토리에도 동일하게 적용됩니다. 어떤 파일이 로드되었는지 확인하려면 `/context`를 실행하고 **메모리 파일** 아래의 목록을 확인하십시오.

코드베이스와 모델이 변경될 때 파일을 최신 상태로 유지하는 몇 가지 방법:

* **풀 요청에서 검토**: CLAUDE.md 편집을 다른 문서 변경처럼 취급하여 규칙이 코드를 추적하도록 합니다.
* **주요 모델 릴리스 후 재검토**: 이전 모델의 제한을 해결한 지침은 새로운 모델이 경우를 자체적으로 처리하면 오버헤드가 될 수 있습니다. 예를 들어, 단일 파일 리팩토링을 강제하는 규칙은 제한이 없어지면 삭제할 수 있습니다.
* **업데이트를 제안하는 Stop 훅 추가**: [`Stop` 훅](https://code.claude.com/docs/ko/hooks#stop)은 Claude가 응답을 마칠 때 세션 기록의 경로를 받으므로 스크립트는 세션을 검토하고 노출된 간격이 신선할 때 CLAUDE.md 업데이트를 제안할 수 있습니다.

CLAUDE.md 파일이 로드되고 상호작용하는 방식에 대한 자세한 내용은 [메모리 및 프로젝트 지침](https://code.claude.com/docs/ko/memory.md)을 참조하십시오.

### 디렉토리별 CLAUDE.md와 경로 범위 규칙 중 선택

디렉토리별 `CLAUDE.md` 파일과 `.claude/rules/` 아래의 [경로 범위 규칙](https://code.claude.com/docs/ko/memory.md#path-specific-rules) 모두 트리의 일부에 지침을 대상으로 지정할 수 있습니다. 파일이 있는 위치와 로드되는 시기가 다릅니다.

| 접근 방식 | 파일 위치 | 로드 시기 | 사용 시기 |
| :- | :- | :- | :- |
| 디렉터리별 `CLAUDE.md` | 디렉터리 내부, 코드와 함께 | 해당 디렉터리에서 시작할 때 시작 시, 또는 필요할 때 | 디렉터리 소유자가 자신의 규칙을 유지; 지침은 코드와 함께 버전 관리됨 |
| `.claude/rules/`의 경로 범위 규칙 | 저장소 루트의 중앙 `.claude/` | Claude가 규칙의 `paths:` 글로브와 일치하는 파일로 작업할 때 | 모든 규칙을 한 곳에 원하거나, 동일한 규칙이 많은 분산된 경로에 적용됨 |

스킬도 포함하는 비교는 [유사한 기능 비교](https://code.claude.com/docs/ko/features-overview.md#compare-similar-features)를 참조하십시오.

### 관련 없는 CLAUDE.md 파일 제외

저장소 루트에서 Claude를 시작하면 각 하위 디렉터리의 CLAUDE.md는 세션 중에 [필요할 때 로드](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)될 수 있습니다. `claudeMdExcludes` 설정은 경로 또는 글로브 패턴으로 특정 파일을 건너뛰어 로드되지 않도록 합니다.

다른 팀의 패키지, 레거시 코드, 또는 벤더된 하위 트리와 같이 작업하지 않는 디렉토리에 사용하십시오. 제외 목록은 정적이며 작업별 스위치가 아닙니다. 오늘 한 패키지에 집중하고 내일 다른 패키지에 집중하려면 제외를 편집하는 대신 [해당 패키지의 디렉토리에서 Claude를 시작](#choose-where-to-start-claude)하십시오.

이 제외를 자신만을 위해 원하면 설정을 `.claude/settings.local.json`에 넣으십시오. Claude Code는 이를 생성할 때 gitignore합니다. 여기서 직접 생성하므로 gitignore에 추가하십시오. 패턴은 절대 파일 경로와 일치하는 glob 구문을 사용하므로 상대 스타일 패턴을 `**/`로 시작하여 트리의 어디든 일치시킵니다. 아래 예제는 다른 팀이 소유한 패키지를 제외합니다:

```json .claude/settings.local.json theme={null}
{
  "claudeMdExcludes": [
    "**/packages/web/**"
  ]
}
```

이는 해당 패키지 아래의 모든 CLAUDE.md 및 규칙 파일을 건너뜁니다. 루트 CLAUDE.md와 작업하는 패키지는 정상적으로 로드됩니다.

이 패턴은 다른 일반적인 경우를 다룹니다:

* `"**/packages/*/CLAUDE.md"`: 루트를 유지하면서 모든 패키지의 CLAUDE.md를 제외
* `"**/packages/legacy-*/**"`: 글로브와 일치하는 이름의 모든 패키지를 제외하며, 규칙 포함
* `"/home/user/monorepo/legacy/CLAUDE.md"`: 절대 경로로 하나의 특정 파일을 제외

`claudeMdExcludes`는 모든 [설정 범위](https://code.claude.com/docs/ko/settings.md#where-settings-live): 사용자, 프로젝트, 로컬, 또는 관리됨에서 설정할 수 있습니다. 배열은 범위 전체에 병합되므로 팀은 프로젝트 수준 기본값을 설정하면서 개인은 로컬 재정의를 추가할 수 있습니다. 조직에서 [관리형 CLAUDE.md 파일](https://code.claude.com/docs/ko/memory.md#deploy-organization-wide-claude-md)을 배포하는 경우, 어떤 범위에서 패턴을 설정하든 해당 파일과 일치하는 패턴이 있어도 그 파일은 건너뛰지 않습니다.

전체 제외 문서는 [특정 CLAUDE.md 파일 제외](https://code.claude.com/docs/ko/memory.md#exclude-specific-claude-md-files)를 참조하십시오.

## Claude가 읽는 내용 줄이기

지침은 Claude의 컨텍스트에 포함되는 내용의 일부일 뿐입니다. 파일 읽기는 코드베이스와 함께 증가하는 또 다른 비용입니다. 아래 설정은 관련 없는 경로의 읽기를 차단하고 철저한 파일 스캔을 언어 서버 조회로 대체합니다.

### 생성된 코드 및 벤더 코드의 읽기 차단

Claude의 콘텐츠 검색은 기본적으로 `.gitignore`를 준수하므로, `node_modules/`, `dist/`, `build/` 같이 이미 나열된 경로는 추가 구성 없이 검색 결과에서 제외됩니다.

벤더 SDK나 커밋된 생성 코드처럼 체크인된 경로의 경우, `permissions.deny`에 `Read` 거부 규칙을 추가하여 Claude가 해당 파일을 열지 못하도록 차단합니다.

거부 규칙은 저장소에서 작업하는 모든 사람, 본인만, 또는 머신의 모든 세션에 적용될 수 있으며, 이는 규칙을 배치하는 설정 파일에 따라 결정됩니다:

* **저장소에서 작업하는 모든 사람**: 규칙을 `.claude/settings.json`에 커밋합니다. Claude를 시작하는 저장소 루트에 배치하거나, 하위 디렉터리에서 시작하는 경우 각 패키지의 `.claude/`에 배치합니다. 이 페이지의 다른 프로젝트 설정처럼, 이 파일은 상위 디렉터리에서 상속되지 않습니다.
* **본인만**: 저장소 루트의 `.claude/settings.local.json`을 사용합니다. 이 파일은 Claude Code가 [저장소 루트를 사용하지 않는 경우](https://code.claude.com/docs/ko/settings.md#where-claude-code-looks-for-each-file)(예: Windows)를 제외하고, 저장소 내의 모든 CLI 세션에서 시작 디렉터리와 관계없이 로드됩니다.

  예제의 `Read(./**/vendor/**/*)` 같은 상대 패턴은 여전히 저장소 루트가 아닌 [세션의 현재 작업 디렉터리에 고정됩니다](https://code.claude.com/docs/ko/permissions.md#read-and-edit). 하위 디렉터리에서 세션을 시작하는 경우, 이 파일의 규칙을 `Read(//absolute/path/to/repo/**/vendor/**/*)` 같은 `//` 절대 경로로 작성합니다.
* **모든 사람, 모든 세션에서 강제 적용**: [관리 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 규칙을 설정합니다. 사용자 및 프로젝트 설정은 이를 재정의할 수 없습니다.

아래 예제는 빌드 아티팩트와 벤더 SDK를 차단합니다. 디렉터리 패턴은 `/**` 대신 `/**/*`로 끝나므로 각 규칙은 디렉터리 내의 모든 것을 포함하지만 디렉터리 자체는 포함하지 않습니다. Claude는 여전히 `ls dist` 또는 `cd build` 같은 명령으로 해당 디렉터리를 나열하거나 변경할 수 있습니다.

```json .claude/settings.json theme={null}
{
  "permissions": {
    "deny": [
      "Read(./**/dist/**/*)",
      "Read(./**/build/**/*)",
      "Read(./**/*.generated.*)",
      "Read(./**/vendor/**/*)"
    ]
  }
}
```

거부 규칙은 Claude의 기본 제공 파일 도구를 포함합니다. Bash에서는 `cat`, `head`, `grep`, `find` 같이 Claude Code가 인식하는 파일 명령을 포함하며, 거부된 경로가 인수로 나타나거나 `< file` 같은 [리다이렉션](https://code.claude.com/docs/ko/permissions.md#redirections)의 대상인 경우입니다. Claude Code는 또한 기본 제공 Grep 및 Glob 도구의 결과에서 거부된 경로를 제외하기 위해 최선의 노력을 기울입니다. `grep -r` 또는 `find` 같은 Bash 검색을 거부된 파일이 포함된 디렉터리에 대해 수행하면 여전히 출력에 포함됩니다.

거부 규칙은 파일을 직접 여는 하위 프로세스를 포함하지 않습니다. 전체 패턴 구문은 [Read 및 Edit 권한 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 참조하세요.

### 코드 인텔리전스로 파일 읽기 줄이기

대규모 코드베이스에서 기호가 정의되거나 사용되는 위치를 찾는 것은 많은 파일 읽기와 grep 호출이 필요할 수 있습니다. [코드 인텔리전스 플러그인](https://code.claude.com/docs/ko/plugins/code-intelligence.md)은 Claude를 언어 서버에 연결하여 트리를 스캔하는 대신 정의로 이동하고, 참조를 찾고, 타입 오류를 직접 표시할 수 있습니다.

공식 마켓플레이스에는 TypeScript, Python, Go, Rust 및 기타 일반적인 언어용 플러그인이 있습니다. VS Code 확장 프로그램 또는 데스크톱 앱에서는 [플러그인 설치](https://code.claude.com/docs/ko/plugins/install.md#install-a-plugin)의 안내에 따라 플러그인을 설치합니다. 터미널에서는 `claude`를 실행하여 Claude Code를 시작한 다음, 프롬프트에 아래 내용을 입력하여 TypeScript 플러그인을 설치합니다:

```shell theme={null}
/plugin install typescript-lsp@claude-plugins-official
```

설치가 실패하면 Claude Code가 보고하는 메시지와 일치하는지 확인합니다:

* `Marketplace "claude-plugins-official" not found`: `/plugin marketplace add anthropics/claude-plugins-official`로 마켓플레이스를 추가한 후 설치를 다시 시도합니다.
* `Plugin "<name>" not found in marketplace "claude-plugins-official"`: 로컬에 있는 마켓플레이스 카탈로그 사본이 오래되었을 수 있습니다. `/plugin marketplace update claude-plugins-official`로 카탈로그를 새로 고친 후 설치를 다시 시도합니다. 재시도 시에도 같은 메시지가 출력되면 [Plugin not found in marketplace](https://code.claude.com/docs/ko/plugins/troubleshooting.md#plugin-not-found-in-marketplace)를 참조하세요.

본인만 설치하는 대신 저장소의 모든 사람을 위해 플러그인을 활성화하려면, [`enabledPlugins` 프로젝트 설정](https://code.claude.com/docs/ko/settings-reference#plugin-settings)에 추가합니다.

코드 인텔리전스 플러그인은 각 개발자의 머신에 언어의 언어 서버 바이너리가 필요합니다. [각 언어가 필요로 하는 바이너리](https://code.claude.com/docs/ko/plugins/code-intelligence.md)를 참조하세요. 공식 마켓플레이스에서 설치하려면 마켓플레이스가 호스팅되는 GitHub에 대한 네트워크 액세스가 필요합니다. 제한된 네트워크에서는 대신 [내부 Git 호스트 또는 로컬 경로에서 마켓플레이스를 추가](https://code.claude.com/docs/ko/plugins/install.md#add-a-marketplace)합니다.

이는 `claudeMdExcludes`와 위의 `Read` 거부 규칙과 잘 어울립니다. 이들은 관련 없는 콘텐츠를 컨텍스트에서 제외하고, 코드 인텔리전스는 Claude가 정의를 찾기 위해 남은 내용을 읽어야 하는 것을 방지합니다.

## 워크트리 및 파일 액세스 범위 지정

이 설정은 워크트리에서 디스크에 있는 것과 Claude가 시작점 이상으로 읽고 쓸 수 있는 디렉토리를 제어합니다.

### 필요한 디렉토리만 체크아웃

`--worktree` 플래그는 새로운 git 워크트리에서 세션을 시작하여 변경 사항이 주 체크아웃에서 격리되도록 합니다. 기본적으로 전체 저장소를 체크아웃합니다. 대규모 저장소에서 `worktree.sparsePaths` 설정은 git sparse-checkout을 사용하여 나열된 디렉토리와 루트 수준 파일만 디스크에 작성하므로 워크트리가 더 빠르게 시작되고 더 적은 공간을 사용합니다.

이 디렉토리에서 작업하는 모든 사람이 동일한 경로가 필요하면 설정을 `.claude/settings.json`에 커밋하십시오. 자신을 위해 경로를 추가하려면 `.claude/settings.local.json`을 사용하십시오. 목록은 범위 전체에 병합되므로 로컬 파일은 커밋된 목록에 경로를 추가할 수 있지만 제거할 수는 없습니다.

이 페이지의 JSON 예제는 한 번에 하나의 설정을 보여줍니다. `.claude/settings.json`이 이미 위의 `permissions.deny` 규칙과 같은 다른 키를 포함하고 있으면 파일을 바꾸는 대신 `worktree` 키를 그 옆에 추가하십시오. [모두 함께 배치](#put-it-together)는 결합된 결과를 보여줍니다.

아래 예제는 커밋된 파일을 보여줍니다:

```json .claude/settings.json theme={null}
{
  "worktree": {
    "sparsePaths": [
      ".claude",
      "packages/api",
      "packages/shared"
    ]
  }
}
```

Claude가 워크트리를 생성할 때 전체 트리 대신 `.claude/`, `packages/api/`, `packages/shared/`만 체크아웃합니다. `sparsePaths`의 경로는 Claude를 시작하는 하위 디렉토리에 관계없이 저장소 루트에 상대적입니다. 패키지 루트뿐만 아니라 모든 디렉토리 경로가 여기에서 작동합니다.

이는 특히 [서브에이전트 워크트리 격리](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees)에 유용합니다. 서브에이전트는 하위 작업을 위해 생성된 병렬 Claude 인스턴스이며, 워크트리에서 실행되는 각 인스턴스는 전체 트리 대신 경량 체크아웃을 받습니다. 세션의 모든 워크트리는 동일한 `sparsePaths`를 공유하므로 한 서브에이전트가 `packages/api/`를 필요로 하고 다른 하나가 `packages/web/`을 필요로 하면 둘 다 나열하십시오.

`sparsePaths`에 개별 파일이 아닌 디렉토리를 나열하십시오. `package.json`, `tsconfig.base.json`, 잠금 파일과 같은 루트 수준 파일은 나열한 디렉토리와 함께 항상 체크아웃됩니다. 루트 수준 디렉토리는 그렇지 않으므로 워크트리 내에서 저장소 루트의 `.claude/settings.json` 또는 `.claude/rules/`를 사용 가능하게 하려면 목록에 `.claude`를 포함하십시오. 프로젝트 스킬, 에이전트, 명령에 대해서는 [워크트리가 주 체크아웃과 공유하는 것](https://code.claude.com/docs/ko/worktrees.md#what-worktrees-share-with-the-main-checkout)을 참조하십시오.

Sparse checkout을 사용하려면 git이 sparse 워크트리가 존재하는 동안 저장소의 공유 `.git/config`에서 `extensions.worktreeConfig`를 활성화해야 합니다. Claude Code는 마지막 워크트리가 제거된 후 해당 항목을 제거하지만, Claude Code가 추가한 경우에만 제거합니다. 직접 설정한 값은 절대 제거하지 않습니다.

`node_modules`와 같은 대규모 디렉토리를 워크트리 전체에 중복되지 않도록 하려면 동일한 `.claude/settings.json`에서 `sparsePaths`를 `symlinkDirectories`와 쌍으로 지정하십시오:

```json .claude/settings.json theme={null}
{
  "worktree": {
    "sparsePaths": [
      ".claude",
      "packages/api",
      "packages/shared"
    ],
    "symlinkDirectories": [
      "node_modules"
    ]
  }
}
```

이는 각 워크트리의 `node_modules/`에서 주 저장소의 복사본으로 다시 심볼릭 링크를 생성하여 디스크에 중복되지 않도록 합니다.

> [!NOTE]
>
> `sparsePaths` 및 `symlinkDirectories` 설정은 워크트리가 생성되기 전에 시작 디렉토리에서 읽습니다. 생성 후 세션의 작업 디렉토리는 시작한 하위 디렉토리가 아닌 워크트리 루트입니다. 따라서 워크트리 내의 프로젝트 설정은 워크트리 루트의 `.claude/settings.json`, 저장소 루트 파일의 체크아웃된 복사본에서 로드됩니다. 권한 규칙 또는 훅과 같이 워크트리 내에서 필요한 다른 설정을 저장소 루트의 `.claude/settings.json`에 넣으십시오.

전체 워크트리 설정 참조는 [워크트리 설정](https://code.claude.com/docs/ko/settings-reference.md#worktree)을 참조하십시오.

### 패키지 또는 저장소 전체에 액세스 권한 부여

이 섹션은 하위 디렉토리에서 Claude를 시작하거나 작업이 여러 체크아웃에 걸쳐 있을 때 적용됩니다. 단일 대규모 트리에서 저장소 루트에서 시작하면 Claude는 이미 모든 파일에 액세스할 수 있으므로 이를 건너뛸 수 있습니다.

`packages/api/`에서 Claude를 시작하면 해당 디렉터리 내의 파일을 읽고 쓸 수 있습니다. 작업이 패키지 전체에 걸쳐 있으면, 예를 들어 `api`와 `web` 모두 가져오는 공유 타입을 업데이트하면 형제 디렉터리에 액세스 권한을 부여해야 합니다. 동일한 메커니즘은 별도로 체크아웃된 저장소에 액세스 권한을 부여합니다.

`.claude/settings.json`의 `additionalDirectories` 설정은 작업 디렉토리 외부의 디렉토리에 Claude 액세스를 제공합니다. 아래 예제는 두 개의 형제 패키지에 액세스 권한을 부여합니다:

```json packages/api/.claude/settings.json theme={null}
{
  "permissions": {
    "additionalDirectories": [
      "../shared",
      "../web"
    ]
  }
}
```

상대 경로는 Claude를 시작하는 디렉토리에 대해 해석됩니다. 이 구성으로 Claude는 `packages/api/`에서 작업하면서 `packages/shared/` 및 `packages/web/`의 파일을 읽고 편집할 수 있습니다.

설정을 편집하지 않고 런타임에 Claude를 시작할 때 `--add-dir`을 전달하여 디렉토리에 액세스 권한을 부여할 수도 있습니다:

```bash theme={null}
claude --add-dir ../shared
```

디렉토리를 추가하는 방법에 관계없이 Claude는 파일을 읽고 편집할 수 있습니다. 디렉토리의 CLAUDE.md, `.claude/rules/` 파일, 스킬도 로드되는지는 추가 방법에 따라 다릅니다:

| 추가 방법 | CLAUDE.md 및 규칙 로드 | 스킬 로드 |
| :- | :- | :- |
| `additionalDirectories` 설정 | 절대 안 함 | 절대 안 함 |
| `--add-dir` 플래그 또는 `/add-dir` 명령 | 아래 환경 변수만 | 예 |

`--add-dir` 또는 `/add-dir`으로 추가된 디렉토리에서 CLAUDE.md 및 규칙 파일을 로드하려면 `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` 환경 변수를 설정하십시오:

```bash theme={null}
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared
```

환경 변수는 `additionalDirectories` 설정에 나열된 디렉토리에는 영향을 주지 않습니다. 자세한 내용은 [추가 디렉토리에서 로드](https://code.claude.com/docs/ko/memory.md#load-from-additional-directories)를 참조하십시오.

이 영역의 모든 사람이 필요로 하는 형제 디렉토리의 경우 `additionalDirectories`를 `.claude/settings.json`에 커밋하십시오. 개인 선택 또는 일회성 액세스의 경우 `.claude/settings.local.json`을 사용하거나 시작 시 `--add-dir`을 전달하십시오.

## 디렉터리별 스킬 추가

모든 하위 디렉터리는 자체 스택으로 범위가 지정된 [스킬](https://code.claude.com/docs/ko/skills.md)을 정의할 수 있습니다. 스킬은 Claude가 관련이 있다고 판단할 때 필요에 따라 로드됩니다.

스킬은 해당 디렉터리 내부의 `.claude/skills/` 아래에 위치합니다. 해당 영역의 코드와 함께 커밋하면 저장소를 클론하는 모든 사람이 스킬을 사용할 수 있습니다. 모노레포에서는 패키지마다 하나의 스킬 세트를 둘 수 있습니다. 대규모 단일 트리 코드베이스에서는 `src/db/.claude/skills/`와 같이 서브시스템마다 하나의 세트를 둡니다.

하위 디렉터리 안에 스킬 디렉터리를 만듭니다:

```bash theme={null}
mkdir -p packages/api/.claude/skills/api-testing
```

그런 다음 해당 디렉터리 안에 `SKILL.md`를 작성합니다. 여기서는 `packages/api/.claude/skills/api-testing/SKILL.md`입니다. 이 예시는 Claude에게 API 패키지의 테스트 패턴을 알려줍니다:

```markdown packages/api/.claude/skills/api-testing/SKILL.md theme={null}
---
name: api-testing
description: Testing patterns for the API package. Use when writing or modifying tests in packages/api/.
---

## Test structure

Tests are in `src/__tests__/` mirroring the `src/` directory structure.
Each route file has a corresponding `.test.ts` file.

## Running tests

- All tests: `npm test`
- Single file: `npm test -- src/__tests__/routes/users.test.ts`
- Watch mode: `npm test -- --watch`

## Test utilities

- `src/__tests__/helpers/db.ts`: provides `setupTestDb()` and `teardownTestDb()` for database tests
- `src/__tests__/helpers/auth.ts`: provides `createTestUser()` and `getAuthToken()` for authenticated endpoints

## Patterns

- Use `supertest` for HTTP assertions, not raw fetch
- Always wrap database tests in a transaction that rolls back
- Mock external services in `src/__tests__/mocks/`
```

다른 하위 디렉터리도 같은 방식으로 다른 스킬을 보유합니다. `packages/web/.claude/skills/component-patterns/`는 테스트 대신 프런트엔드의 컴포넌트 규칙을 설명합니다. Claude가 `packages/api/`의 파일에서 작업할 때는 api-testing 스킬을 로드합니다. `packages/web/`에서 작업할 때는 component-patterns를 로드합니다.

배치 위치 대신 파일 패턴으로 스킬의 범위를 지정할 수도 있습니다. [`paths` frontmatter 필드](https://code.claude.com/docs/ko/skills#frontmatter-reference)는 glob 패턴을 받으며, Claude는 일치하는 파일로 작업할 때만 스킬을 자동으로 로드합니다. 저장소 루트의 `.claude/skills/`에 있지만 특정 파일에만 적용되는 스킬에 이 방법을 사용합니다. 예를 들어 `**/migrations/**`로 범위가 지정된 데이터베이스 마이그레이션 스킬이 있습니다.

스킬 생성 및 구성에 대한 자세한 내용은 [스킬](https://code.claude.com/docs/ko/skills.md)을 참조하십시오.

### 스킬을 찾기 쉽게 유지하기

스킬이 여러 디렉터리에 분산되어 있으면 Claude가 선택할 목록이 커질 수 있습니다. Claude는 발견된 모든 스킬의 이름과 설명을 읽어 스킬을 고르며, 선택된 스킬의 전체 내용만 컨텍스트에 로드됩니다. 이 섹션에서는 그 목록을 작게 유지하는 방법을 다룹니다.

범위에 포함되는 스킬은 Claude를 시작하는 위치에 따라 달라집니다:

* **`packages/api/`와 같은 하위 디렉터리에서 시작하는 경우**: 해당 디렉터리, 저장소 루트까지의 모든 상위 디렉터리, 그리고 사용자 및 엔터프라이즈 수준의 스킬
* **저장소 루트에서 시작하는 경우**: 루트 스킬과 함께, Claude가 세션 중에 접근하는 모든 하위 디렉터리의 스킬이 로드되며, 이는 수백 개까지 누적될 수 있습니다
* **[`--add-dir`](#grant-access-across-packages-or-repositories)로 형제 디렉터리를 추가한 경우**: 해당 형제 디렉터리의 스킬도 로드됩니다. `additionalDirectories` 설정은 파일 접근 권한만 부여하며 스킬은 로드하지 않습니다

이름은 항상 로드되지만, [스킬이 많을 경우 일부 스킬은 설명이 완전히 사라지며](https://code.claude.com/docs/ko/skills.md#skill-descriptions-are-cut-short), 이로 인해 Claude가 스킬의 적용 여부를 판단하는 데 사용하는 키워드가 제거될 수 있습니다. 설명은 짧게 유지하고, "`packages/api/`에서 테스트를 작성하거나 수정할 때"처럼 요청에 포함될 법한 단어로 시작하십시오.

PR 규칙이나 배포 체크리스트처럼 여러 디렉터리가 공유하는 스킬은 저장소 루트의 `.claude/skills/`에 배치하여 어느 시작 디렉터리에서든 로드되도록 합니다. 공유 스킬에 자체 버전 기록이 필요하거나 여러 저장소에서 작동해야 하는 경우에는 대신 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)으로 패키징합니다. 플러그인 스킬은 `plugin-name:skill-name` 네임스페이스를 사용하므로 디렉터리별 스킬과 충돌하지 않습니다. 플랫폼 팀은 한곳에서 이를 버전 관리하고 업데이트할 수 있습니다.

사용되지 않는 스킬을 찾으려면 OpenTelemetry [로그 내보내기](https://code.claude.com/docs/ko/monitoring-usage.md)를 활성화하고 `OTEL_LOG_TOOL_DETAILS=1`을 설정하여 스킬 이름이 가려지지 않고 그대로 기록되도록 합니다. [`skill_activated` 이벤트](https://code.claude.com/docs/ko/monitoring-usage#skill-activated-event)는 모든 호출을 `skill.name` 속성에 기록하고, `invocation_trigger`는 명령, Claude, 중첩된 스킬 중 무엇이 호출했는지를 기록하므로 어떤 스킬을 통합하거나 폐기할지 파악할 수 있습니다.

## 계층화가 더 이상 확장되지 않을 때 규칙 중앙화하기

코드베이스가 커지면 디렉터리별 CLAUDE.md 파일을 관리하기 어려워질 수 있습니다. 규칙이 점차 어긋나고, 파일은 오래된 상태로 방치되며, 루트를 책임지는 사람이 없어집니다. 이 문제를 해결하는 일은 일반적으로 각자의 영역에서 작업하는 개별 개발자가 아니라 저장소의 Claude Code 설정을 유지 관리하는 팀이 맡습니다.

규칙과 참고 콘텐츠를 항상 로드되는 CLAUDE.md에서 꺼내 필요할 때 로드되는 메커니즘으로 옮기십시오.

* [스킬](https://code.claude.com/docs/ko/skills.md): 작업과 관련이 있을 때만 Claude가 로드하는 참고 자료
* [플러그인](https://code.claude.com/docs/ko/plugins/overview.md): 플랫폼 팀이 중앙에서 소유하고 [관리형 설정을 통해 모든 사용자에게 설치](https://code.claude.com/docs/ko/plugins/org.md#pre-install-and-require-plugins)할 수 있는, 스킬, 훅, 명령의 버전 관리 번들
* [MCP 서버](https://code.claude.com/docs/ko/mcp.md): 조직에서 이미 저장소에 대한 코드 검색 또는 RAG 인덱스를 운영하고 있다면, 이를 MCP 도구로 노출하여 Claude가 파일을 직접 읽는 대신 해당 도구에 쿼리하도록 합니다

플랫폼 팀이 이러한 항목을 중앙에서 적용하는 방법은 [서버 관리형 또는 엔드포인트 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md#choose-between-server-managed-and-endpoint-managed-settings)을 참조하십시오.

### 세션 시작 시 적절한 플러그인 추천하기

규칙이 플러그인에 들어가고 나면, 트리에서 익숙하지 않은 부분에서 Claude를 시작하는 팀원은 해당 영역의 소유자가 어떤 플러그인을 유지 관리하는지 알 수 있는 단서가 없습니다. [`SessionStart` 훅](https://code.claude.com/docs/ko/hooks#sessionstart)으로 이 공백을 메울 수 있습니다. Claude Code는 훅이 stdout으로 출력하는 일반 텍스트를 첫 번째 프롬프트 전에 Claude의 컨텍스트에 추가하기 때문입니다.

예를 들어, [훅 입력](https://code.claude.com/docs/ko/hooks.md#common-input-fields)에서 실행 디렉터리를 읽고, 저장소에 커밋된 경로-플러그인 매핑에서 이를 조회한 다음, Claude가 첫 번째 응답에서 전달할 추천 내용을 출력하는 스크립트를 작성할 수 있습니다. 훅을 작성하고 등록하는 방법은 [훅으로 작업 자동화하기](https://code.claude.com/docs/ko/hooks-guide.md)를 참조하십시오.

## 모두 함께 사용

아래의 결합된 구성은 모노레포 레이아웃을 사용합니다. 동일한 파일은 대규모 단일 트리의 모든 하위 디렉토리에서 작동합니다. 각 하위 디렉토리의 `.claude/settings.json`은 루트 파일에 계층화되지 않고 자체 포함되어야 합니다.

예제는 `worktree`, `additionalDirectories`, `.claude/settings.json`의 `Read` 거부 규칙을 커밋하여 `packages/api/`의 모든 개발자가 동일한 형제 액세스, 스파스 경로, 제외를 받도록 합니다. 아래 파일은 `packages/api/`에 대한 커밋된 영역별 설정입니다:

```json packages/api/.claude/settings.json theme={null}
{
  "worktree": {
    "sparsePaths": [
      ".claude",
      "packages/api",
      "packages/shared"
    ],
    "symlinkDirectories": [
      "node_modules"
    ]
  },
  "permissions": {
    "additionalDirectories": [
      "../shared"
    ],
    "deny": [
      "Read(./**/dist/**/*)",
      "Read(./**/build/**/*)"
    ]
  }
}
```

이 세션은 `packages/api/`에서 시작되므로 형제 패키지의 CLAUDE.md 파일은 이미 범위를 벗어났으므로 `claudeMdExcludes`가 여기에 필요하지 않습니다. 루트에서도 세션을 시작하면 저장소 루트의 `.claude/settings.local.json`에 추가하십시오.

`additionalDirectories` 항목은 `packages/api/`에서 직접 Claude를 시작할 때 적용됩니다. 이 세션에서 생성된 워크트리 내에서 작업 디렉토리는 워크트리 루트이므로 이 설정 파일은 로드되지 않습니다. 형제 패키지는 이미 워크트리 내에서 도달 가능하지만 거부 규칙은 워크트리 세션이 선택하도록 저장소 루트의 `.claude/settings.json`에 두 번째 복사본이 필요합니다. [워크트리 설정 참고](#check-out-only-the-directories-you-need)에서 설명합니다:

```json .claude/settings.json theme={null}
{
  "permissions": {
    "deny": [
      "Read(./**/dist/**/*)",
      "Read(./**/build/**/*)"
    ]
  }
}
```

설정 후 저장소는 이 레이아웃을 가집니다:

```text theme={null}
monorepo/
  CLAUDE.md
  .claude/settings.json                           # 워크트리 세션을 위한 거부 규칙
  packages/
    api/
      CLAUDE.md
      .claude/settings.json                       # worktree, additionalDirectories, 거부 규칙
      .claude/skills/api-testing/SKILL.md
    web/
      CLAUDE.md
      .claude/skills/component-patterns/SKILL.md
    shared/
      CLAUDE.md
```

이 설정으로 `packages/api/`에서 Claude를 시작하면:

* 루트 CLAUDE.md와 `packages/api/CLAUDE.md`를 로드하고, `packages/web/CLAUDE.md`를 건너뜁니다.
* `packages/api/` 및 `packages/shared/`의 파일을 읽고 편집할 수 있습니다.
* `packages/api/`의 `dist/` 및 `build/` 아래 빌드 출력 읽기를 건너뜁니다.
* 요청 시 api-testing 스킬을 사용할 수 있습니다.
* `.claude/`, `packages/api/`, `packages/shared/`, 루트 수준 파일을 포함하는 워크트리를 생성하고, 루트 설정 파일에서 워크트리 전체에 거부 규칙을 적용합니다.

## 패키지에 걸친 변경 범위 지정 및 계획

위의 구성은 Claude가 보는 것을 제어합니다. 단일 변경이 여러 패키지에 영향을 미칠 때, 예를 들어 공유 타입을 업데이트하고 이를 사용하는 모든 호출 사이트를 업데이트할 때, 작업의 범위 지정 및 순서 지정 방식도 결과에 영향을 미칩니다.

두 가지 기법은 패키지 간 변경을 일관되게 유지하는 데 도움이 됩니다:

* **전체 변경을 한 세션에서 Claude에 제공**: 공유 편집과 호출 사이트를 함께 전달하면 각 편집 뒤의 결정이 일관되게 유지되어 패키지별로 다시 도출하지 않습니다
* **편집 전에 계획**: [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서 먼저 계획하면 Claude가 계획을 파일에 작성합니다. 긴 패키지 간 세션은 진행 중에 [컨텍스트를 압축](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)합니다. Claude Code는 각 압축 후 계획 파일을 다시 주입하므로, 대화 기록이 없을 수 있는 곳에서도 계획이 유지됩니다

## 다음 단계

이 구성이 준비되면 이를 개선할 수 있습니다:

* [훅](https://code.claude.com/docs/ko/hooks-guide.md)을 사용하여 Claude가 파일을 편집한 후 디렉토리별 린터 또는 타입 체커 실행
* [비용 효과적으로 관리](https://code.claude.com/docs/ko/costs.md)를 검토하여 코드베이스 크기가 토큰 사용에 어떻게 영향을 미치는지, 더 넓은 배포 전에 지출 한도를 설정하는 방법을 이해합니다.
* Claude 블로그의 [Claude Code가 대규모 코드베이스에서 어떻게 작동하는지](https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start)를 읽어 조직 배포 패턴 및 이 페이지의 저장소별 구성 위에 있는 소유권 모델을 확인합니다.
