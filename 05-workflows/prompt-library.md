> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 프롬프트 라이브러리

> Claude Code에 복사하여 붙여넣을 수 있는 프롬프트 모음으로, 작업과 역할별로 태그가 지정되어 있습니다.

이것은 Claude Code에 복사하여 붙여넣을 수 있는 프롬프트 라이브러리입니다. 이를 사용하여 아직 시도하지 않은 작업 방식을 탐색하거나 어디서부터 시작해야 할지 확실하지 않을 때 활용하십시오.

프롬프트는 [일반적인 워크플로우](/ko/common-workflows), [모범 사례](/ko/best-practices), [Anthropic 팀이 Claude Code를 사용하는 방법](https://claude.com/blog/how-anthropic-teams-use-claude-code)을 포함한 다양한 Anthropic 가이드에서 수집되었습니다. 이들은 스크립트가 아닌 시작점입니다. 모든 프롬프트 아래의 **이것이 작동하는 이유**를 열어 패턴을 확인하면 자신만의 프롬프트를 작성할 수 있습니다.

<h2 id="what-makes-these-prompts-work">
  이 프롬프트가 작동하는 이유
</h2>

위의 프롬프트는 몇 가지 패턴을 공유합니다. 이를 인식하면 여기의 모든 프롬프트를 자신의 작업에 맞게 조정할 수 있습니다.

**단계가 아닌 결과를 설명하십시오.** 원하는 것을 말하고 Claude가 파일을 찾도록 하십시오. 아래 프롬프트는 단일 파일 경로를 지정하지 않고도 작동합니다.

```text theme={null}
공개 API에 속도 제한을 추가하고 기존 테스트가 여전히 통과하는지 확인하십시오
```

**자신의 작업을 확인할 수 있는 방법을 제공하십시오.** 같은 프롬프트에서 실행, 테스트, 비교 또는 검증을 요청하면 Claude가 한 번의 시도 후 중지하지 않고 반복합니다.

```text theme={null}
마이그레이션을 작성하고, 개발 데이터베이스에 대해 실행하고, 스키마가 일치하는지 확인하십시오
```

**참조를 지적하십시오.** 기존 파일, 테스트 또는 패턴의 이름을 지정하여 새 코드가 이미 있는 것과 일치하도록 하십시오.

```text theme={null}
프로필 페이지와 동일한 레이아웃을 따르는 설정 페이지를 추가하십시오
```

**측정 가능한 목표를 명시하십시오.** 목표가 성능이나 커버리지일 때 메트릭과 임계값을 제공하면 완료가 명확합니다.

```text theme={null}
번들 크기를 200KB 미만으로 줄이고 제거한 항목을 보여주십시오
```

**아티팩트를 제공하십시오.** 오류, 로그, 스크린샷 및 계획 출력을 프롬프트에 직접 붙여넣거나 `@`를 입력하여 파일을 참조하십시오. Claude가 설명 대신 소스를 읽습니다.

```text theme={null}
빌드가 실패하는 이유는 무엇입니까? @build.log
```

**답변을 원하는 방식을 말하십시오.** 형식, 길이 또는 대상을 지정하면 설명이 사용 방식에 맞습니다. 모든 응답에 대해 형식을 기본값으로 만들려면 [출력 스타일](/ko/output-styles)을 설정하십시오.

```text theme={null}
결제 재시도 로직이 어떻게 작동하는지 다이어그램이 있는 HTML 페이지로 설명한 후 브라우저에서 열어주십시오
```

각 패턴에 대한 자세한 내용은 [모범 사례](/ko/best-practices)를 참조하십시오.

<h2 id="where-these-come-from">
  이들이 어디서 나왔는지
</h2>

이 프롬프트는 게시된 Anthropic 리소스의 패턴을 기반으로 합니다. 각 카드는 소스에 연결됩니다:

* [일반적인 워크플로우](/ko/common-workflows): 핵심 작업에 대한 단계별 가이드
* [모범 사례](/ko/best-practices): 프롬프팅 패턴 및 프로젝트 설정
* [Anthropic 팀이 Claude Code를 사용하는 방법](https://claude.com/blog/how-anthropic-teams-use-claude-code): 엔지니어링, 제품, 디자인 및 데이터 팀의 실제 워크플로우, [법률](https://claude.com/blog/how-anthropic-uses-claude-legal), [마케팅](https://claude.com/blog/how-anthropic-uses-claude-marketing), [사이버보안](https://claude.com/blog/how-anthropic-uses-claude-cybersecurity)에 대한 심화 학습
* [에이전트 코딩 확장 가이드](https://resources.anthropic.com/hubfs/Scaling%20agentic%20coding%20across%20your%20organization.pdf): 엔터프라이즈 채택 가이드

이 패턴의 비디오 연습을 보려면 Anthropic Academy의 무료 [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action) 과정을 참조하십시오.

<h2 id="related-resources">
  관련 리소스
</h2>

이 페이지의 프롬프트는 시작점입니다. 하나가 프로젝트에 작동하면 다음 단계는 반복 가능하게 만드는 것입니다. [스킬](/ko/skills)로 저장하면 팀의 누구나 `/command`로 실행할 수 있고, Claude가 학습한 규칙을 [CLAUDE.md](/ko/memory)에 기록하면 매 세션이 Claude가 다시 학습하는 대신 그 컨텍스트로 시작합니다. 더 크거나 위험한 변경의 경우 [계획 모드](/ko/permission-modes#analyze-before-you-edit-with-plan-mode)는 편집이 발생하기 전에 파일 목록을 표시합니다.

Claude Code를 팀 전체에 도입하는 경우 관리되는 설정 및 정책에 대해 [관리](/ko/admin-setup)를 참조하고, 이 작업이 계획에서 어떻게 청구되는지에 대해 [비용 및 사용](/ko/costs)을 참조하십시오.
