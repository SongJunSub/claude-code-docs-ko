> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 권한 모드 선택

> Claude가 파일을 편집하거나 명령을 실행하기 전에 승인을 요청하는지 여부를 제어합니다. CLI에서 Shift+Tab으로 모드를 순환하거나 VS Code, Desktop, claude.ai의 모드 선택기를 사용합니다.

Claude가 파일을 편집하거나 셸 명령을 실행하거나 네트워크 요청을 할 때, 작업을 승인하도록 일시 중지하고 요청합니다. 권한 모드는 해당 일시 중지가 얼마나 자주 발생하는지를 제어합니다. 선택한 모드는 세션의 흐름을 형성합니다. 기본 모드는 각 작업을 검토하도록 하는 반면, 더 느슨한 모드는 Claude가 더 길게 중단 없이 작업하고 완료되면 보고하도록 합니다. 민감한 작업에는 더 많은 감시를 선택하거나, 방향을 신뢰할 때는 더 적은 중단을 선택합니다.

## 사용 가능한 모드

각 모드는 편의성과 감시 사이에서 다른 절충을 합니다. 아래 표는 각 모드에서 Claude가 권한 프롬프트 없이 수행할 수 있는 작업을 보여줍니다.

| 모드                                                                  | 묻지 않고 실행되는 작업                                             | 최적 사용 사례           |
| :------------------------------------------------------------------ | :-------------------------------------------------------- | :----------------- |
| `default`                                                           | 읽기만                                                       | 시작, 민감한 작업         |
| [`acceptEdits`](#auto-approve-file-edits-with-acceptedits-mode)     | 읽기, 파일 편집, 일반적인 파일 시스템 명령(`mkdir`, `touch`, `mv`, `cp` 등) | 검토 중인 코드 반복        |
| [`plan`](#analyze-before-you-edit-with-plan-mode)                   | 읽기만                                                       | 변경하기 전에 코드베이스 탐색   |
| [`auto`](#eliminate-prompts-with-auto-mode)                         | 백그라운드 안전 검사를 포함한 모든 작업                                    | 장시간 작업, 프롬프트 피로 감소 |
| [`dontAsk`](#allow-only-pre-approved-tools-with-dontask-mode)       | 사전 승인된 도구만                                                | 잠금된 CI 및 스크립트      |
| [`bypassPermissions`](#skip-all-checks-with-bypasspermissions-mode) | 모든 작업                                                     | 격리된 컨테이너 및 VM만     |

`bypassPermissions`를 제외한 모든 모드에서 [보호된 경로](#protected-paths)에 대한 쓰기는 절대 자동 승인되지 않으며, 리포지토리 상태와 Claude의 자체 구성을 우발적인 손상으로부터 보호합니다.

모드는 기본선을 설정합니다. `bypassPermissions`를 제외한 모든 모드에서 특정 도구를 사전 승인하거나 차단하기 위해 [권한 규칙](/ko/permissions#manage-permissions)을 위에 계층화합니다. `bypassPermissions`는 권한 계층을 완전히 건너뜁니다.

## 권한 모드 전환

세션 중, 시작 시 또는 지속적인 기본값으로 모드를 전환할 수 있습니다. 모드는 채팅에서 Claude에게 요청하는 것이 아니라 이러한 제어를 통해 설정됩니다. 아래에서 인터페이스를 선택하여 변경 방법을 확인합니다.

<Tabs>
  <Tab title="CLI">
    **세션 중**: `Shift+Tab`을 눌러 `default` → `acceptEdits` → `plan`을 순환합니다. 현재 모드는 상태 표시줄에 나타납니다. 모든 모드가 기본 순환에 있는 것은 아닙니다:

    * `auto`: 계정이 [자동 모드 요구 사항](#eliminate-prompts-with-auto-mode)을 충족할 때 나타나며, 자동 모드로 순환하면 수락할 때까지 또는 **아니요, 다시 묻지 마세요**를 선택하여 순환에서 자동을 제거할 때까지 옵트인 프롬프트가 표시됩니다
    * `bypassPermissions`: `--permission-mode bypassPermissions`, `--dangerously-skip-permissions` 또는 `--allow-dangerously-skip-permissions`로 시작한 후 나타나며, `--allow-` 변형은 활성화하지 않고 순환에 모드를 추가합니다
    * `dontAsk`: 순환에 절대 나타나지 않습니다. `--permission-mode dontAsk`로 설정합니다

    활성화된 선택적 모드는 `plan` 후에 슬롯되며, `bypassPermissions`가 먼저이고 `auto`가 마지막입니다. 둘 다 활성화된 경우, `auto`로 가는 길에 `bypassPermissions`를 순환합니다.

    **시작 시**: 플래그로 모드를 전달합니다.

    ```bash theme={null}
    claude --permission-mode plan
    ```

    **기본값으로**: [설정](/ko/settings#settings-files)에서 `defaultMode`를 설정합니다.

    ```json theme={null}
    {
      "permissions": {
        "defaultMode": "acceptEdits"
      }
    }
    ```

    동일한 `--permission-mode` 플래그는 [비대화형 실행](/ko/headless)을 위해 `-p`와 함께 작동합니다.
  </Tab>

  <Tab title="VS Code">
    **세션 중**: 프롬프트 상자 하단의 모드 표시기를 클릭합니다.

    **기본값으로**: VS Code 설정에서 `claudeCode.initialPermissionMode`를 설정하거나 Claude Code 확장 설정 패널을 사용합니다.

    모드 표시기는 이러한 레이블을 표시하며, 각각이 적용되는 모드에 매핑됩니다:

    | UI 레이블   | 모드                  |
    | :------- | :------------------ |
    | 편집 전에 요청 | `default`           |
    | 자동으로 편집  | `acceptEdits`       |
    | 계획 모드    | `plan`              |
    | 자동 모드    | `auto`              |
    | 권한 무시    | `bypassPermissions` |

    자동 모드는 계정이 [자동 모드 섹션](#eliminate-prompts-with-auto-mode)에 나열된 모든 요구 사항을 충족할 때 모드 표시기에 나타납니다. `claudeCode.initialPermissionMode` 설정은 `auto`를 허용하지 않습니다. 기본적으로 자동 모드로 시작하려면 대신 [사용자 설정](/ko/settings#settings-files)에서 `defaultMode`를 설정합니다. Claude Code는 프로젝트 및 로컬 설정에서 `defaultMode: "auto"`를 무시합니다.

    권한 무시는 모드 표시기에 나타나기 전에 확장 설정에서 **위험하게 권한 건너뛰기 허용** 토글이 필요합니다.

    확장 관련 세부 정보는 [VS Code 가이드](/ko/vs-code)를 참조합니다.
  </Tab>

  <Tab title="JetBrains">
    JetBrains 플러그인은 IDE 터미널에서 Claude Code를 실행하므로, 모드 전환은 CLI와 동일하게 작동합니다: `Shift+Tab`을 눌러 순환하거나 시작할 때 `--permission-mode`를 전달합니다.
  </Tab>

  <Tab title="Desktop">
    전송 버튼 옆의 모드 선택기를 사용합니다. 자동 및 권한 무시는 Desktop 설정에서 활성화한 후에만 나타납니다. [Desktop 가이드](/ko/desktop#choose-a-permission-mode)를 참조합니다.
  </Tab>

  <Tab title="Web and mobile">
    [claude.ai/code](https://claude.ai/code)의 프롬프트 상자 옆 모드 드롭다운 또는 모바일 앱을 사용합니다. 권한 프롬프트는 승인을 위해 claude.ai에 나타납니다. 어떤 모드가 나타나는지는 세션이 실행되는 위치에 따라 다릅니다:

    * **[Claude Code on the web](/ko/claude-code-on-the-web)의 클라우드 세션**: 편집 자동 수락 및 계획 모드. 권한 요청, 자동 및 권한 무시는 사용할 수 없습니다.
    * **로컬 머신의 [원격 제어](/ko/remote-control) 세션**: 권한 요청, 편집 자동 수락, 계획 모드. 자동 및 권한 무시는 사용할 수 없습니다.

    원격 제어의 경우, 호스트를 시작할 때 시작 모드를 설정할 수도 있습니다:

    ```bash theme={null}
    claude remote-control --permission-mode acceptEdits
    ```
  </Tab>
</Tabs>

## acceptEdits 모드로 파일 편집 자동 승인

`acceptEdits` 모드는 Claude가 프롬프트 없이 작업 디렉토리의 파일을 생성하고 편집할 수 있게 합니다. 상태 표시줄은 이 모드가 활성화되어 있는 동안 `⏵⏵ accept edits on`을 표시합니다.

파일 편집 외에도, `acceptEdits` 모드는 일반적인 파일 시스템 Bash 명령을 자동 승인합니다: `mkdir`, `touch`, `rm`, `rmdir`, `mv`, `cp`, `sed`. 이러한 명령은 `LANG=C` 또는 `NO_COLOR=1`과 같은 안전한 환경 변수로 접두사가 붙거나 `timeout`, `nice`, `nohup`과 같은 프로세스 래퍼로 접두사가 붙을 때도 자동 승인됩니다. 파일 편집과 마찬가지로, 자동 승인은 작업 디렉토리 또는 `additionalDirectories` 내의 경로에만 적용됩니다. 해당 범위 외의 경로, [보호된 경로](#protected-paths)에 대한 쓰기, 기타 모든 Bash 명령은 여전히 프롬프트합니다.

[PowerShell 도구](/ko/tools-reference#powershell-tool)가 활성화되면, `acceptEdits` 모드는 범위 내 경로에서 `Set-Content`, `Add-Content`, `Clear-Content`, `Remove-Item`을 자동 승인하며, 이들의 일반적인 별칭도 함께 자동 승인됩니다. 동일한 범위 및 보호된 경로 규칙이 적용됩니다.

변경 사항을 인라인으로 각각 승인하는 대신 편집기에서 또는 `git diff`를 통해 사후에 검토하려는 경우 `acceptEdits`를 사용합니다. 기본 모드에서 `Shift+Tab`을 한 번 눌러 입력하거나 직접 시작합니다:

```bash theme={null}
claude --permission-mode acceptEdits
```

## 계획 모드로 편집 전에 분석

계획 모드는 Claude에게 변경 사항을 연구하고 제안하도록 지시하지만 변경하지는 않습니다. Claude는 파일을 읽고, 셸 명령을 실행하여 탐색하고, 계획을 작성하지만 소스를 편집하지는 않습니다. 권한 프롬프트는 기본 모드와 동일하게 적용됩니다.

`Shift+Tab`을 눌러 계획 모드에 들어가거나 단일 프롬프트 앞에 `/plan`을 붙입니다. CLI에서 계획 모드로 시작할 수도 있습니다:

```bash theme={null}
claude --permission-mode plan
```

계획을 승인하지 않고 계획 모드를 떠나려면 `Shift+Tab`을 다시 누릅니다.

### 계획 검토 및 승인

계획이 준비되면, Claude는 이를 제시하고 진행 방법을 묻습니다. 해당 프롬프트에서 다음을 수행할 수 있습니다:

* 승인하고 자동 모드로 시작
* 승인하고 편집 수락
* 승인하고 각 편집을 수동으로 검토
* 피드백으로 계획 유지
* [Ultraplan](/ko/ultraplan)으로 브라우저 기반 검토를 위해 개선

계획을 승인하면 계획 모드를 종료하고 세션을 각 승인 옵션이 설명하는 권한 모드로 전환하므로 Claude가 편집을 시작합니다. 다시 계획하려면 `Shift+Tab`으로 계획 모드로 돌아가거나 다음 프롬프트 앞에 `/plan`을 붙입니다.

`Ctrl+G`를 눌러 제안된 계획을 기본 텍스트 편집기에서 열고 Claude가 진행하기 전에 직접 편집할 수 있습니다. [`showClearContextOnPlanAccept`](/ko/settings#available-settings)가 활성화되면, 각 승인 옵션도 먼저 계획 컨텍스트를 지우도록 제안합니다.

계획을 수락하면 이미 `--name` 또는 `/rename`으로 이름을 설정하지 않은 경우 계획 내용에서 자동으로 세션 이름을 지정합니다.

### 계획 모드를 기본값으로 설정

프로젝트에 대해 계획 모드를 기본값으로 설정하려면 `.claude/settings.json`에서 `defaultMode`를 설정합니다:

```json theme={null}
{
  "permissions": {
    "defaultMode": "plan"
  }
}
```

## 자동 모드로 프롬프트 제거

<Note>
  자동 모드는 Claude Code v2.1.83 이상이 필요합니다.
</Note>

자동 모드는 Claude가 권한 프롬프트 없이 실행되도록 합니다. 별도의 분류기 모델이 실행 전에 작업을 검토하여, 요청을 초과하여 확대되거나, 인식되지 않은 인프라를 대상으로 하거나, Claude가 읽은 적대적 콘텐츠에 의해 주도되는 것으로 보이는 모든 것을 차단합니다.

자동 모드는 또한 Claude에게 명확히 하는 질문을 위해 멈추지 않고 계속 작업하도록 권장합니다. 그러나 Claude는 프롬프트나 스킬이 명시적으로 이를 필요로 할 때는 여전히 질문합니다. 권한 프롬프트를 유지하면서 더 강력한 자율적 동작을 원하면 [사전 예방적 출력 스타일](/ko/output-styles)을 대신 설정합니다.

<Warning>
  자동 모드는 연구 미리보기입니다. 프롬프트를 줄이지만 안전을 보장하지는 않습니다. 일반적인 방향을 신뢰하는 작업에 사용하고, 민감한 작업에 대한 검토 대체로 사용하지 마세요.
</Warning>

자동 모드는 계정이 다음의 모든 요구 사항을 충족할 때만 사용 가능합니다:

* **플랜**: 모든 플랜.
* **관리자**: Team 및 Enterprise에서, 관리자는 사용자가 켜기 전에 [Claude Code 관리자 설정](https://claude.ai/admin-settings/claude-code)에서 이를 활성화해야 합니다. 관리자는 [관리 설정](/ko/permissions#managed-settings)에서 `permissions.disableAutoMode`를 `"disable"`로 설정하여 이를 잠금할 수도 있습니다.
* **모델**: Claude Opus 4.6 이상 또는 Sonnet 4.6. Sonnet 4.5, Opus 4.5, Haiku, claude-3 모델을 포함한 이전 모델은 지원되지 않습니다.
* **제공자**: Anthropic API만. Bedrock, Vertex, Foundry에서는 사용할 수 없습니다.

Claude Code가 자동 모드를 사용할 수 없다고 보고하면, 이러한 요구 사항 중 하나가 충족되지 않은 것입니다. 이는 일시적인 중단이 아닙니다. 모델을 이름으로 지정하고 자동 모드가 작업의 안전을 "결정할 수 없다"고 말하는 별도의 메시지는 일시적인 분류기 중단입니다. [오류 참조](/ko/errors#auto-mode-cannot-determine-the-safety-of-an-action)를 참조합니다.

[설정](/ko/settings#available-settings)에서 `defaultMode: "auto"`를 설정했는데 세션이 오류 없이 `default` 모드로 시작하면, 설정이 `.claude/settings.json` 또는 `.claude/settings.local.json`에 있을 가능성이 높습니다. Claude Code는 이러한 파일의 `auto`를 무시하므로 리포지토리가 자신에게 자동 모드를 부여할 수 없습니다. 이를 `~/.claude/settings.json`으로 이동합니다.

### 분류기가 기본적으로 차단하는 항목

분류기는 작업 디렉토리와 리포지토리의 구성된 원격을 신뢰합니다. 다른 모든 것은 [신뢰할 수 있는 인프라를 구성](/ko/auto-mode-config)할 때까지 외부로 취급됩니다.

**기본적으로 차단됨**:

* `curl | bash`와 같은 코드 다운로드 및 실행
* 외부 엔드포인트로 민감한 데이터 전송
* 프로덕션 배포 및 마이그레이션
* 클라우드 스토리지의 대량 삭제
* IAM 또는 리포지토리 권한 부여
* 공유 인프라 수정
* 세션 시작 전에 존재했던 파일을 되돌릴 수 없게 삭제
* 강제 푸시 또는 `main`에 직접 푸시

**기본적으로 허용됨**:

* 작업 디렉토리의 로컬 파일 작업
* 잠금 파일 또는 매니페스트에 선언된 종속성 설치
* `.env` 읽기 및 자격 증명을 일치하는 API로 전송
* 읽기 전용 HTTP 요청
* 시작한 분기 또는 Claude가 생성한 분기로 푸시

샌드박스 네트워크 액세스 요청은 기본적으로 허용되는 대신 분류기를 통해 라우팅됩니다. `claude auto-mode defaults`를 실행하여 전체 규칙 목록을 확인합니다. 일상적인 작업이 차단되면, 관리자는 `autoMode.environment` 설정을 통해 신뢰할 수 있는 리포지토리, 버킷, 서비스를 추가할 수 있습니다: [자동 모드 구성](/ko/auto-mode-config)을 참조합니다.

### 대화에서 명시한 경계

분류기는 대화에서 명시한 경계를 차단 신호로 취급합니다. Claude에게 "푸시하지 마"라고 말하거나 "배포하기 전에 검토할 때까지 기다려"라고 말하면, 분류기는 기본 규칙이 허용하더라도 일치하는 작업을 차단합니다. 경계는 나중 메시지에서 해제할 때까지 유효합니다. Claude의 조건이 충족되었다는 자체 판단은 이를 해제하지 않습니다.

경계는 규칙으로 저장되지 않습니다. 분류기는 각 검사에서 기록에서 이를 다시 읽으므로, [컨텍스트 압축](/ko/costs#reduce-token-usage)이 경계를 명시한 메시지를 제거하면 경계가 손실될 수 있습니다. 하드 보장을 위해 대신 [거부 규칙](/ko/permissions#permission-rule-syntax)을 추가합니다.

### 자동 모드가 폴백할 때

각 거부된 작업은 알림을 표시하고 `/permissions` 아래의 최근 거부됨 탭에 나타나며, 여기서 `r`을 눌러 수동 승인으로 재시도할 수 있습니다.

분류기가 한 행에서 3번 또는 총 20번 작업을 차단하면, 자동 모드가 일시 중지되고 Claude Code는 프롬프트를 재개합니다. 프롬프트된 작업을 승인하면 자동 모드가 재개됩니다. 이러한 임계값은 구성할 수 없습니다. 모든 허용된 작업은 연속 카운터를 재설정하는 반면, 총 카운터는 세션 동안 유지되고 자체 제한이 폴백을 트리거할 때만 재설정됩니다.

[비대화형 모드](/ko/headless)에서 `-p` 플래그를 사용하면, 프롬프트할 사용자가 없으므로 반복된 차단이 세션을 중단합니다.

반복된 차단은 일반적으로 분류기가 인프라에 대한 컨텍스트가 부족함을 의미합니다. `/feedback`을 사용하여 거짓 긍정을 보고하거나, 관리자가 [신뢰할 수 있는 인프라를 구성](/ko/auto-mode-config)하도록 합니다.

<AccordionGroup>
  <Accordion title="분류기가 작업을 평가하는 방식">
    각 작업은 고정된 결정 순서를 거칩니다. 첫 번째 일치 단계가 승리합니다:

    1. [허용 또는 거부 규칙](/ko/permissions#manage-permissions)과 일치하는 작업은 즉시 해결됩니다
    2. 읽기 전용 작업 및 작업 디렉토리의 파일 편집은 자동 승인됩니다. [보호된 경로](#protected-paths)에 대한 쓰기는 제외됩니다
    3. 다른 모든 것은 분류기로 이동합니다
    4. 분류기가 차단하면, Claude는 이유를 받고 대체 방법을 시도합니다

    자동 모드에 들어가면, 임의의 코드 실행을 부여하는 광범위한 허용 규칙이 삭제됩니다:

    * 무제한 `Bash(*)`
    * `Bash(python*)`과 같은 와일드카드 인터프리터
    * 패키지 관리자 실행 명령
    * `Agent` 허용 규칙

    `Bash(npm test)`과 같은 좁은 규칙은 유지됩니다. 삭제된 규칙은 자동 모드를 떠날 때 복원됩니다.

    분류기는 사용자 메시지, 도구 호출, CLAUDE.md 콘텐츠를 봅니다. 도구 결과는 제거되므로, 파일이나 웹 페이지의 적대적 콘텐츠는 이를 직접 조작할 수 없습니다. 별도의 서버 측 프로브가 들어오는 도구 결과를 스캔하고 Claude가 읽기 전에 의심스러운 콘텐츠에 플래그를 지정합니다. 이러한 계층이 함께 작동하는 방식에 대한 자세한 내용은 [자동 모드 공지](https://claude.com/blog/auto-mode) 및 [엔지니어링 심층 분석](https://www.anthropic.com/engineering/claude-code-auto-mode)을 참조합니다.
  </Accordion>

  <Accordion title="자동 모드가 서브에이전트를 처리하는 방식">
    분류기는 [서브에이전트](/ko/sub-agents) 작업을 세 지점에서 확인합니다:

    1. 서브에이전트가 시작되기 전에, 위임된 작업 설명이 평가되므로, 위험해 보이는 작업은 생성 시점에 차단됩니다.
    2. 서브에이전트가 실행되는 동안, 각 작업은 부모 세션과 동일한 규칙으로 분류기를 통해 이동하며, 서브에이전트의 프론트매터의 모든 `permissionMode`는 무시됩니다.
    3. 서브에이전트가 완료되면, 분류기는 전체 작업 기록을 검토합니다. 반환 검사가 우려 사항에 플래그를 지정하면, 보안 경고가 서브에이전트의 결과에 앞에 붙습니다.
  </Accordion>

  <Accordion title="비용 및 지연">
    분류기는 `/model` 선택과 독립적인 서버 구성 모델에서 실행되므로, 모델을 전환해도 분류기 가용성이 변경되지 않습니다. 분류기 호출은 토큰 사용량으로 계산됩니다. 각 검사는 기록의 일부와 보류 중인 작업을 전송하여 실행 전에 왕복을 추가합니다. 읽기 및 보호된 경로 외의 작업 디렉토리 편집은 분류기를 건너뛰므로, 오버헤드는 주로 셸 명령 및 네트워크 작업에서 발생합니다.
  </Accordion>
</AccordionGroup>

## dontAsk 모드로 사전 승인된 도구만 허용

`dontAsk` 모드는 그렇지 않으면 프롬프트할 모든 도구 호출을 자동 거부합니다. `permissions.allow` 규칙과 일치하는 작업 및 [읽기 전용 Bash 명령](/ko/permissions#read-only-commands)만 실행할 수 있습니다. 명시적 `ask` 규칙은 프롬프트하는 대신 거부됩니다. 이는 모드를 완전히 비대화형으로 만들어 CI 파이프라인 또는 Claude가 정확히 수행할 수 있는 작업을 사전 정의하는 제한된 환경에 적합합니다.

플래그로 시작 시 설정합니다:

```bash theme={null}
claude --permission-mode dontAsk
```

## bypassPermissions 모드로 모든 검사 건너뛰기

`bypassPermissions` 모드는 권한 프롬프트 및 안전 검사를 비활성화하여 도구 호출이 즉시 실행되도록 합니다. v2.1.126부터 이는 [보호된 경로](#protected-paths)에 대한 쓰기를 포함하며, 이전 버전은 여전히 프롬프트를 표시합니다. 파일 시스템 루트 또는 홈 디렉터리를 대상으로 하는 제거(예: `rm -rf /` 및 `rm -rf ~`)는 모델 오류에 대한 차단기로서 여전히 프롬프트를 표시합니다. 인터넷 액세스가 없는 컨테이너, VM 또는 개발 컨테이너와 같은 격리된 환경에서만 이 모드를 사용하십시오. 여기서 Claude Code는 호스트 시스템에 손상을 줄 수 없습니다.

활성화 플래그 중 하나로 시작한 세션에서 `bypassPermissions`에 들어갈 수 없습니다. 활성화하려면 다시 시작하십시오:

```bash theme={null}
claude --permission-mode bypassPermissions
```

`--dangerously-skip-permissions` 플래그는 동등합니다.

Linux 및 macOS에서 Claude Code는 root로 실행되거나 `sudo` 아래에서 실행될 때 이 모드에서 시작하기를 거부합니다:

```text theme={null}
--dangerously-skip-permissions cannot be used with root/sudo privileges for security reasons
```

인식된 샌드박스 내에서는 검사가 자동으로 건너뜁니다. 컨테이너에서 자율적으로 실행하려면 [개발 컨테이너](/ko/devcontainer) 구성을 사용하십시오. 이는 Claude Code를 비root 사용자로 실행합니다.

<Warning>
  `bypassPermissions`는 프롬프트 주입 또는 의도하지 않은 작업에 대한 보호를 제공하지 않습니다. 프롬프트 없이 백그라운드 안전 검사를 위해 [자동 모드](#eliminate-prompts-with-auto-mode)를 대신 사용하십시오. 관리자는 [관리 설정](/ko/permissions#managed-settings)에서 `permissions.disableBypassPermissionsMode`를 `"disable"`로 설정하여 이 모드를 차단할 수 있습니다.
</Warning>

## 보호된 경로

경로의 작은 집합에 대한 쓰기는 `bypassPermissions`을 제외한 모든 모드에서 절대 자동 승인되지 않습니다. 이는 리포지토리 상태와 Claude의 자체 구성의 우발적인 손상을 방지합니다. `default`, `acceptEdits`, `plan`에서 이러한 쓰기는 프롬프트를 표시합니다. `auto`에서는 분류기로 라우팅됩니다. `dontAsk`에서는 거부됩니다. `bypassPermissions`에서는 허용됩니다.

보호된 디렉토리:

* `.git`
* `.vscode`
* `.idea`
* `.husky`
* `.cargo`
* `.claude`, `.claude/commands`, `.claude/agents`, `.claude/skills`, `.claude/worktrees` 제외. Claude는 이러한 위치에서 정기적으로 콘텐츠를 생성합니다

보호된 파일:

* `.gitconfig`, `.gitmodules`
* `.bashrc`, `.bash_profile`, `.zshrc`, `.zprofile`, `.profile`
* `.ripgreprc`
* `.mcp.json`, `.claude.json`

## 참고 항목

* [권한](/ko/permissions): 허용, 요청, 거부 규칙. 관리 정책
* [자동 모드 구성](/ko/auto-mode-config): 분류기에 조직이 신뢰하는 인프라를 알립니다
* [Hooks](/ko/hooks): `PreToolUse` 및 `PermissionRequest` 훅을 통한 사용자 정의 권한 논리
* [Ultraplan](/ko/ultraplan): 브라우저 기반 검토를 통해 Claude Code on the web 세션에서 계획 모드 실행
* [보안](/ko/security): 보안 조치 및 모범 사례
* [샌드박싱](/ko/sandboxing): Bash 명령에 대한 파일 시스템 및 네트워크 격리
* [비대화형 모드](/ko/headless): `-p` 플래그로 Claude Code 실행
