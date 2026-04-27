> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 자동 모드 구성

> 자동 모드 분류기에 조직이 신뢰하는 저장소, 버킷 및 도메인을 알려줍니다. 환경 컨텍스트를 설정하고, 기본 차단 및 허용 규칙을 재정의하며, 자동 모드 CLI 하위 명령으로 유효한 구성을 검사합니다.

[자동 모드](/ko/permission-modes#eliminate-prompts-with-auto-mode)를 사용하면 Claude Code가 각 도구 호출을 분류기를 통해 라우팅하여 권한 프롬프트 없이 실행될 수 있습니다. 분류기는 되돌릴 수 없거나 파괴적이거나 환경 외부를 대상으로 하는 모든 것을 차단합니다. `autoMode` 설정 블록을 사용하여 분류기에 조직이 신뢰하는 저장소, 버킷 및 도메인을 알려주면, 분류기가 일상적인 내부 작업 차단을 중지합니다.

기본적으로 분류기는 작업 디렉토리와 현재 저장소의 구성된 원격 저장소만 신뢰합니다. 회사의 소스 제어 조직에 푸시하거나 팀 클라우드 버킷에 쓰기와 같은 작업은 `autoMode.environment`에 추가할 때까지 차단됩니다.

자동 모드를 활성화하는 방법과 기본적으로 차단되는 항목에 대해서는 [권한 모드](/ko/permission-modes#eliminate-prompts-with-auto-mode)를 참조하세요. 이 페이지는 구성 참조입니다.

이 페이지에서 다루는 내용:

* [규칙을 설정할 위치 선택](#where-the-classifier-reads-configuration) - CLAUDE.md, 사용자 설정 및 관리 설정 전체
* [신뢰할 수 있는 인프라 정의](#define-trusted-infrastructure) - `autoMode.environment` 사용
* [차단 및 허용 규칙 재정의](#override-the-block-and-allow-rules) - 기본값이 파이프라인에 맞지 않을 때
* [유효한 구성 검사](#inspect-the-defaults-and-your-effective-config) - `claude auto-mode` 하위 명령 사용
* [거부 검토](#review-denials) - 다음에 추가할 항목 파악

## 분류기가 구성을 읽는 위치

분류기는 Claude 자체가 로드하는 동일한 [CLAUDE.md](/ko/memory) 콘텐츠를 읽으므로, 프로젝트의 CLAUDE.md에 있는 "절대 강제 푸시하지 마세요"와 같은 지시사항은 Claude와 분류기를 동시에 제어합니다. 프로젝트 규칙과 동작 규칙은 여기서 시작하세요.

신뢰할 수 있는 인프라나 조직 전체 거부 규칙과 같이 여러 프로젝트에 적용되는 규칙의 경우 `autoMode` 설정 블록을 사용하세요. 분류기는 다음 범위에서 `autoMode`를 읽습니다:

| 범위                            | 파일                                   | 용도                                   |
| :---------------------------- | :----------------------------------- | :----------------------------------- |
| 한 명의 개발자                      | `~/.claude/settings.json`            | 개인 신뢰할 수 있는 인프라                      |
| 한 프로젝트, 한 명의 개발자              | `.claude/settings.local.json`        | 프로젝트별 신뢰할 수 있는 버킷 또는 서비스, gitignored |
| 조직 전체                         | [관리 설정](/ko/server-managed-settings) | 모든 개발자에게 배포된 신뢰할 수 있는 인프라            |
| `--settings` 플래그 또는 Agent SDK | 인라인 JSON                             | 자동화를 위한 호출별 재정의                      |

분류기는 `.claude/settings.json`의 공유 프로젝트 설정에서 `autoMode`를 읽지 않으므로, 체크인된 저장소는 자체 허용 규칙을 주입할 수 없습니다.

각 범위의 항목이 결합됩니다. 개발자는 개인 항목으로 `environment`, `allow` 및 `soft_deny`를 확장할 수 있지만 관리 설정이 제공하는 항목을 제거할 수 없습니다. 허용 규칙이 분류기 내의 차단 규칙에 대한 예외로 작동하기 때문에, 개발자가 추가한 `allow` 항목은 조직의 `soft_deny` 항목을 재정의할 수 있습니다. 조합은 가산적이며, 하드 정책 경계가 아닙니다.

<Note>
  분류기는 [권한 시스템](/ko/permissions) 이후에 실행되는 두 번째 게이트입니다. 사용자 의도나 분류기 구성에 관계없이 절대 실행되어서는 안 되는 작업의 경우, 관리 설정에서 `permissions.deny`를 사용하세요. 이는 분류기가 참조되기 전에 작업을 차단하며 재정의될 수 없습니다.
</Note>

## 신뢰할 수 있는 인프라 정의

대부분의 조직에서 `autoMode.environment`는 설정해야 하는 유일한 필드입니다. 분류기에 신뢰할 수 있는 저장소, 버킷 및 도메인을 알려줍니다. 분류기는 이를 사용하여 "외부"가 무엇을 의미하는지 결정하므로, 나열되지 않은 모든 대상은 잠재적 정보 유출 대상입니다.

기본 환경 목록은 작업 저장소와 그 구성된 원격 저장소를 신뢰합니다. 기본값과 함께 자신의 항목을 추가하려면 배열에 리터럴 문자열 `"$defaults"`를 포함하세요. 기본 항목은 해당 위치에 삽입되므로, 사용자 정의 항목은 기본값 앞이나 뒤에 올 수 있습니다.

```json theme={null}
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Source control: github.example.com/acme-corp and all repos under it",
      "Trusted cloud buckets: s3://acme-build-artifacts, gs://acme-ml-datasets",
      "Trusted internal domains: *.corp.example.com, api.internal.example.com",
      "Key internal services: Jenkins at ci.example.com, Artifactory at artifacts.example.com"
    ]
  }
}
```

항목은 정규식이나 도구 패턴이 아닌 산문입니다. 분류기는 이를 자연어 규칙으로 읽습니다. 새로운 엔지니어에게 인프라를 설명하는 방식으로 작성하세요. 철저한 환경 섹션은 다음을 포함합니다:

* **조직**: 회사 이름 및 Claude Code가 주로 사용되는 용도(예: 소프트웨어 개발, 인프라 자동화 또는 데이터 엔지니어링)
* **소스 제어**: 개발자가 푸시하는 모든 GitHub, GitLab 또는 Bitbucket 조직
* **클라우드 제공자 및 신뢰할 수 있는 버킷**: Claude가 읽고 쓸 수 있어야 하는 버킷 이름 또는 접두사
* **신뢰할 수 있는 내부 도메인**: 네트워크 내부의 API, 대시보드 및 서비스에 대한 호스트명(예: `*.internal.example.com`)
* **주요 내부 서비스**: CI, 아티팩트 레지스트리, 내부 패키지 인덱스, 인시던트 도구
* **추가 컨텍스트**: 규제 산업 제약, 다중 테넌트 인프라 또는 분류기가 위험으로 취급해야 할 사항에 영향을 미치는 규정 준수 요구사항

유용한 시작 템플릿: 괄호로 묶인 필드를 채우고 적용되지 않는 줄을 제거하세요.

```json theme={null}
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Organization: {COMPANY_NAME}. Primary use: {PRIMARY_USE_CASE, e.g. software development, infrastructure automation}",
      "Source control: {SOURCE_CONTROL, e.g. GitHub org github.example.com/acme-corp}",
      "Cloud provider(s): {CLOUD_PROVIDERS, e.g. AWS, GCP, Azure}",
      "Trusted cloud buckets: {TRUSTED_BUCKETS, e.g. s3://acme-builds, gs://acme-datasets}",
      "Trusted internal domains: {TRUSTED_DOMAINS, e.g. *.internal.example.com, api.example.com}",
      "Key internal services: {SERVICES, e.g. Jenkins at ci.example.com, Artifactory at artifacts.example.com}",
      "Additional context: {EXTRA, e.g. regulated industry, multi-tenant infrastructure, compliance requirements}"
    ]
  }
}
```

제공하는 컨텍스트가 구체적일수록 분류기가 일상적인 내부 작업과 정보 유출 시도를 더 잘 구분할 수 있습니다.

모든 것을 한 번에 채울 필요는 없습니다. 합리적인 롤아웃: 기본값으로 시작하여 소스 제어 조직과 주요 내부 서비스를 추가하세요. 이는 자신의 저장소에 푸시하는 것과 같은 가장 일반적인 거짓 양성을 해결합니다. 다음으로 신뢰할 수 있는 도메인과 클라우드 버킷을 추가하세요. 차단이 발생할 때 나머지를 채우세요.

## 차단 및 허용 규칙 재정의

두 개의 추가 필드를 사용하여 분류기의 기본 제공 규칙 목록을 바꿀 수 있습니다: `autoMode.soft_deny`는 차단되는 항목을 제어하고, `autoMode.allow`는 적용되는 예외를 제어합니다. 각각은 자연어 규칙으로 읽히는 산문 설명의 배열입니다. `autoMode.deny` 필드는 없습니다. 의도에 관계없이 작업을 하드 블록하려면 분류기 이전에 실행되는 [`permissions.deny`](/ko/permissions)를 사용하세요.

분류기 내에서 우선순위는 세 가지 계층으로 작동합니다:

* `soft_deny` 규칙이 먼저 차단합니다
* `allow` 규칙이 일치하는 차단을 예외로 재정의합니다
* 명시적 사용자 의도가 둘 다 재정의합니다: 사용자의 메시지가 Claude가 수행하려는 정확한 작업을 직접적이고 구체적으로 설명하면, `soft_deny` 규칙이 일치하더라도 분류기가 이를 허용합니다

일반적인 요청은 명시적 의도로 계산되지 않습니다. Claude에게 "저장소를 정리해 달라"고 요청하는 것은 강제 푸시를 승인하지 않지만, "이 브랜치를 강제 푸시해 달라"고 요청하는 것은 승인합니다.

기본 규칙을 유지하면서 자신의 규칙을 추가하려면 배열에 리터럴 문자열 `"$defaults"`를 포함하세요. 기본 규칙이 해당 위치에 삽입되므로, 사용자 정의 규칙이 앞이나 뒤에 올 수 있으며, 릴리스 전반에 걸쳐 기본 제공 목록이 변경되면서 업데이트를 계속 상속받습니다.

```json theme={null}
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Source control: github.example.com/acme-corp and all repos under it"
    ],
    "allow": [
      "$defaults",
      "Deploying to the staging namespace is allowed: staging is isolated from production and resets nightly",
      "Writing to s3://acme-scratch/ is allowed: ephemeral bucket with a 7-day lifecycle policy"
    ],
    "soft_deny": [
      "$defaults",
      "Never run database migrations outside the migrations CLI, even against dev databases",
      "Never modify files under infra/terraform/prod/: production infrastructure changes go through the review workflow"
    ]
  }
}
```

<Danger>
  `environment`, `allow` 또는 `soft_deny` 중 하나를 `"$defaults"` 없이 설정하면 해당 섹션의 전체 기본 목록이 바뀝니다. 단일 항목으로 `soft_deny`를 설정하고 `"$defaults"`를 생략하면 모든 기본 제공 차단 규칙이 버려집니다: 강제 푸시, 데이터 유출, `curl | bash`, 프로덕션 배포 및 기타 모든 기본 차단 규칙이 허용됩니다. `"$defaults"`를 생략하는 것은 목록의 전체 소유권을 가질 의도가 있을 때만 하세요. 이 경우 `claude auto-mode defaults`를 실행하여 기본 제공 규칙을 인쇄하고, 설정 파일에 복사한 다음, 각 규칙을 자신의 파이프라인 및 위험 허용도와 비교하여 검토하세요.
</Danger>

각 섹션은 독립적으로 평가되므로, `environment`만 설정하면 기본 `allow` 및 `soft_deny` 목록은 그대로 유지됩니다.

## 기본값 및 유효한 구성 검사

세 가지 CLI 하위 명령이 구성을 검사하고 유효성을 검사하는 데 도움이 됩니다.

기본 제공 `environment`, `allow` 및 `soft_deny` 규칙을 JSON으로 인쇄합니다:

```bash theme={null}
claude auto-mode defaults
```

분류기가 실제로 사용하는 것을 JSON으로 인쇄합니다. 설정된 경우 설정이 적용되고 그렇지 않으면 기본값입니다:

```bash theme={null}
claude auto-mode config
```

사용자 정의 `allow` 및 `soft_deny` 규칙에 대한 AI 피드백을 받습니다:

```bash theme={null}
claude auto-mode critique
```

설정을 저장한 후 `claude auto-mode config`를 실행하여 유효한 규칙이 예상한 것인지 확인하세요. `"$defaults"`가 제자리에 확장됩니다. 사용자 정의 규칙을 작성한 경우 `claude auto-mode critique`가 이를 검토하고 모호하거나 중복되거나 거짓 양성을 유발할 가능성이 있는 항목을 플래그합니다. 기본 제공 규칙을 추가하는 대신 제거하거나 다시 작성해야 하는 경우 `claude auto-mode defaults`의 출력을 파일에 저장하고, 목록을 편집한 다음, 결과를 설정 파일에 `"$defaults"` 대신 붙여넣으세요.

## 거부 검토

자동 모드가 도구 호출을 거부하면, 거부는 `/permissions` 아래의 최근 거부 탭에 기록됩니다. 거부된 작업에서 `r`을 누르면 재시도 표시됩니다: 대화 상자를 종료하면 Claude Code가 모델에 해당 도구 호출을 재시도할 수 있음을 알리는 메시지를 보내고 대화를 재개합니다.

동일한 대상에 대한 반복된 거부는 일반적으로 분류기가 컨텍스트를 놓치고 있음을 의미합니다. 해당 대상을 `autoMode.environment`에 추가한 다음 `claude auto-mode config`를 실행하여 적용되었는지 확인하세요.

거부에 프로그래밍 방식으로 반응하려면 [`PermissionDenied` 훅](/ko/hooks#permissiondenied)을 사용하세요.

## 참고 항목

* [권한 모드](/ko/permission-modes#eliminate-prompts-with-auto-mode): 자동 모드가 무엇인지, 기본적으로 차단되는 항목 및 활성화 방법
* [관리 설정](/ko/server-managed-settings): 조직 전체에 `autoMode` 구성 배포
* [권한](/ko/permissions): 분류기가 실행되기 전에 적용되는 허용, 요청 및 거부 규칙
* [설정](/ko/settings): `autoMode` 키를 포함한 전체 설정 참조
