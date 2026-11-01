> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Checkpointing

> Claude의 편집 및 대화를 추적, 되돌리기 및 요약하여 세션 상태를 관리합니다.

Claude Code는 작업하면서 Claude의 파일 편집을 자동으로 추적하므로 변경 사항을 빠르게 실행 취소하고 문제가 발생한 경우 이전 상태로 되돌릴 수 있습니다.

## 체크포인트 작동 방식

Claude와 작업하는 동안 체크포인트는 턴을 시작하는 프롬프트를 보낼 때마다 그 직전의 코드 상태를 자동으로 캡처합니다.

### 자동 추적

Claude Code는 파일 편집 도구로 이루어진 모든 변경 사항을 추적합니다.

* 턴을 시작하는 프롬프트를 보낼 때마다 새 체크포인트가 생성됩니다
* Claude Code는 세션에서 가장 최근 100개 체크포인트의 파일 스냅샷을 보관합니다. 오래된 체크포인트를 폐기하면 남아 있는 어떤 체크포인트도 참조하지 않는 스냅샷 파일이 삭제됩니다. 단, 각 파일의 첫 번째 스냅샷은 VS Code 확장 프로그램이 세션 diff의 기준으로 사용하므로 삭제되지 않습니다.
* Claude Code는 체크포인트를 대화와 함께 저장하므로 세션을 재개한 후에도 `/rewind`를 실행할 수 있습니다
* Claude Code는 [보존 정리](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically) 과정에서 세션의 파일 스냅샷을 삭제하며, 기본적으로 세션이 마지막으로 스냅샷을 저장한 후 약 30일이 지나면 삭제됩니다. 스냅샷이 사라진 체크포인트로 되감으면 [`No files were restored`](https://code.claude.com/docs/ko/errors#no-files-were-restored) 오류와 함께 실패할 수 있습니다. 스냅샷을 더 오래 보관하려면 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays)를 설정합니다.

### 되감기 및 요약

`/rewind`를 실행하거나, 프롬프트 입력란이 비어 있을 때 `Esc`를 두 번 눌러 되감기 메뉴를 엽니다.

> [!NOTE]
>
> 프롬프트 입력란에 텍스트가 있으면 `Esc`를 두 번 눌렀을 때 메뉴가 열리는 대신 텍스트가 지워집니다. 지워진 텍스트는 입력 기록에 저장되므로, 되감기 메뉴에서 작업을 마친 후 `Up`을 눌러 다시 불러올 수 있습니다.

되감기 메뉴에는 세션 중에 보낸 프롬프트가 나열됩니다. 작업할 지점을 선택한 다음 동작을 선택합니다.

* **Restore code and conversation**: 코드와 대화를 모두 해당 지점으로 되돌립니다
* **Restore conversation**: 현재 코드는 유지하면서 해당 메시지로 되감습니다
* **Restore code**: 대화는 유지하면서 파일 변경 사항을 되돌립니다
* **Summarize from here**: 이 지점 이후의 대화를 요약으로 압축하여 컨텍스트 윈도우 공간을 확보합니다
* **Summarize up to here**: 이 지점 이전의 대화를 요약으로 압축하고, 이후 메시지는 그대로 유지합니다
* **Never mind**: 변경 없이 메시지 목록으로 돌아갑니다

두 가지 코드 복원 옵션은 선택한 체크포인트에 되돌릴 추적된 파일 변경 사항이 있을 때만 표시됩니다. 해당 지점 이후 캡처된 파일 편집이 없으면 메뉴에는 **Restore conversation**, 요약 옵션, **Never mind**만 표시됩니다.

대화를 복원하거나 Summarize from here를 선택하면 선택한 메시지의 원래 프롬프트가 입력란에 복원되므로 다시 보내거나 편집할 수 있습니다.

Summarize up to here를 선택하면 대화의 끝에서 빈 입력란 상태로 남게 됩니다. 두 요약 옵션 모두 압축된 메시지가 있던 위치에 **Summarized conversation** 표시가 나타납니다.

#### 다음 프롬프트 전에 종료하면 되감은 메시지가 다시 나타날 수 있음

다시 나타난 메시지를 다시 제거하려면 세션에서 `/rewind`를 실행하고 같은 프롬프트를 선택한 다음 **Restore conversation**을 선택합니다. Claude Code는 되감은 대화를 다음 프롬프트와 함께 저장하므로, 종료하기 전에 Claude에게 프롬프트를 보내야 합니다. 복원한 파일은 되감기 후의 상태로 유지됩니다.

#### 지워진 대화 이전으로 되감기

같은 Claude Code 프로세스에서 앞서 `/clear`를 실행했다면, 되감기 메뉴 목록 맨 위에 `/resume <session-id> (previous session)`라는 항목이 추가로 표시됩니다. 이 항목을 선택하면 `/clear` 실행 전에 활성 상태였던 대화를 재개합니다. 이 항목은 Claude Code를 종료하거나 다른 세션을 재개하기 전까지 사용할 수 있습니다.

#### 요약 방향 지정

요약은 디스크의 파일을 변경하지 않으며, 원래 메시지는 세션 트랜스크립트에 그대로 남아 있으므로 Claude는 여전히 세부 내용을 참조할 수 있습니다. 요약이 중점을 둘 내용을 지정하려면 화살표 키로 **Summarize** 옵션을 강조 표시하고 \*\*add context (optional)\*\*라고 표시된 행에 지침을 입력한 다음 `Enter`를 누릅니다. 숫자 키로 옵션을 선택하면 지침 없이 즉시 요약됩니다.

> [!NOTE]
>
> 요약은 같은 세션을 유지하면서 컨텍스트를 압축하며, 대상을 지정한 `/compact`와 비슷합니다. 원래 세션을 그대로 보존하면서 분기하여 다른 접근 방식을 시도하려면 대신 [`/branch`](https://code.claude.com/docs/ko/sessions#branch-a-session) 또는 `claude --continue --fork-session`을 사용합니다.

## 일반적인 사용 사례

Checkpoint는 다음과 같은 경우에 특히 유용합니다:

* **대안 탐색**: 시작점을 잃지 않으면서 다양한 구현 접근 방식을 시도합니다
* **실수 복구**: 버그를 도입하거나 기능을 손상시킨 변경 사항을 빠르게 실행 취소합니다
* **기능 반복**: 작동하는 상태로 되돌릴 수 있다는 확신을 가지고 변형을 실험합니다
* **Context 공간 확보**: 초기 지침을 그대로 유지하면서 중간 지점부터 시작하여 자세한 디버깅 세션을 요약합니다

## 제한 사항

### Bash 명령 변경 사항이 추적되지 않음

대화에서 Claude가 파일 편집 도구로 파일을 한 번 편집하면, 그 이후 Bash 명령이 해당 파일에 적용한 변경 사항도 `/rewind`로 실행 취소됩니다. Bash 명령으로만 변경된 파일은 추적되지 않으며 그대로 유지됩니다. 이러한 파일을 되돌리려면 Git과 같은 버전 관리를 사용합니다.

rewind 메뉴는 각 프롬프트 아래에 Claude가 이미 편집한 파일의 변경 사항을 변경 주체와 관계없이 집계합니다. 셸 명령이 그러한 파일을 변경한 프롬프트에도 파일 변경 사항이 표시됩니다.

### Subagent 편집이 복원되지 않음

[Subagent](https://code.claude.com/docs/ko/sub-agents.md)는 Claude의 파일 편집 도구로 편집을 수행하지만, Claude Code는 일반적으로 세션의 checkpoint에서 이러한 편집을 캡처하지 않습니다. Rewind가 이를 복원하는지 여부는 subagent가 실행되는 방식에 따라 달라집니다:

* **Foreground forked skill**: [foreground에서 실행되는 `context: fork`가 있는 skill](https://code.claude.com/docs/ko/skills#run-skills-in-a-subagent)은 사용자의 차례 동안 작업 트리를 편집하므로, rewind는 일반적으로 편집을 복원합니다. `background: false`를 설정하여 fork를 foreground에서 실행합니다. 몇 가지 상황([skills 페이지에 나열됨](https://code.claude.com/docs/ko/skills.md#run-skills-in-a-subagent))은 설정과 관계없이 foreground에서 실행됩니다.
* **다른 모든 서브에이전트**: rewind는 대화에서 Claude가 이미 편집한 파일만 복원합니다. 다른 파일에 대한 서브에이전트의 편집은 그대로 남으므로 Git과 같은 버전 관리를 사용하여 되돌립니다. 여기에는 background에서 실행되는 포크된 스킬(기본값)과 background [`/code-review --fix`](https://code.claude.com/docs/ko/code-review-local) 실행이 포함됩니다.

### 외부 변경 사항이 추적되지 않음

Checkpointing은 현재 세션 내에서 편집된 파일만 추적합니다. Claude Code 외부에서 수동으로 수행한 파일 변경 사항과 다른 동시 세션의 편집은 현재 세션과 동일한 파일을 수정하는 경우를 제외하고는 일반적으로 캡처되지 않습니다.

### 차례 중간에 전송된 메시지가 checkpoint되지 않음

rewind 메뉴에서 [Claude가 아직 작업하는 동안 입력한](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works) 메시지에 **No code restore** 표시가 붙을 수 있습니다. 표시가 붙은 메시지에는 자체 [체크포인트](#how-checkpoints-work)가 없습니다.

해당 메시지 이후 Claude가 수행한 파일 편집을 실행 취소하려면, 턴을 시작한 프롬프트를 선택하고 **Restore code** 또는 **Restore code and conversation**을 선택합니다. 이렇게 하면 메시지가 도착하기 전의 편집을 포함하여 전체 턴에서 Claude가 수행한 파일 편집이 되돌려집니다.

### Symlink 및 hard link 경로가 복원되지 않음

Checkpointing은 symlink 또는 hard link된 파일을 rewind하지 않습니다. `/rewind` 메뉴에서 **Restore code** 또는 **Restore code and conversation**을 선택하면, Claude Code는 symlink 또는 hard link인 추적된 경로를 건너뛰고 `Restored the code, but skipped N files` 경고를 표시합니다. 건너뛴 파일은 현재 내용을 유지합니다. 세션의 변경 사항 중 하나를 실행 취소하려면 Claude에 편집을 되돌리도록 요청하거나 파일을 직접 편집합니다. dotfile manager가 프로젝트에 symlink하는 구성 파일과 pnpm이 제자리에 hard link하는 파일 모두 이 범주에 해당합니다.

restore가 건너뛰는 경로를 확인하려면 restore 전에 `/debug`로 debug logging을 켭니다: `~/.claude/debug/<session-id>.txt`의 debug log는 건너뛴 각 경로를 나열합니다. 모든 건너뛰기 이유와 복구 단계는 [error reference의 skipped-files 항목](https://code.claude.com/docs/ko/errors.md#restored-the-code-but-skipped-files)을 참조합니다.

### 버전 관리의 대체가 아님

Checkpoint는 빠른 세션 수준의 복구를 위해 설계되었습니다. 영구적인 버전 기록 및 협업을 위해 Git과 같은 버전 관리를 계속 사용하여 커밋, 분기 및 장기 기록을 유지합니다.

## 참고 항목

* [Interactive mode](https://code.claude.com/docs/ko/interactive-mode.md) - 키보드 단축키 및 세션 제어
* [Commands](https://code.claude.com/docs/ko/commands.md) - `/rewind`를 사용하여 checkpoint에 액세스
* [CLI reference](https://code.claude.com/docs/ko/cli-reference.md) - 명령줄 옵션
