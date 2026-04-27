# 06. 설정 / 레퍼런스

특정 옵션·환경 변수·플래그 값을 찾을 때 보는 레퍼런스 카테고리. 처음부터 읽기보단 검색용.

## 이럴 때 본다
- "이 환경 변수가 뭐였더라" / "이 플래그 정확한 형식이"
- 권한 모드를 어떻게 거는지 / 어떤 도구가 어떤 권한을 요구하는지
- 에러 메시지가 떴는데 의미를 모르겠다
- 모델/aliasing 설정 (`opusplan` 등)
- 조직 단위로 설정을 관리하고 싶다 (server-managed)
- 샌드박스나 auto mode를 정확히 어떻게 거는지

## 페이지 목록

| 페이지 | 한 줄 |
|---|---|
| [cli-reference](cli-reference.md) | 명령어 + 플래그 전체 레퍼런스 |
| [env-vars](env-vars.md) | Claude Code 동작 제어 환경 변수 레퍼런스 |
| [settings](settings.md) | global / project 설정 + 환경 변수 매핑 |
| [permissions](permissions.md) | 세부 권한 규칙·모드·관리 정책 |
| [permission-modes](permission-modes.md) | 편집/명령 실행 시 확인 여부 모드 (Shift+Tab으로 순환) |
| [model-config](model-config.md) | 모델 별칭(`opusplan` 등) 설정 |
| [tools-reference](tools-reference.md) | Claude Code 도구 + 권한 요구사항 전체 레퍼런스 |
| [errors](errors.md) | 런타임 에러 메시지 + 의미 + 해결 방법 |
| [auto-mode-config](auto-mode-config.md) | auto mode classifier 설정 (신뢰 repo/bucket/domain·환경 컨텍스트·차단/허용) |
| [sandboxing](sandboxing.md) | 샌드박스 bash 도구의 파일시스템·네트워크 격리 |
| [server-managed-settings](server-managed-settings.md) | 디바이스 관리 인프라 없이 서버 전달 설정으로 조직 중앙 구성 |

## 자주 찾는 항목
- **권한을 한 번 허용하고 싶다** → `permissions` + `permission-modes`
- **세션 시작 시 환경 변수로 동작 바꾸고 싶다** → `env-vars`
- **특정 명령에서만 모델을 바꾸고 싶다** → `model-config` + `cli-reference`
- **CI에서 안전하게 돌리고 싶다** → `sandboxing` + `permissions`
