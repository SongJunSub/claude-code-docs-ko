> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# worktree를 사용하여 병렬 세션 실행

> git worktree에서 병렬 Claude Code 세션을 격리하여 변경 사항이 충돌하지 않도록 합니다. `--worktree` 플래그, 서브에이전트 격리, `.worktreeinclude`, 정리 및 비git VCS 훅을 다룹니다.

[git worktree](https://git-scm.com/docs/git-worktree)는 자체 파일과 브랜치를 가진 별도의 작업 디렉토리이며, 메인 체크아웃과 동일한 저장소 히스토리 및 원격을 공유합니다. 각 Claude Code 세션을 자체 worktree에서 실행하면 한 세션의 편집이 다른 세션의 파일을 건드리지 않으므로, Claude가 한 터미널에서 기능을 구축하는 동안 두 번째 터미널에서 버그를 수정할 수 있습니다.

이 페이지는 CLI의 worktree 격리를 다룹니다. 아래의 모든 내용은 git 저장소를 가정합니다. 다른 버전 관리 시스템의 경우 [비git 버전 관리](#non-git-version-control)를 참조하세요. [데스크톱 앱](/ko/desktop#work-in-parallel-with-sessions)은 모든 새 세션에 대해 자동으로 worktree를 생성합니다.

Worktree는 Claude를 병렬로 실행하는 여러 방법 중 하나입니다. 이들은 파일 편집을 격리하는 반면, [서브에이전트](/ko/sub-agents)와 [에이전트 팀](/ko/agent-teams)은 작업 자체를 조정합니다. [Claude를 병렬로 실행](/ko/agents)을 참조하여 접근 방식을 비교하거나, [worktree로 서브에이전트 격리](#isolate-subagents-with-worktrees)로 건너뛰어 worktree와 서브에이전트를 함께 사용합니다.

<h2 id="start-claude-in-a-worktree">
  worktree에서 Claude 시작
</h2>

`--worktree` 또는 `-w`를 전달하여 격리된 worktree를 생성하고 Claude를 시작합니다. 기본적으로 worktree는 저장소 루트의 `.claude/worktrees/<value>/` 아래에 생성되며, `worktree-<value>`라는 새 브랜치에 생성됩니다:

```bash theme={null}
claude --worktree feature-auth
```

worktree를 다른 곳에 배치하려면 [`WorktreeCreate` 훅](#non-git-version-control)을 구성하세요. 다른 터미널에서 다른 이름으로 명령을 다시 실행하여 두 번째 격리된 세션을 시작합니다:

```bash theme={null}
claude --worktree bugfix-123
```

이름을 생략하면 Claude가 `bright-running-fox`와 같은 이름을 생성합니다:

```bash theme={null}
claude --worktree
```

세션 중에 Claude에게 "worktree에서 작업하기"를 요청할 수도 있으며, [`EnterWorktree`](/ko/tools-reference) 도구로 하나를 생성합니다. worktree에 들어가면 Claude는 `.claude/worktrees/` 아래의 다른 worktree로 `EnterWorktree`를 호출하여 직접 전환할 수 있습니다. 이전 worktree는 디스크에 그대로 남아 있습니다.

처음으로 디렉터리에서 `--worktree`를 사용하기 전에 해당 디렉터리에서 `claude`를 한 번 실행하여 작업 공간 신뢰 대화를 수락합니다. 신뢰가 아직 수락되지 않았으면 `--worktree`는 오류와 함께 종료되고 먼저 디렉터리에서 `claude`를 실행하도록 요청합니다. `-p`를 사용한 비대화형 실행은 [신뢰 확인](/ko/security)을 건너뛰므로 `claude -p --worktree`는 이를 수행하지 않고 진행됩니다.

<Tip>
  `.claude/worktrees/`를 `.gitignore`에 추가하여 worktree 내용이 메인 체크아웃에서 추적되지 않은 파일로 나타나지 않도록 합니다.
</Tip>

<h3 id="choose-the-base-branch">
  기본 브랜치 선택
</h3>

Worktree는 저장소의 기본 브랜치인 `origin/HEAD`에서 분기되므로 원격과 일치하는 깨끗한 트리에서 시작합니다. 원격이 구성되지 않았거나 페치가 실패하면 worktree는 현재 로컬 `HEAD`로 폴백합니다. 대신 항상 로컬 `HEAD`에서 분기하려면 [설정](/ko/settings#worktree-settings)에서 `worktree.baseRef`를 `"head"`로 설정합니다. `baseRef`를 `"head"`로 설정하면 새 worktree가 푸시되지 않은 커밋과 기능 브랜치 상태를 유지하므로, 진행 중인 작업에서 작동해야 하는 서브에이전트를 격리할 때 유용합니다. 설정은 `"fresh"` 또는 `"head"`만 허용하며, 임의의 git ref는 허용하지 않습니다:

```json theme={null}
{
  "worktree": {
    "baseRef": "head"
  }
}
```

특정 풀 요청에서 분기하려면 `#`이 앞에 붙은 PR 번호 또는 전체 GitHub 풀 요청 URL을 전달합니다. Claude Code는 `origin`에서 `pull/<number>/head`를 페치하고 `.claude/worktrees/pr-<number>`에서 worktree를 생성합니다:

```bash theme={null}
claude --worktree "#1234"
```

worktree 생성 방식을 완전히 제어하려면 [`WorktreeCreate` 훅](/ko/hooks#worktreecreate)을 구성하여 기본 `git worktree` 로직을 완전히 대체합니다.

<h2 id="copy-gitignored-files-into-worktrees">
  gitignored 파일을 worktree로 복사
</h2>

Worktree는 새로운 체크아웃이므로 메인 저장소의 `.env` 또는 `.env.local`과 같은 추적되지 않은 파일이 없습니다. Claude가 worktree를 생성할 때 자동으로 복사하려면 프로젝트 루트에 `.worktreeinclude` 파일을 추가합니다.

파일은 `.gitignore` 구문을 사용합니다. 패턴과 일치하고 gitignored된 파일만 복사되므로 추적된 파일은 절대 중복되지 않습니다.

이 `.worktreeinclude`는 두 개의 env 파일과 시크릿 구성을 각 새 worktree로 복사합니다:

```text .worktreeinclude theme={null}
.env
.env.local
config/secrets.json
```

이는 `--worktree`로 생성된 worktree, [서브에이전트 worktree](#isolate-subagents-with-worktrees) 및 [데스크톱 앱](/ko/desktop#work-in-parallel-with-sessions)의 병렬 세션에 적용됩니다.

<h2 id="isolate-subagents-with-worktrees">
  worktree로 서브에이전트 격리
</h2>

서브에이전트는 자체 worktree에서 실행될 수 있으므로 병렬 편집이 충돌하지 않습니다. Claude에게 "에이전트에 worktree 사용"을 요청하거나, [사용자 정의 서브에이전트](/ko/sub-agents#supported-frontmatter-fields)에서 frontmatter에 `isolation: worktree`를 추가하여 영구적으로 설정합니다. 각 서브에이전트는 서브에이전트가 변경 없이 완료되면 자동으로 제거되는 임시 worktree를 가져옵니다.

서브에이전트 worktree는 `--worktree`와 동일한 [기본 분기](#choose-the-base-branch)를 사용하므로, `worktree.baseRef`가 `"head"`로 설정되지 않은 한 저장소의 기본 분기에서 분기합니다.

<h2 id="clean-up-worktrees">
  worktree 정리
</h2>

worktree 세션을 종료할 때 정리는 변경 사항을 만들었는지 여부에 따라 달라집니다:

* **커밋되지 않은 변경 사항 없음, 추적되지 않은 파일 없음, 새로운 커밋 없음**: worktree와 해당 브랜치가 자동으로 제거됩니다. 세션에 [이름](/ko/sessions#name-your-sessions)이 있으면 Claude는 대신 프롬프트를 표시하여 나중을 위해 worktree를 유지할 수 있습니다
* **커밋되지 않은 변경 사항, 추적되지 않은 파일 또는 새로운 커밋 존재**: Claude는 worktree를 유지하거나 제거할지 묻습니다. 유지하면 디렉토리와 브랜치가 보존되어 나중에 돌아올 수 있습니다. 제거하면 worktree 디렉토리와 해당 브랜치가 삭제되어 커밋되지 않은 모든 변경 사항, 추적되지 않은 파일 및 커밋이 버려집니다
* **비대화형 실행**: `--worktree`와 함께 `-p`로 생성된 worktree는 종료 프롬프트가 없으므로 자동으로 정리되지 않습니다. `git worktree remove`로 제거합니다

Claude가 서브에이전트 및 [백그라운드 세션](/ko/agent-view#how-file-edits-are-isolated)을 위해 생성한 worktree는 [`cleanupPeriodDays`](/ko/settings#available-settings) 설정보다 오래되면 자동으로 제거되며, 커밋되지 않은 변경 사항, 추적되지 않은 파일 및 푸시되지 않은 커밋이 없는 경우입니다. `--worktree`로 생성한 worktree는 이 스윕으로 절대 제거되지 않습니다.

에이전트가 실행 중인 동안 Claude는 해당 worktree에서 `git worktree lock`을 실행하여 동시 정리가 이를 제거할 수 없도록 합니다. 에이전트가 완료되면 잠금이 해제됩니다. 스윕이 유지하는 worktree를 정리하려면 `git worktree remove`를 실행하고, worktree에 커밋되지 않은 변경 사항이나 추적되지 않은 파일이 있으면 `--force`를 추가합니다.

<h2 id="manage-worktrees-manually">
  worktree 수동 관리
</h2>

worktree 위치 및 브랜치 구성을 완전히 제어하려면 Git으로 직접 worktree를 생성합니다. 이는 특정 기존 브랜치를 체크아웃하거나 worktree를 저장소 외부에 배치해야 할 때 유용합니다.

새 브랜치에서 worktree 생성:

```bash theme={null}
git worktree add ../project-feature-a -b feature-a
```

기존 브랜치에서 worktree 생성:

```bash theme={null}
git worktree add ../project-bugfix bugfix-123
```

worktree에서 Claude 시작:

```bash theme={null}
cd ../project-feature-a && claude
```

worktree 나열:

```bash theme={null}
git worktree list
```

완료되면 제거:

```bash theme={null}
git worktree remove ../project-feature-a
```

전체 명령 참조는 [Git worktree 문서](https://git-scm.com/docs/git-worktree)를 참조하세요. 각 새 worktree에서 개발 환경을 초기화하는 것을 잊지 마세요: 종속성 설치, 가상 환경 설정 또는 프로젝트의 설정이 필요한 모든 작업을 실행합니다.

<h2 id="non-git-version-control">
  비git 버전 관리
</h2>

Worktree 격리는 기본적으로 git을 사용합니다. SVN, Perforce, Mercurial 또는 기타 시스템의 경우 [`WorktreeCreate` 및 `WorktreeRemove` 훅](/ko/hooks#worktreecreate)을 구성하여 사용자 정의 생성 및 정리 로직을 제공합니다. 훅이 기본 git 동작을 대체하므로 `--worktree`를 사용할 때 [`.worktreeinclude`](#copy-gitignored-files-into-worktrees)가 처리되지 않습니다. 훅 스크립트 내에서 대신 로컬 구성 파일을 복사합니다.

이 `WorktreeCreate` 훅은 stdin에서 worktree 이름을 읽고, 새로운 SVN 작업 복사본을 체크아웃하고, Claude Code가 세션의 작업 디렉토리로 사용할 수 있도록 디렉토리 경로를 인쇄합니다:

```json theme={null}
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'NAME=$(jq -r .name); DIR=\"$HOME/.claude/worktrees/$NAME\"; svn checkout https://svn.example.com/repo/trunk \"$DIR\" >&2 && echo \"$DIR\"'"
          }
        ]
      }
    ]
  }
}
```

세션이 끝날 때 정리하려면 `WorktreeRemove` 훅과 쌍을 이룹니다. 입력 스키마 및 제거 예제는 [훅 참조](/ko/hooks#worktreecreate)를 참조하세요.

<h2 id="see-also">
  참고 항목
</h2>

Worktree는 파일 격리를 처리합니다. 아래의 관련 페이지는 이러한 격리된 체크아웃으로 작업을 위임하고 생성한 세션 간에 전환하는 것을 다룹니다:

* [서브에이전트](/ko/sub-agents): 세션 내의 격리된 에이전트에 작업 위임
* [에이전트 팀](/ko/agent-teams): 여러 Claude 세션을 자동으로 조정
* [세션 관리](/ko/sessions): 대화 이름 지정, 재개 및 전환
* [데스크톱 병렬 세션](/ko/desktop#work-in-parallel-with-sessions): 데스크톱 앱의 worktree 기반 세션
