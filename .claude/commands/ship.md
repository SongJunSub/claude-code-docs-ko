---
name: ship
description: 변경 사항을 논리 단위로 커밋하고 브랜치를 푸시한 뒤 PR을 만들고 머지까지 끝냅니다. sync 결과나 문서 수정을 master에 반영할 때 사용합니다.
allowed-tools: Bash Read
---

# /ship: 커밋부터 머지까지

변경 사항을 master 에 반영하는 전 과정을 한 번에 수행한다.
`master` 직접 push 는 여전히 금지이고, 반드시 브랜치와 PR 을 거친다.

## 절차

1. **사전 검증**. 실패하면 여기서 멈추고 사용자에게 사유를 보고한다.
   ```bash
   bash .scripts/check-repo.sh
   ```

2. **브랜치 준비**
   ```bash
   git rev-parse --abbrev-ref HEAD
   ```
   현재가 `master` 면 새 브랜치를 만든다. 이름 규칙은 다음과 같다.
   - 문서 동기화: `chore/sync-docs-<YYYY-MM-DD>`
   - 버그 수정: `fix/<slug>`
   - 기능 추가: `feat/<slug>`

3. **논리 단위 커밋**. 변경을 한 덩어리로 몰지 않는다.
   스크립트 수정, 문서 내용, 규칙 문서, README 표는 각각 별도 커밋으로 나눈다.
   Conventional Commits 형식을 쓰고 본문은 한국어로 무엇을 왜 고쳤는지 적는다.

4. **푸시**
   ```bash
   git push -u origin <branch>
   ```

5. **PR 생성**
   ```bash
   gh pr create --base master --title "<type>: <요약>" --body "<본문>"
   ```
   본문에는 변경 요약, 검증한 내용, 남은 이슈를 적는다.

6. **머지 가능 상태 확인**
   ```bash
   gh pr view <N> --json mergeStateStatus,statusCheckRollup
   ```
   - `mergeStateStatus` 가 `CLEAN` 이면 진행한다
   - CI 체크가 등록돼 있으면 전부 통과할 때까지 기다린다
   - `BLOCKED` 나 `DIRTY` 면 머지하지 않고 사용자에게 보고한다

7. **머지**
   ```bash
   gh pr merge <N> --merge --subject "<type>: <요약>"
   ```
   기존 이력이 merge commit 방식이므로 squash 로 바꾸지 않는다.

8. **로컬 master 갱신**
   ```bash
   git checkout master && git pull --ff-only origin master
   ```

9. **결과 보고**. 커밋 수, PR 번호, 머지 커밋 해시, 변경 파일 수를 함께 보고한다.

## 사용자에게 물어야 하는 경우

아래는 자동으로 넘기지 않고 멈춘다.

- 1 단계 사전 검증이 하나라도 실패
- 페이지 수가 매니페스트 줄 수와 다름 (문서가 사라졌거나 새로 생긴 것)
- `fetch.log` 의 `Failed` 가 0 이 아님
- sync 가 아닌데 변경 파일이 100 개를 넘음
- PR 에 사용자 아닌 리뷰어의 코멘트가 달려 있음
