> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 설정 파일 및 우선순위

> Claude Code 설정을 변경하고, 키가 속할 범위를 선택하고, 변경을 확인하고, 키가 여러 위치에 설정되어 있을 때 Claude Code가 사용하는 값을 알아봅니다.

설정은 Claude Code의 동작을 변경하는 JSON 키입니다: 시작할 모델, 묻지 않고 실행할 수 있는 것, 읽을 수 없는 파일, 터미널에서의 모양, 조직이 적용하는 것입니다.

> [!TIP]
>
> 특정 키를 찾으려면 [모든 설정](https://code.claude.com/docs/ko/settings-reference.md)으로 이동하세요. 여기에는 설정한 파일, 기본값, 예제가 있는 모든 키가 나열됩니다.

Claude Code는 `~/.claude/settings.json`과 같은 JSON 설정 파일에서 설정을 읽습니다. 여러 위치에서 찾으며, [읽는 파일이 설정이 누구에게 적용되는지 결정합니다](#settings-files-and-who-they-affect). 이 페이지에서는 이러한 파일을 다룹니다: 설정을 어느 파일에 넣을지, 설정을 변경하고 적용되었는지 확인하는 방법, 동일한 키가 여러 파일에 설정되어 있을 때 Claude Code가 사용하는 값입니다. [권한 구성](https://code.claude.com/docs/ko/permissions.md)에서는 Claude Code가 묻지 않고 실행할 수 있는 것과 `allow`, `ask`, `deny` 규칙을 작성하는 방법을 다룹니다.

> [!NOTE]
>
> 이 페이지는 머신에서 실행되는 Claude Code를 다룹니다: 터미널, [VS Code](https://code.claude.com/docs/ko/vs-code.md) 및 [JetBrains](https://code.claude.com/docs/ko/jetbrains.md) 확장, [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md)은 모두 동일한 설정 파일을 읽습니다. [Claude Code on the web](https://code.claude.com/docs/ko/claude-code-on-the-web.md)의 클라우드 세션은 다른 머신에서 실행되며 일부만 읽습니다. [클라우드 세션의 설정](#settings-in-cloud-sessions)을 참조하세요.

## 설정 파일과 적용 대상

Claude Code는 네 개의 파일에서 설정을 읽으며, 조직은 claude.ai 콘솔에서 관리형 설정을 전달할 수도 있습니다. 각 소스에는 범위가 있습니다. 범위란 해당 소스에 저장된 설정이 적용되는 사람과 프로젝트의 집합으로, 본인에게만 적용될 수도 있고, 프로젝트의 모든 사람에게 적용될 수도 있으며, 조직의 모든 사람에게 적용될 수도 있습니다.

| 범위 | 파일 | 적용 대상 | 용도 |
| :- | :- | :- | :- |
| 사용자 | `~/.claude/settings.json` | 이 머신의 모든 프로젝트에서 본인 | 개인 환경설정: 테마, 편집기 모드, 기본 모델, 본인의 권한 규칙 |
| 공유 프로젝트 | `.claude/settings.json` | 이 파일이 포함된 폴더에서 작업하는 모든 사람. git 저장소에서는 팀원이 받을 수 있도록 커밋합니다 | 팀 권한, 훅, 플러그인, 프로젝트에 필요한 환경 변수 |
| 프로젝트 로컬 | `.claude/settings.local.json` | 이 프로젝트 하나에서만 본인. Claude Code가 파일을 생성할 때는 git에서 제외하지만, 직접 생성한 경우에는 `.gitignore`에 직접 추가해야 합니다 | 한 프로젝트에 대한 개인 재정의, 공유 전 테스트 |
| 관리형 | `managed-settings.json` 및 기타 [관리형 소스](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms) | 조직이 배포한 모든 사람. 무엇이 이를 재정의할 수 있는지는 [설정 우선순위](#settings-precedence)에서 설명합니다 | 보안 정책 및 규정 준수 요구 사항 |

파일 열에서 `~/.claude`는 홈 디렉터리의 `.claude` 폴더를 의미하며, 앞에 아무것도 없는 `.claude`는 프로젝트 내부의 `.claude` 폴더를 의미합니다.

### 설정 파일별 범위 비교

머신에 `website/`, `api/`, `acme-app/` 세 개의 프로젝트가 있고, 팀원이 `acme-app/`의 자체 클론을 가지고 있으며, `acme-app/`에서 [클라우드 세션](#settings-in-cloud-sessions)을 시작한다고 가정해 보겠습니다.

아래 그래픽은 각 폴더에서 Claude Code를 시작할 때 어떤 폴더에 설정이 적용되는지 보여줍니다. 설정 파일을 클릭하면 해당 파일이 적용되는 폴더를 확인할 수 있습니다.

Settings file

Your machine

A teammate’s machine

A cloud session

* **`~/.claude/settings.json`**: 본인 머신의 모든 프로젝트에 적용되며, 팀원의 머신이나 클라우드 세션에는 적용되지 않습니다
* **`acme-app/.claude/settings.json`**: 본인의 `acme-app/`에 적용됩니다. 파일을 버전 관리에 커밋해야만 팀원의 클론과 클라우드 세션에 적용됩니다. 커밋하기 전까지는 디스크에 있는 다른 파일과 다를 바 없으며 다른 사람은 이 파일을 갖고 있지 않습니다
* **`acme-app/.claude/settings.local.json`**: 본인의 `acme-app/`에만 적용됩니다. Claude Code는 이 파일을 처음 작성할 때 전역 git 제외 목록에 추가하므로 커밋에 포함되지 않습니다. 파일을 직접 생성한 경우에는 [`.gitignore`에 직접 추가](#keep-personal-settings-out-of-a-repository)해야 합니다
* **관리형 설정**: `managed-settings.json` 파일, MDM 정책, claude.ai 콘솔의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md) 중 어떤 형태이든, 조직이 배포한 모든 머신 또는 조직 계정으로 로그인한 모든 머신의 모든 프로젝트에 적용됩니다. 클라우드 세션에는 서버 관리형 설정만 적용됩니다

### 설정 파일 찾기 또는 생성하기

Claude Code를 설치해도 설정 파일은 생성되지 않습니다. 머신이나 프로젝트에 이미 설정 파일이 있다면 다음 소스 중 하나에서 온 것입니다.

* **관리형**: 조직이 배포합니다. 사용자가 직접 생성하거나 편집하지 않습니다.
* **공유 프로젝트**: 이미 Claude Code를 사용하는 프로젝트에는 커밋된 파일이 있을 수 있습니다. 없다면 프로젝트 폴더의 `.claude/settings.json`에 생성합니다.
* **사용자** 및 **프로젝트 로컬**: 직접 생성하거나 Claude Code가 생성하도록 할 수 있습니다. Claude Code는 테마처럼 사용자 설정에 저장되는 `/config` 메뉴 옵션을 처음 변경할 때 `~/.claude/settings.json`을 작성하고, Bash 명령에 대해 "Yes, and don't ask again"을 선택하는 것처럼 권한 프롬프트에서 지속적인 승인을 처음 제공할 때 `.claude/settings.local.json`을 작성합니다. **Show tips**를 포함한 일부 `/config` 옵션은 사용자 파일 대신 `.claude/settings.local.json`에 저장됩니다.

> [!NOTE]
>
> Windows에서 `~/.claude`는 `%USERPROFILE%\.claude`를 의미합니다. 홈 디렉터리 파일을 다른 위치에 보관하려면 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)을 설정합니다. 그러면 Claude Code가 설정, 세션 기록, 플러그인을 해당 위치에 저장합니다.

Claude Code는 자체적으로 작성하는 다섯 번째 파일인 [`~/.claude.json`](https://code.claude.com/docs/ko/claude-directory#ce-claude-json)도 유지하며, 이 파일은 편집할 필요가 없습니다. 이 파일에는 계정 정보, [MCP 서버](https://code.claude.com/docs/ko/mcp.md) 구성, 신뢰 결정과 같은 프로젝트별 상태, 그리고 `/config`가 대신 작성하는 [전역 구성 키](https://code.claude.com/docs/ko/settings-reference.md#global-config-settings)가 저장됩니다.

### 팀과 설정 공유하기

`.claude/settings.json`을 커밋하면 저장소를 클론하는 모든 사람이 동일한 권한, 훅, 플러그인을 받습니다. 각 팀원은 여전히 자신의 `.claude/settings.local.json`에서 이를 개인적으로 재정의할 수 있으므로 개인 예외 사항은 커밋할 필요가 없습니다. 완전한 팀 파일 예시는 [팀의 공유 설정](https://code.claude.com/docs/ko/settings-example.md#a-teams-shared-settings)을 참조하세요.

커밋한 내용 중 일부는 각 팀원이 [폴더를 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)할 때까지 적용이 보류되며, 몇몇 키는 저장소 파일에서는 전혀 적용되지 않습니다. 두 경우 모두 [적용되지 않는 설정 문제 해결](#common-cases)에서 다룹니다.

### 개인 설정을 저장소에서 제외하기

팀원의 설정은 변경하지 않고 한 프로젝트에서 본인의 설정만 변경하려면 프로젝트 내부의 `.claude/settings.local.json`에 저장합니다. Claude Code는 이 파일을 커밋된 `.claude/settings.json`보다 우선하여 적용하므로, 팀 파일에서 `"model": "claude-sonnet-5"`를 설정하고 있고 본인은 Opus를 사용하고 싶다면 로컬 파일에 `"model": "claude-opus-5-5"`를 넣으면 본인의 세션만 변경됩니다.

Claude Code는 이 파일에 직접 작성하기도 하고, 커밋에서 제외하며, 신뢰 단계 없이 허용 규칙을 적용합니다.

* **Claude Code도 이 파일에 작성합니다.** Claude가 Bash 명령 실행 권한을 요청할 때 "Yes, and don't ask again"을 선택하면 Claude Code는 해당 [권한 승인](https://code.claude.com/docs/ko/permissions.md#permission-system)을 이 파일에 `allow` 규칙으로 저장합니다.
* **직접 생성한 경우가 아니라면 gitignore에 직접 추가할 필요가 없습니다.** Claude Code가 아직 이 파일을 무시하지 않는 git 저장소에서 처음으로 파일을 작성할 때, 전역 git 제외 파일에 `**/.claude/settings.local.json`을 추가하므로 모든 저장소에서 이 파일이 커밋에 포함되지 않습니다. 전역 git 구성에서 `core.excludesFile`을 절대 경로나 `~`로 시작하는 경로로 설정한 경우 해당 파일이 제외 파일이 되며, 그렇지 않으면 `$XDG_CONFIG_HOME/git/ignore`, 또는 `XDG_CONFIG_HOME`이 설정되지 않은 경우 `~/.config/git/ignore`가 됩니다. 파일을 직접 생성했고 Claude Code가 아직 파일에 작성하지 않았다면 `.gitignore`에 직접 추가합니다.
* **파일이 추적되지 않는 동안에는 허용 규칙이 신뢰를 기다리지 않습니다.** 이 파일은 저장소가 아닌 본인의 것이므로, Claude Code는 커밋된 파일에 요구하는 [워크스페이스 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust) 단계 없이 `allow` 규칙을 적용합니다. 파일이 git에서 추적되는 경우에는 신뢰 단계가 이 파일에도 적용됩니다. [로컬 설정 파일에 신뢰가 필요한 경우](https://code.claude.com/docs/ko/permissions.md#when-your-local-settings-file-needs-trust)를 참조하세요.

#### git 저장소에서 Claude Code가 로컬 파일을 보관하는 위치

Claude가 Bash 명령 실행 권한을 요청할 때 "Yes, and don't ask again"을 선택하면 Claude Code는 해당 승인을 `.claude/settings.local.json`에 `allow` 규칙으로 저장합니다. git 저장소의 하위 디렉터리에서 Claude Code를 시작하면 저장소 루트에 있는 해당 파일을 읽고 쓰며, 승인을 저장소 전체에 적용합니다. [워크트리](https://code.claude.com/docs/ko/worktrees.md)에서는 메인 체크아웃 루트에 있는 파일을 사용합니다.

루트 위치에는 두 가지 규칙이 적용됩니다.

* **파일이 대신 `.claude/settings.json`과 같은 위치에 있는 경우**: git 저장소 외부인 경우, 저장소 루트가 홈 디렉터리인 경우, Windows인 경우, 또는 저장소 루트나 그 `.git` 또는 `.claude` 항목의 소유자가 본인 사용자가 아닌 경우입니다.
* **파일 내 경로는 저장소 루트를 기준으로 하지 않습니다**: `/`로 시작하는 권한 규칙이나 상대 샌드박스 경로는 대신 [세션의 기본 작업 디렉터리를 기준으로](https://code.claude.com/docs/ko/permissions.md#read-and-edit) 합니다.

v2.1.211 이전에는 Claude Code가 시작 디렉터리에 파일을 보관했습니다. 이전 버전이 그곳에 남긴 파일도 루트 파일과 함께 계속 읽으며, 두 파일이 같은 키를 설정하는 경우 루트의 값이 적용되고, 권한 규칙은 두 파일 모두의 것이 적용됩니다. Agent SDK의 [`resolveSettings()`](https://code.claude.com/docs/ko/agent-sdk/typescript#resolvesettings) 헬퍼는 항상 시작 디렉터리에서 파일을 읽습니다.

Claude Code는 공유 `.claude/settings.json`을 세션의 [기본 작업 디렉터리](https://code.claude.com/docs/ko/permissions.md#working-directories)에서 읽으므로, 저장소 루트에 커밋된 파일을 사용하려면 그곳에서 Claude Code를 시작합니다. [`/cd`로 세션을 이동](https://code.claude.com/docs/ko/permissions#move-the-session-to-another-directory)한 후에는 Claude Code가 두 프로젝트 파일을 모두 새 디렉터리에서 읽으며, 로컬 파일의 위치는 동일한 규칙에 따라 정해집니다. 이동한 디렉터리에서 파일을 읽으려면 Claude Code v2.1.246 이상이 필요합니다. 데스크톱 앱에서 시작하는 워크트리 세션에 대해서는 [워크트리가 메인 체크아웃과 공유하는 항목](https://code.claude.com/docs/ko/worktrees.md#what-worktrees-share-with-the-main-checkout)을 참조하세요.

### 조직이 적용하는 설정 확인하기

조직이 Claude Code를 관리하는 경우 일부 설정은 조직이 결정하며, 본인 파일에 무엇을 넣더라도 변경되지 않습니다. 어떤 설정인지 확인하려면 `/status`를 실행합니다. `Setting sources` 줄에 본인에게 적용되는 관리형 소스가 표시됩니다. 관리형 설정은 이 머신에서 Claude Code가 실행되는 모든 곳에 적용됩니다. 로컬 관리자 권한과 Claude Code 이외의 도구에 대해서는 [개발자가 변경할 수 있는 항목](https://code.claude.com/docs/ko/managed-settings.md#what-a-developer-can-change)에서 다룹니다.

관리형 설정은 관리형 설정 페이지에 설명된 [전달 메커니즘](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)을 통해 전달되며, 가장 일반적인 방식은 다음과 같습니다.

* [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md): Claude Code가 claude.ai 관리자 콘솔 또는 자체 호스팅 [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)에서 가져옵니다
* MDM 또는 OS 수준 정책, 그리고 시스템 디렉터리의 `managed-settings.json` 파일
* Claude Desktop과 같은 임베딩 호스트가 SDK `managedSettings` 옵션을 통해 전달하는 설정. [임베딩 호스트에서 정책 제어하기](https://code.claude.com/docs/ko/managed-settings.md#parent-settings-from-embedding-hosts)를 참조하세요

Claude Desktop 앱에서 본인 머신으로 실행되는 [Cowork](https://claude.com/docs/cowork/overview) 세션에서는 Claude Code가 claude.ai 관리자 콘솔에서 서버 관리형 설정을 가져오지 않으며, 조직의 Claude Desktop 구성에서 `requireCoworkFullVmSandbox`를 설정하지 않는 한 기기에 배포된 정책을 읽습니다. Cowork 및 클라우드 세션에 대해서는 [정책이 적용되는 위치와 시점](https://code.claude.com/docs/ko/managed-settings.md#where-and-when-a-policy-applies)에서 다룹니다.

관리자라면 [조직을 위한 Claude Code 설정](https://code.claude.com/docs/ko/admin-setup.md)에서 적용할 항목을 선택하는 과정을 안내하며, [관리형 설정 배포](https://code.claude.com/docs/ko/managed-settings.md)에서 전달 방법과 정책이 적용되었는지 확인하는 방법을 다룹니다. claude.ai 관리자 콘솔의 관리형 설정 편집기에 표시될 수 있는 경고에 대해서는 [서버 관리형 설정 구성](https://code.claude.com/docs/ko/server-managed-settings.md#configure-server-managed-settings)을 참조하세요.

## 설정 변경

`/config` 메뉴, 설정 파일 편집, 또는 한 세션에 대해 명령줄에서 설정을 변경할 수 있습니다.

Claude Code의 시스템 프롬프트는 게시되지 않습니다. Claude에 지속적인 지침을 제공하려면 [`CLAUDE.md` 파일](https://code.claude.com/docs/ko/memory) 또는 `--append-system-prompt` 플래그를 사용합니다.

### /config 메뉴 사용

Claude Code 내에서 `/config`를 실행하고 **Config** 탭을 엽니다. 테마, 편집기 모드, 상세 출력과 같은 짧은 개인 옵션 집합을 나열하며, 모든 설정 키는 아닙니다. 옵션을 선택하여 변경합니다. Claude Code가 저장합니다:

* **대부분의 옵션**: `~/.claude/settings.json`
* **팁 표시와 같은 몇 가지 옵션**: `.claude/settings.local.json`
* **[전역 구성 옵션](https://code.claude.com/docs/ko/settings-reference.md#global-config-settings)**: `~/.claude.json`

메뉴 없이 한 옵션을 설정하려면 `/config verbose=true`와 같이 `key=value`를 전달합니다.

> [!NOTE]
>
> `/config`는 터미널 인터페이스의 일부입니다. [VS Code](https://code.claude.com/docs/ko/vs-code.md) 채팅 패널 및 [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md)은 열지 않습니다. 설정 파일을 편집하거나 해당 앱의 자체 설정을 통해 변경합니다.

### 설정 파일 편집

원하는 범위의 설정 파일을 편집기에서 열고 키를 추가하거나 변경합니다. 설정 파일은 엄격한 JSON입니다: `//` 주석이나 후행 쉼표는 구문 오류이며, Claude Code는 다음 시작에서 파일을 [설정 오류](#fix-a-broken-settings-file)로 보고합니다. 예를 들어 Claude Code가 lint 및 테스트 명령을 묻지 않고 실행하고 `.env` 파일 읽기를 중지하도록 하려면 `~/.claude/settings.json`에 다음을 추가합니다:

```json ~/.claude/settings.json theme={null}
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)"
    ]
  }
}
```

`permissions` 아래의 각 항목은 도구와 수행할 수 있는 것을 명명하는 규칙입니다. [권한 구성](https://code.claude.com/docs/ko/permissions.md)은 구문을 설명합니다. `$schema` 줄은 Claude Code 설정에 대한 [게시된 JSON 스키마](https://json.schemastore.org/claude-code-settings.json)를 가리키며, VS Code, Cursor 및 JSON 스키마를 지원하는 다른 편집기에서 자동 완성 및 인라인 검증을 제공합니다. 스키마는 최신 CLI 릴리스보다 뒤떨어질 수 있으므로 최근에 문서화된 키에 대한 검증 경고는 구성이 유효하지 않음을 의미하지 않습니다.

저장한 후 Claude Code 내에서 `/status`를 실행하여 파일이 로드되었는지 확인합니다. [로드된 것 확인](#check-what-loaded)은 `Setting sources` 줄이 표시하는 것과 손상된 파일이 보고되는 방식을 설명합니다.

완전한 개인 파일, 팀 파일, 조직 파일은 각각 설정하는 모든 키에 대한 주석과 함께 [예제 설정 파일](https://code.claude.com/docs/ko/settings-example.md)을 참조하세요.

### 한 세션에 대해 설정 변경

값을 저장하지 않고 시도하려면 Claude Code를 시작할 때 설정합니다. 값은 해당 세션에 적용되고 설정 파일은 그대로 유지됩니다. 3가지 방법이 있습니다:

* **`--settings`**: JSON으로 키를 전달하거나 파일 경로로. Claude Code는 사용자, 프로젝트, 로컬 파일 위에 적용하고 관리되는 설정 아래에 적용합니다. 사용자 설정 파일이 설정할 수 있는 모든 키를 설정할 수 있습니다. `Managed` 또는 `Global config` 키는 설정할 수 없습니다.
* **해당 키에 대한 플래그**: 일부 키에는 `model`에 대한 `--model`, `effortLevel` 및 `modelSettings`에 대한 `--effort`와 같은 자체 플래그가 있습니다.
* **환경 변수**: `model`에 대해 `ANTHROPIC_MODEL`과 같이 `claude`를 실행하기 전에 키의 쌍을 이루는 변수를 내보냅니다.

각 키의 [설정 참조](https://code.claude.com/docs/ko/settings-reference.md) 항목은 세션별 재정의 및 우선순위를 나열하므로 변경하려는 키의 항목을 확인합니다.

세션 내에서 실행하는 명령은 대부분 선택을 저장합니다: `/config`에서 설정을 변경하면 Claude Code가 설정 파일에 작성하고, `/model`은 새 세션의 기본값으로 값을 저장합니다.

`/model` 선택기에서 `s`를 누르면 Claude Code는 기본값으로 저장하지 않고 모델을 전환합니다. [노력 수준 조정](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)은 `/effort`가 사용 중인 모델의 기본값으로 저장하는 것과 현재 세션에만 적용하는 것을 설명합니다.

예를 들어 기본값을 변경하지 않고 한 세션을 Opus에서 시작하려면:

```bash theme={null}
claude --settings '{"model": "claude-opus-5-5"}'
```

### 편집이 적용되는 시기

Claude Code는 설정 파일을 감시하고 변경될 때 다시 로드하므로 대부분의 편집이 재시작 없이 실행 중인 세션에 적용됩니다. 여기에는 `permissions`, `hooks`, `apiKeyHelper`와 같은 자격 증명 도우미에 대한 편집이 포함됩니다. Claude Code는 또한 세션 중에 생성한 설정 파일을 로드합니다. 해당 폴더가 세션 시작 시 존재했다면 말입니다. 프로젝트의 `.claude/` 폴더의 경우 같은 세션에서 폴더를 생성할 때도 파일을 로드합니다.

다시 로드는 사용자, 프로젝트, 로컬, 관리되는 설정을 다룹니다. Claude Code는 감지된 각 설정 파일 변경에 대해 [`ConfigChange` hook](https://code.claude.com/docs/ko/hooks#configchange)을 실행하며, MDM 또는 claude.ai 콘솔에서 도착하는 관리되는 설정에 대해서는 실행하지 않습니다. MDM 또는 claude.ai 콘솔에서 도착하는 관리되는 설정은 일정에 따라 실행 중인 세션에 도달합니다. [전달 테이블](https://code.claude.com/docs/ko/managed-settings.md#choose-a-delivery-mechanism)은 소스별로 제공합니다.

Claude Code는 일부 키를 세션 시작 시에만 한 번 읽으므로 편집이 실행 중인 세션에 도달하지 않습니다. 관리자 측 키도 `requiredMinimumVersion`과 같이 재시작을 기다립니다. [정책이 적용되는 위치와 시기](https://code.claude.com/docs/ko/managed-settings.md#where-and-when-a-policy-applies)에 나열됩니다. 세션 중에 편집할 가능성이 가장 높은 것:

* [`model`](https://code.claude.com/docs/ko/settings-reference#model): 세션 중에 전환하려면 [`/model`](https://code.claude.com/docs/ko/model-config#setting-your-model)을 사용합니다. 각 모델에는 자체 프롬프트 캐시가 있으므로 전환 후 첫 요청은 전체 대화를 캐시되지 않은 상태로 다시 읽습니다. [모델 전환](https://code.claude.com/docs/ko/prompt-caching.md#switching-models)을 참조하세요
* [`effortLevel`](https://code.claude.com/docs/ko/settings-reference#effortlevel) 및 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings): 세션 중에 변경하려면 [`/effort`](https://code.claude.com/docs/ko/model-config#adjust-effort-level)를 사용합니다

### 로드된 것 확인

Claude Code 내에서 `/status`를 실행하여 활성 설정 소스를 확인합니다. **Status** 탭에는 Claude Code가 현재 세션에 로드한 각 설정 파일을 나열하는 `Setting sources` 줄이 포함됩니다. 예: `User settings` 또는 `Project local settings`. [관리되는 설정](https://code.claude.com/docs/ko/admin-setup.md#decide-how-settings-reach-devices)이 적용되면 관리되는 설정 항목은 괄호에 도달 방식을 표시합니다.

줄은 Claude Code가 읽은 파일을 확인합니다. 각 키를 제공한 파일은 표시하지 않습니다. Claude Code가 거부한 항목을 나열하려면 [`claude doctor`](https://code.claude.com/docs/ko/debug-your-config)를 실행합니다. 프로젝트 또는 관리되는 설정이 설정한 모델의 경우 시작 헤더가 설정한 파일의 이름을 지정합니다. `/status`와 `/config`는 다른 탭에서 동일한 대화를 엽니다. **Config** 탭은 `settings.json` 내용의 보기가 아닙니다.

### 손상된 설정 파일 수정

JSON을 잘못 입력하거나 Claude Code가 수락하지 않는 값으로 키를 설정하면 Claude Code는 대화형 세션 시작 시 알려줍니다. 표시되는 것은 파일의 얼마나 많은 부분이 영향을 받는지에 따라 다릅니다:

* **설정 오류**: 사용자, 프로젝트 또는 로컬 파일에 유효하지 않은 JSON 또는 스키마가 거부하는 값이 있습니다. 대화형 세션 시작 시 Claude Code는 Claude의 도움으로 파일을 수정하거나, 종료하거나, 손상된 설정 없이 계속할 수 있는 대화를 표시합니다.
* **설정 경고**: 개별 항목만 실패합니다. 예: 잘못된 형식의 권한 규칙 또는 알 수 없는 hook 이벤트 이름. Claude Code는 해당 값을 건너뛰고 파일의 나머지를 유지합니다.
* **관리되는 설정**: Claude Code는 파일의 나머지를 적용합니다. [관리되는 설정의 유효하지 않은 항목](https://code.claude.com/docs/ko/managed-settings.md#invalid-entries-in-managed-settings)은 삭제되는 것과 유효하지 않은 항목을 수정할 때까지 폴백하는 키를 설명합니다. 유효한 JSON이 아닌 관리되는 설정 문서는 [관리되는 설정 문서를 파싱할 수 없음](https://code.claude.com/docs/ko/errors.md#managed-settings-document-could-not-be-parsed)을 참조하세요.
* **구성 오류**: `~/.claude.json`을 파싱할 수 없습니다. Claude Code는 손상된 파일을 `~/.claude/backups/.claude.json.corrupted.<timestamp>`에 복사하고 종료하고 직접 수정하거나 기본 구성으로 재설정할지 묻습니다. `-p` 실행은 오류를 인쇄하고 종료합니다. 이전 상태를 복구하려면 `~/.claude/backups/`의 5개 가장 최근 `.claude.json.backup.<timestamp>` 파일 중 하나를 다시 복사합니다. Claude Code는 파일을 쓰기 전에 저장합니다.

계속한 후 `/status`를 실행하여 영향을 받는 파일을 확인하고 각 오류의 세부 사항을 보려면 `claude doctor`를 실행합니다.

`-p` 실행은 대화를 표시하지 않습니다. [관리되는 설정 문서를 파싱할 수 없음](https://code.claude.com/docs/ko/errors.md#managed-settings-document-could-not-be-parsed)이 아니면 Claude Code는 손상된 파일이나 값을 건너뛰고 나머지로 계속합니다. 따라서 설정을 무시한 `-p` 실행 후 `claude doctor`를 실행하여 삭제된 것을 확인합니다.

## 설정 우선순위

동일한 키가 여러 위치에 나타나면 Claude Code는 가장 높은 수준에서 설정한 값을 사용합니다. 아래 스택은 수준을 보여주며, 맨 위가 가장 높습니다. 더 높은 수준의 키는 아래의 동일한 키를 재정의합니다.

Settings precedence, highest first: managed settings, command line, project local, shared project, user. A key set at a higher level overrides the same key set lower down.

순서대로, 가장 높은 우선순위부터:

1. **관리형 설정**: 조직이 배포하는 설정으로, `managed-settings.json` 파일, MDM 정책, 또는 claude.ai 콘솔의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)입니다. 자신의 설정 파일이나 `--settings`의 어떤 것도 관리형 키를 재정의하지 않으며, `--model`과 같은 플래그는 조직이 허용하는 모델 중에서만 선택합니다. 관리형 [`model`](https://code.claude.com/docs/ko/settings-reference#model)은 시작 기본값일 뿐 잠금이 아닙니다. 잠금은 [`availableModels`](https://code.claude.com/docs/ko/settings-reference#availablemodels)와 [`deniedModels`](https://code.claude.com/docs/ko/settings-reference#deniedmodels)입니다. 조직이 둘 이상의 관리형 소스를 제공할 때, [관리형 계층 내 우선순위](https://code.claude.com/docs/ko/managed-settings.md#precedence-within-the-managed-tier)의 규칙은 Claude Code가 각각에서 읽는 것을 나타냅니다.
2. **명령줄**: `claude`를 시작할 때 `--settings <file-or-json>`으로 전달하는 JSON으로, 해당 세션에만 적용됩니다. [한 세션 동안 설정 변경](#change-a-setting-for-one-session)을 참조하세요. 여기서 설정한 키는 프로젝트 및 사용자 설정 파일의 동일한 키를 재정의하며, 생략한 키는 해당 파일의 값을 유지합니다. `--model`과 같은 다른 플래그는 세션에 대해 한 가지를 설정하며 이 스택에 포함되지 않습니다. [설정 참조](https://code.claude.com/docs/ko/settings-reference.md)의 키 항목은 어떤 플래그가 해당 키를 재정의하는지 나타냅니다.
3. **프로젝트 로컬 설정** (`.claude/settings.local.json`): 이 프로젝트에 대한 개인 설정입니다.
4. **공유 프로젝트 설정** (`.claude/settings.json`): 팀이 소스 제어에 체크인하는 설정입니다.
5. **사용자 설정** (`~/.claude/settings.json`): 모든 프로젝트에 대한 개인 설정입니다.

환경 변수는 이 스택의 수준이 아닙니다. 동작에 셸 변수와 설정 키가 모두 있을 때, 어느 것이 적용되는지는 수준이 아닌 쌍별로 결정됩니다. 셸에서 내보낸 `ANTHROPIC_MODEL`은 모든 파일의 `model` 키보다 우선하지만, `ANTHROPIC_DEFAULT_MODEL`은 파일이 `model`을 설정하지 않을 때만 적용됩니다. [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md#precedence)는 어느 키가 쌍을 가지고 있으며 Claude Code가 먼저 읽는 것을 나타냅니다. 설정 파일 내의 `env` 블록은 일반 키이며 위의 수준을 따릅니다.

몇 가지 보안에 민감한 키의 경우, Claude Code는 관리형 값보다 낮은 수준의 더 엄격한 값을 준수합니다. [관리형 설정 우선순위의 예외](#exceptions-to-managed-settings-precedence)에 이를 나열합니다.

### 목록은 재정의 대신 병합됩니다

`permissions.allow`와 같은 동일한 목록 키를 둘 이상의 파일에서 설정할 때, Claude Code는 하나를 선택하는 대신 목록을 결합하므로 각 파일은 다른 파일의 항목을 제거하지 않고 항목을 추가할 수 있습니다. 모델 목록 또는 모델별 항목을 보유하는 네 가지 키는 자신의 규칙을 따릅니다.

* [`fallbackModel`](https://code.claude.com/docs/ko/settings-reference#fallbackmodel)은 위치가 의미를 갖는 정렬된 체인이므로, Claude Code는 이를 정의하는 가장 높은 우선순위 파일의 전체 값을 사용합니다.
* [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#modelpicker)는 하나의 정렬된 행 목록과 교체 플래그를 보유하므로, Claude Code는 두 소스의 행을 병합하지 않습니다. 이를 정의하는 관리형 설정, `--settings`, 및 사용자 설정 중 가장 높은 것의 전체 값을 사용하며, 프로젝트 및 로컬 설정의 키를 무시합니다. Claude Code v2.1.242 이상이 필요합니다.
* [`availableModels`](https://code.claude.com/docs/ko/settings-reference#availablemodels): Claude Code가 적용하는 관리형 설정이 이를 정의할 때, Claude Code는 해당 목록을 그대로 적용하고 사용자, 프로젝트 또는 로컬 설정에서 추가하는 항목을 무시합니다. 단, Claude Code를 포함하는 앱이 자신의 모델 목록을 제공하는 경우는 제외합니다. [관리형 설정 우선순위의 예외](#exceptions-to-managed-settings-precedence)를 참조하세요. 관리형 소스 전체에서 목록은 병합되지 않습니다. [Claude Code가 관리형 소스를 결합하는 방법](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)은 어느 소스의 목록이 적용되는지 나타냅니다. 관리형이 아닌 범위 전체에서 Claude Code는 일반적으로 배열을 병합합니다.
* [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings): Claude Code는 [`effortLevel`](https://code.claude.com/docs/ko/settings-reference#effortlevel)과 함께 한 번에 하나의 모델로 이를 해결합니다. `modelSettings` 항목은 어느 파일의 값이 모델에 적용되는지 나타냅니다.

### 우선순위 예제

Claude가 작동하는 동안, Claude Code는 스피너 아래에 한 줄 팁을 표시합니다. 예를 들어 "Use /config to change your default permission mode (including Plan Mode)". 이러한 팁을 끄고 싶어서 `~/.claude/settings.json`에서 [`spinnerTipsEnabled`](https://code.claude.com/docs/ko/settings-reference#spinnertipsenabled)를 `false`로 설정했다고 가정합니다. 아래의 각 시나리오는 이를 다시 켤 수 있는 것과 이에 대해 할 수 있는 것입니다.

#### 팀 설정이 개인 설정을 재정의합니다

팀의 `.claude/settings.json`이 이를 `true`로 설정합니다. Claude Code는 공유 프로젝트가 사용자 위에 있기 때문에 프로젝트 값을 사용하므로, 해당 프로젝트에서만 팁을 보고 다른 곳에서는 보지 않습니다.

값을 다시 얻을 수 있습니다. 해당 프로젝트의 `.claude/settings.local.json`에 `"spinnerTipsEnabled": false`를 추가합니다. 프로젝트 로컬이 공유 프로젝트 위에 있으므로, 해당 세션은 팁을 표시하지 않고 팀원의 세션은 변경되지 않습니다.

#### 조직 설정이 모든 것을 재정의합니다

조직의 관리형 설정이 이를 `true`로 설정합니다. 사용자, 프로젝트 또는 로컬 설정에 넣은 것도 팁을 끌 수 없으며, `--settings`도 마찬가지입니다. 관리형이 최상위 수준입니다.

값을 다시 얻을 수 없습니다. `/status`를 실행하여 어느 관리형 소스가 적용되는지 확인하고, 정책을 변경해야 하는지 관리자에게 문의합니다.

#### 명령줄이 한 세션 동안 파일을 재정의합니다

`claude --settings '{"spinnerTipsEnabled": true}'`로 세션을 시작했습니다. 명령줄은 관리형을 제외한 모든 파일 위에 있으므로, 파일이 `false`라고 말해도 해당 세션은 팁을 표시합니다.

다음 세션에서 값을 다시 얻습니다. `--settings`는 한 세션 동안만 지속되며 파일에 쓰지 않습니다.

#### 플래그 또는 환경 변수가 동일한 것을 설정합니다

일부 키에는 설정 값을 재정의하는 명령줄 플래그 또는 환경 변수가 있으며, 이는 어느 파일이 설정했는지와 관계없이 적용됩니다. `ANTHROPIC_MODEL`은 [`model`](https://code.claude.com/docs/ko/settings-reference#model) 설정을 재정의하고, `--model`은 한 세션 동안 둘 다 재정의합니다.

값을 다시 얻을 수 있는지는 키에 따라 다릅니다. 변수를 설정 해제하거나 플래그를 제거하고, [설정 참조](https://code.claude.com/docs/ko/settings-reference.md)의 키 항목과 [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md)의 변수 행을 확인하여 Claude Code가 어느 것을 사용하는지 확인합니다.

### 적용되지 않는 설정 문제 해결

키를 설정했는데 Claude Code가 그렇게 동작하지 않으면, `/status`로 시작하여 로드한 파일을 확인한 다음 아래에서 증상을 찾습니다. [구성 디버그](https://code.claude.com/docs/ko/debug-your-config.md)는 깨끗한 구성 테스트를 포함한 더 넓은 검사를 다룹니다.

#### 설정한 값이 무시됩니다

다른 것이 동일한 키를 설정하거나, 파일이 해당 값을 설정할 수 없거나, 파일이 로드되지 않았습니다.

* **더 높은 수준이 이를 설정합니다.** 다른 설정 파일, `--settings` 플래그, 또는 관리형 소스가 키를 위에서 설정합니다. [스택](#settings-precedence)은 어느 것인지 나타냅니다. 플래그 또는 환경 변수도 키별로 결정되는 키를 자체적으로 재정의할 수 있습니다. [설정 참조](https://code.claude.com/docs/ko/settings-reference.md)의 키 항목은 Claude Code가 어느 것을 사용하는지 나타내며, [`env` 항목](https://code.claude.com/docs/ko/settings-reference#env)은 관리형 `env` 값 대 셸 내보내기를 다룹니다.
* **보안 키가 엄격한 값을 유지합니다.** 몇 가지 키의 경우 Claude Code는 모든 파일의 제한적인 값을 준수하므로, 프로젝트 `true`는 [`disableClaudeAiConnectors`](https://code.claude.com/docs/ko/settings-reference#disableclaudeaiconnectors)에 대해 켜진 상태로 유지됩니다. [관리형 설정 우선순위의 예외](#exceptions-to-managed-settings-precedence)를 참조하세요.
* **파일이 해당 값을 설정할 수 없습니다.** [`permissions.defaultMode`](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode) 값 `auto`와 `bypassPermissions`은 프로젝트 또는 로컬 설정에서 적용되지 않습니다. 대신 사용자 또는 관리형 설정에서 설정하거나, 한 세션 동안 `--permission-mode`를 전달합니다. v2.1.257 이전에는 `bypassPermissions`이 모든 파일에서 적용되었습니다.

  [`env`](https://code.claude.com/docs/ko/settings-reference#env) 블록의 텔레메트리 내보내기 변수도 프로젝트 또는 로컬 설정에서 적용되지 않습니다. 몇 가지 끄기 값은 제외합니다. [Claude Code가 `env`에서 무시하는 변수](https://code.claude.com/docs/ko/settings-reference#variables-claude-code-ignores-in-env)는 변수와 해당 값을 나열합니다.
* **파일이 손상되었습니다.** 잘못된 JSON 또는 거부된 값은 Claude Code가 파일 또는 항목을 건너뜁니다. [손상된 설정 파일 수정](#fix-a-broken-settings-file)을 참조하세요.

#### Claude Code에서 만든 변경 사항이 새 세션에서 손실됩니다

Claude Code 내에서 새 세션을 위한 선택을 저장할 때, 예를 들어 `/model`로 기본 모델을 저장할 때, Claude Code는 사용자 설정 파일 `~/.claude/settings.json`에 씁니다. 해당 파일에 쓸 수 없으면, 예를 들어 다른 도구가 생성하거나 읽기 전용 복사본에 연결하면, 변경 사항은 현재 세션에 적용되고 다음 세션에서 손실됩니다. 파일을 생성하는 도구에서 키를 설정하거나, 파일을 쓸 수 있는 파일로 바꿉니다.

파일에 쓸 수 있고 변경 사항이 여전히 지속되지 않으면, 변경 사항이 [한 세션 동안만](#change-a-setting-for-one-session) 또는 [더 높은 수준이 동일한 키를 설정](#a-value-you-set-is-ignored)했는지 확인합니다. `model` 키의 경우, [새 세션이 선택한 것과 다른 모델에서 시작됩니다](https://code.claude.com/docs/ko/model-config.md#a-new-session-starts-on-a-different-model-than-you-picked)는 더 많은 원인을 나열합니다.

#### 관리형 변경 사항이 도달하지 않았습니다

관리형 소스는 [전달 테이블](https://code.claude.com/docs/ko/managed-settings.md#choose-a-delivery-mechanism)의 일정에 따라 실행 중인 세션에 도달하므로, 먼저 세션을 다시 시작합니다. `/status`가 관리자가 변경한 것과 다른 소스를 나타내면, 더 높은 우선순위 소스가 적용됩니다. [Claude Code가 관리형 소스를 결합하는 방법](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)은 순서를 제공합니다.

#### 커밋된 키가 팀원에게 도달하지 않습니다

두 가지가 `.claude/settings.json`의 키가 이를 복제하는 모든 사람에게 적용되는 것을 방지합니다.

* **Claude Code는 저장소 파일의 키를 무시합니다.** [설정 인덱스](https://code.claude.com/docs/ko/settings-reference.md#settings-index)의 범위 열에서 `User, local, or managed`, `User or managed`, `User`, `Managed`, 또는 `Global config`를 찾습니다. 이러한 키는 공유 파일에서 적용되지 않으며, 저장소 파일이 여전히 끌 수 있는 몇 가지 키만 예외입니다. 해당 항목은 각각 범위 줄에 이를 명시합니다. `Global config` 키는 `~/.claude.json`에서만 적용됩니다.

  `env` 키 내에서, 텔레메트리 내보내기 변수도 공유 파일에서 적용되지 않습니다. 몇 가지 끄기 값은 제외합니다. [Claude Code가 `env`에서 무시하는 변수](https://code.claude.com/docs/ko/settings-reference#variables-claude-code-ignores-in-env)를 참조하세요.
* **키가 신뢰를 기다립니다.** `permissions.allow` 규칙, `permissions.additionalDirectories`, `extraKnownMarketplaces`, 및 대부분의 [`env`](https://code.claude.com/docs/ko/settings-reference#env) 값은 각 팀원이 [폴더를 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)한 후에만 적용됩니다. 그때까지 그들은 여전히 프롬프트를 보고 파일이 선언하는 마켓플레이스에서 플러그인을 얻지 못합니다. `deny`와 `ask` 규칙은 즉시 적용됩니다.

#### 권한 규칙이 예상과 다르게 결합됩니다

* **권한 프롬프트에서 "Yes, and don't ask again"을 선택했지만 여전히 동일한 도구에 대해 프롬프트를 받습니다.** 해당 선택은 `allow` 규칙을 로컬 파일에 저장했으며, 로컬 파일의 `allow` 규칙은 프로젝트 또는 관리형 파일의 `ask` 규칙을 능가하지 않습니다. [권한 규칙이 결합되는 방법](https://code.claude.com/docs/ko/permissions.md#settings-precedence)은 순서를 설명합니다. VS Code 확장에서 승인 카드는 프로젝트의 공유 파일을 포함한 대상 파일을 선택할 수 있으며, 이는 모든 사람을 위한 규칙을 변경합니다. CLI에서 Claude Code는 로컬 파일에만 씁니다.
* **조직의 허용 규칙이 여전히 사용자의 규칙과 함께 적용됩니다.** 이는 예상된 것입니다. Claude Code는 조직이 [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedpermissionrulesonly)를 설정하지 않는 한 범위 전체에서 [`permissions.allow`](https://code.claude.com/docs/ko/settings-reference#permissions-allow)를 병합합니다.

### 관리형 설정 우선순위의 예외

값이 세션을 제한하는 몇 가지 키의 경우, Claude Code는 관리형 설정을 재정의할 수 없는 범위의 제한적인 값을 준수합니다. 이 표에서 키를 찾아 어느 값을 준수하는지 그리고 어디서 준수하는지 확인합니다.

| 키 | Claude Code가 준수하는 값 | 참고 |
| :- | :- | :- |
| [`disableClaudeAiConnectors`](https://code.claude.com/docs/ko/settings-reference#disableclaudeaiconnectors) | 모든 범위의 `true` | 관리형 소스가 `false`를 설정할 때도 준수됩니다 |
| [`enableArtifact`](https://code.claude.com/docs/ko/settings-reference#enableartifact) | 모든 범위의 `false`, 그리고 모든 범위의 `disableArtifact: true` | 관리형 소스가 `true`를 설정할 때도 준수됩니다. 아무것도 [Artifact 도구](https://code.claude.com/docs/ko/artifacts.md#disable-artifacts)를 다시 켤 수 없습니다. Claude Code v2.1.242 이상이 필요합니다 |
| [`isolatePeerMachines`](https://code.claude.com/docs/ko/settings-reference#isolatepeermachines) | 모든 범위의 `true` | 관리형 소스가 `false`를 설정할 때도 준수됩니다 |
| [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories) | 모든 범위의 `true` | 관리형 소스가 `false`를 설정할 때도 준수됩니다. Claude Code v2.1.257 이상이 필요합니다 |
| [`autoMode.classifyAllShell`](https://code.claude.com/docs/ko/settings-reference#automode-classifyallshell) | `~/.claude/settings.json` 또는 `--settings`의 `true` | 관리형 소스가 `false`를 설정할 때도 준수됩니다 |
| [`remoteControlAtStartup`](https://code.claude.com/docs/ko/settings-reference#remotecontrolatstartup) | `.claude/settings.json` 또는 `.claude/settings.local.json`의 `false` | 관리형 소스가 `true`를 설정할 때도 준수됩니다. 프로젝트 또는 로컬 `true`는 무시됩니다 |
| [`crossSessionInbound`](https://code.claude.com/docs/ko/settings-reference#crosssessioninbound) | `.claude/settings.json` 또는 `.claude/settings.local.json`의 더 엄격한 값, `accept` \< `hold` \< `refuse` 사다리에서 | 관리형, `--settings`, 및 사용자 값보다 준수됩니다. 더 엄격하지 않은 프로젝트 또는 로컬 값은 무시됩니다 |
| [`useAutoModeDuringPlan`](https://code.claude.com/docs/ko/settings-reference#useautomodeduringplan) | 모든 관리형 소스, `--settings`, `~/.claude/settings.json`, 또는 `.claude/settings.local.json`의 `false` | 승리한 관리형 소스가 `true`를 설정할 때도 준수됩니다. `.claude/settings.json`의 `false`는 무시됩니다 |
| [`syncClaudeAiSkills`](https://code.claude.com/docs/ko/settings-reference#syncclaudeaiskills) | 모든 관리형 소스, `--settings`, `~/.claude/settings.json`, 또는 `.claude/settings.local.json`의 `false` | 승리한 관리형 소스가 `true`를 설정할 때도 준수됩니다. `.claude/settings.json`의 `false`는 무시됩니다 |
| [`syncClaudeAiPlugins`](https://code.claude.com/docs/ko/settings-reference#syncclaudeaiplugins) | 모든 관리형 소스, `--settings`, `~/.claude/settings.json`, 또는 `.claude/settings.local.json`의 `false` | 승리한 관리형 소스가 `true`를 설정할 때도 준수됩니다. `.claude/settings.json`의 `false`는 무시됩니다 |
| [`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel) | `--settings`를 포함한 모든 범위의 더 낮은 상한 | Claude Code가 적용하는 관리형 설정이 더 높은 상한을 설정할 때도 준수됩니다. 가장 낮은 상한이 적용됩니다. Claude Code v2.1.267 이상이 필요합니다 |

[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정하고 Claude Code를 자신 내부에서 실행하는 앱도 예외입니다. Claude Code는 모든 관리형 소스의 `model`, `fallbackModel`, `modelPicker`, 및 `modelOverrides` 키보다, 그리고 관리형 `env` 블록의 모델 선택 변수(예: `ANTHROPIC_MODEL` 및 `ANTHROPIC_DEFAULT_*_MODEL` 계열)보다 해당 앱의 모델 구성을 사용합니다. Claude Code는 앱이 자신의 것을 제공하지 않는 한 관리형 [`availableModels`](https://code.claude.com/docs/ko/settings-reference#availablemodels) 허용 목록을 적용 중으로 유지합니다.

## 클라우드 세션의 설정

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)에서 저장소의 신선한 복제본에서 실행되며, 머신에서 실행되지 않습니다. 이는 어느 설정이 도달하는지 변경합니다:

* **프로젝트의 클라우드 스레드**: [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)의 클라우드 스레드에서는 프로젝트에 저장소가 몇 개 있든 저장소의 `.claude/settings.json`에 있는 권한 규칙, 훅, `env`가 전혀 적용되지 않습니다. 대신 사용할 항목은 [스레드가 저장소에서 가져오는 항목](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)에 나와 있습니다.
* **공유 프로젝트 설정** (`.claude/settings.json`): 프로젝트 스레드 외부에서 저장소가 하나인 세션에서는 이 파일을 읽습니다. 파일이 복제본의 일부이고 세션이 그 안에서 시작되기 때문입니다. 해당 세션에 설정을 적용하려면 이 파일에 커밋합니다.
* **여러 저장소가 있는 공유 프로젝트 설정**: Anthropic 호스팅 환경에서 여러 저장소가 있는 세션은 복제본 상위 디렉터리에서 시작되며, 각 저장소의 `.claude/settings.json`에서 `enabledPlugins` 및 `extraKnownMarketplaces` 키만 읽고 권한 규칙, 훅, `env` 또는 기타 키는 읽지 않습니다. 이 두 키가 선언하는 마켓플레이스와 플러그인도 [클라우드 세션에서는 로드되지 않습니다](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup). 자체 호스팅 환경의 경우 [어느 저장소의 설정이 적용되는지](https://code.claude.com/docs/ko/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories)를 참조하세요.
* **사용자 및 프로젝트 로컬 설정** (`~/.claude/settings.json` 및 `.claude/settings.local.json`): 읽지 않습니다. 둘 다 머신에 유지되고 로컬 파일은 복제본에 없습니다.
* **관리되는 설정**: 장치의 `managed-settings.json` 파일이나 MDM 프로필은 클라우드 세션에 도달하지 않습니다. 조직의 [서버 관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md)은 도달합니다. [표면 범위](https://code.claude.com/docs/ko/model-config.md#surface-coverage)는 어느 클라우드 세션이 이를 수신하는지 나열합니다. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)도 실행기 이미지의 관리되는 설정 파일을 읽습니다. [Claude Code가 관리되는 소스를 결합하는 방식](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)은 해당 파일이 적용되는 시기를 설명합니다.
* **`/config`**: 브라우저의 claude.ai/code에서는 값을 변경하는 대신 claude.ai의 **Code** 또는 **Claude Code** 설정 페이지를 엽니다. 클라우드 세션의 설정을 변경하려면 환경에서 [환경 변수](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)를 설정합니다. 프로젝트 스레드 외부에서 저장소가 하나인 세션에서는 대신 해당 저장소의 `.claude/settings.json`에 키를 커밋할 수도 있습니다.

[설정에서 수행되는 것](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup)은 나머지를 나열합니다: `CLAUDE.md`, skills, MCP servers, plugins, 및 credentials.

## 다음 단계

* [모든 설정](https://code.claude.com/docs/ko/settings-reference.md): 모든 키, 설정 위치, 기본값, 예제
* [예제 설정 파일](https://code.claude.com/docs/ko/settings-example.md): 개인 파일, 팀 파일, 조직의 관리되는 파일
* [권한 구성](https://code.claude.com/docs/ko/permissions.md): allow, ask, deny 규칙, Claude Code가 묻지 않고 실행하는 것
* [환경 변수](https://code.claude.com/docs/ko/env-vars.md): Claude Code가 읽는 변수 및 `env` 블록
* [구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md): 설정이 적용되지 않을 때
* [Claude 디렉토리 참조](https://code.claude.com/docs/ko/claude-directory.md): Claude Code가 읽는 모든 파일. subagents, MCP 서버, 플러그인, `CLAUDE.md` 포함
