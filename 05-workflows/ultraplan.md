> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 클라우드에서 Ultraplan으로 계획하기

> CLI에서 계획을 시작하고, 웹의 Claude Code에서 초안을 작성한 다음, 원격으로 또는 터미널로 돌아가서 실행합니다

<Note>
  Ultraplan은 연구 미리보기 상태이며 Claude Code v2.1.91 이상이 필요합니다. 피드백에 따라 동작 및 기능이 변경될 수 있습니다.
</Note>

Ultraplan은 로컬 CLI의 계획 작업을 [계획 모드](/ko/permission-modes#analyze-before-you-edit-with-plan-mode)에서 실행 중인 [웹의 Claude Code](/ko/claude-code-on-the-web) 세션으로 전달합니다. Claude는 클라우드에서 계획을 초안하는 동안 터미널에서 계속 작업할 수 있습니다. 계획이 준비되면 브라우저에서 열어 특정 섹션에 대해 의견을 남기고, 수정을 요청하고, 실행할 위치를 선택할 수 있습니다.

이는 터미널이 제공하는 것보다 더 풍부한 검토 표면을 원할 때 유용합니다:

* **대상 피드백**: 전체에 회신하는 대신 계획의 개별 섹션에 대해 의견을 남깁니다
* **자동 초안 작성**: 계획이 원격으로 생성되므로 터미널이 다른 작업을 위해 자유로워집니다
* **유연한 실행**: 웹에서 실행하고 풀 요청을 열도록 계획을 승인하거나 터미널로 다시 보냅니다

Ultraplan은 [웹의 Claude Code](/ko/claude-code-on-the-web) 계정과 GitHub 저장소가 필요합니다. Anthropic의 클라우드 인프라에서 실행되므로 Amazon Bedrock, Google Cloud Vertex AI 또는 Microsoft Foundry를 사용할 때는 사용할 수 없습니다. 클라우드 세션은 계정의 기본 [클라우드 환경](/ko/claude-code-on-the-web#the-cloud-environment)에서 실행됩니다. 아직 클라우드 환경이 없으면 ultraplan이 처음 시작할 때 자동으로 생성합니다.

<h2 id="launch-ultraplan-from-the-cli">
  CLI에서 ultraplan 시작하기
</h2>

로컬 CLI 세션에서 세 가지 방법으로 ultraplan을 시작할 수 있습니다:

* **명령어**: `/ultraplan` 다음에 프롬프트를 입력합니다
* **키워드**: 일반 프롬프트의 어디든 `ultraplan` 단어를 포함합니다
* **로컬 계획에서**: Claude가 로컬 계획을 완료하고 승인 대화상자를 표시할 때, **아니요, Claude Code 웹에서 Ultraplan으로 개선하기**를 선택하여 초안을 클라우드로 보내 추가 반복합니다

예를 들어, 명령어로 서비스 마이그레이션을 계획하려면:

```
/ultraplan migrate the auth service from sessions to JWTs
```

명령어 및 키워드 경로는 시작하기 전에 확인 대화상자를 엽니다. 로컬 계획 경로는 해당 선택이 이미 확인 역할을 하므로 이 대화상자를 건너뜁니다. [Remote Control](/ko/remote-control)이 활성화되어 있으면 두 기능이 claude.ai/code 인터페이스를 차지하고 한 번에 하나만 연결될 수 있으므로 ultraplan이 시작될 때 연결이 끊깁니다.

클라우드 세션이 시작된 후 CLI의 프롬프트 입력은 클라우드 세션이 작동하는 동안 상태 표시기를 표시합니다:

| 상태                             | 의미                                           |
| :----------------------------- | :------------------------------------------- |
| `◇ ultraplan`                  | Claude가 코드베이스를 조사하고 계획을 초안하는 중입니다            |
| `◇ ultraplan needs your input` | Claude가 명확히 하는 질문을 가지고 있습니다. 세션 링크를 열어 응답하세요 |
| `◆ ultraplan ready`            | 계획이 브라우저에서 검토할 준비가 되었습니다                     |

`/tasks`를 실행하고 ultraplan 항목을 선택하여 세션 링크, 에이전트 활동 및 **ultraplan 중지** 작업이 있는 상세 보기를 엽니다. ultraplan을 중지하면 클라우드 세션이 보관되고 표시기가 지워집니다. 터미널에 아무것도 저장되지 않습니다.

<h2 id="review-and-revise-the-plan-in-your-browser">
  브라우저에서 계획 검토 및 수정하기
</h2>

상태가 `◆ ultraplan ready`로 변경되면 세션 링크를 열어 claude.ai에서 계획을 봅니다. 계획은 전용 검토 보기에 나타납니다:

* **인라인 댓글**: 모든 구절을 강조 표시하고 Claude가 처리할 댓글을 남깁니다
* **이모지 반응**: 섹션에 반응하여 전체 댓글을 작성하지 않고 승인 또는 우려를 신호합니다
* **개요 사이드바**: 계획의 섹션 간에 이동합니다

Claude에게 댓글을 처리하도록 요청하면 계획을 수정하고 업데이트된 초안을 제시합니다. 실행할 위치를 선택하기 전에 필요한 만큼 반복할 수 있습니다.

<h2 id="choose-where-to-execute">
  실행 위치 선택하기
</h2>

계획이 올바르면 브라우저에서 Claude가 동일한 클라우드 세션에서 구현할지 또는 대기 중인 터미널로 다시 보낼지 선택합니다.

<h3 id="execute-on-the-web">
  웹에서 실행
</h3>

브라우저에서 **Claude의 계획을 승인하고 코딩 시작**을 선택하여 Claude가 동일한 Claude Code 웹 세션에서 구현하도록 합니다. 터미널에 확인이 표시되고, 상태 표시기가 지워지고, 작업이 클라우드에서 계속됩니다. 구현이 완료되면 [변경 사항 검토](/ko/claude-code-on-the-web#review-changes)하고 웹 인터페이스에서 풀 요청을 만듭니다.

<h3 id="send-the-plan-back-to-your-terminal">
  계획을 터미널로 다시 보내기
</h3>

브라우저에서 **계획을 승인하고 터미널로 텔레포트**를 선택하여 환경에 완전히 액세스하여 계획을 로컬로 구현합니다. 이 옵션은 세션이 CLI에서 시작되었고 터미널이 여전히 폴링 중일 때 나타납니다. 웹 세션이 보관되므로 병렬로 계속 작동하지 않습니다.

터미널은 **Ultraplan approved** 제목의 대화상자에 계획을 표시하며 세 가지 옵션이 있습니다:

* **여기에서 구현**: 계획을 현재 대화에 주입하고 중단한 곳에서 계속합니다
* **새 세션 시작**: 현재 대화를 지우고 계획만을 컨텍스트로 새로 시작합니다
* **취소**: 계획을 파일에 저장하지 않고 실행합니다. Claude가 파일 경로를 인쇄하므로 나중에 돌아올 수 있습니다

새 세션을 시작하면 Claude가 상단에 `claude --resume` 명령어를 인쇄하므로 나중에 이전 대화로 돌아올 수 있습니다.

<h2 id="related-resources">
  관련 리소스
</h2>

* [웹의 Claude Code](/ko/claude-code-on-the-web): ultraplan이 실행되는 클라우드 인프라
* [계획 모드](/ko/permission-modes#analyze-before-you-edit-with-plan-mode): 로컬 세션에서 계획이 작동하는 방식
* [ultrareview로 버그 찾기](/ko/ultrareview): 병합 전에 문제를 포착하기 위한 ultraplan의 코드 검토 대응
* [Remote Control](/ko/remote-control): 자신의 머신에서 실행 중인 세션과 함께 claude.ai/code 인터페이스 사용
