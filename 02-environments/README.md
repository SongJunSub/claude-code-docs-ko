# 02. 실행 환경 / 인터페이스

Claude Code를 어디서, 어떻게 띄울지에 관한 카테고리. CLI 외에 IDE 플러그인, 데스크톱 앱, 웹, Slack, Chrome 등 모든 인터페이스를 다룬다.

## 이럴 때 본다
- VS Code/JetBrains/Desktop으로 옮기거나 병행해서 쓰고 싶다
- 모바일/원격에서 세션을 이어 받고 싶다
- 터미널 환경(키바인딩, 단축키, 컬러, tmux, 풀스크린)을 다듬고 싶다
- Slack/Chrome 등 외부 채널과 연동하고 싶다

## 페이지 목록

### IDE / 데스크톱 / 웹
| 페이지 | 한 줄 |
|---|---|
| [vs-code](vs-code.md) | VS Code 확장 — 인라인 diff, @-멘션, 플랜 검토 |
| [jetbrains](jetbrains.md) | IntelliJ / PyCharm / WebStorm 등 JetBrains IDE 플러그인 |
| [desktop](desktop.md) | 병렬 세션, 패널 레이아웃, 통합 터미널·에디터, side chat, computer use, 비주얼 diff |
| [claude-code-on-the-web](claude-code-on-the-web.md) | 클라우드 sandbox, setup 스크립트, 네트워크/Docker, `--remote` / `--teleport` |

### 외부 채널 / 자동화
| 페이지 | 한 줄 |
|---|---|
| [slack](slack.md) | Slack에서 `@Claude` 멘션으로 작업 위임 |
| [chrome](chrome.md) | Chrome 연결로 웹앱 테스트·콘솔 디버깅·폼 자동화·데이터 추출 |
| [channels](channels.md) | MCP 서버에서 webhook·알림·메시지를 세션에 푸시 |
| [channels-reference](channels-reference.md) | Channel 계약 레퍼런스 (capability, notification, reply tool, sender gating) |
| [remote-control](remote-control.md) | 휴대폰·태블릿·브라우저에서 로컬 세션 이어가기 |

### 터미널 환경 다듬기
| 페이지 | 한 줄 |
|---|---|
| [terminal-config](terminal-config.md) | Shift+Enter, 벨, tmux, 컬러 테마, Vim 모드 설정 |
| [interactive-mode](interactive-mode.md) | 키보드 단축키·입력 모드·인터랙티브 기능 전체 레퍼런스 |
| [fullscreen](fullscreen.md) | 깜빡임 없는 풀스크린 렌더링 + 마우스 지원 |
| [statusline](statusline.md) | context 사용량·비용·git 상태를 보여주는 status bar 커스터마이징 |
| [keybindings](keybindings.md) | 키바인딩 커스터마이징 |
| [voice-dictation](voice-dictation.md) | 음성 받아쓰기 (hold/tap to record) — *영문 원문* |
| [computer-use](computer-use.md) | macOS에서 앱 열기·클릭·타이핑 + 화면 인식 자동화 |
