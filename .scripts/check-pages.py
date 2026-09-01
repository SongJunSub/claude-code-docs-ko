#!/usr/bin/env python3
"""레포 일관성 검사 중 문자 단위 판정이 필요한 항목.

셸의 grep 으로 한글이나 특정 문장부호를 세면 로케일에 좌우된다.
macOS 의 LC_ALL=UTF-8 은 유효한 로케일명이 아니라 bash 에서 C 로케일로
떨어지고, 그러면 [가-힣] 이 바이트 범위로 해석돼 영문 파일을 한국어로
오판한다. 그래서 이 두 검사는 파이썬에서 코드포인트로 직접 처리한다.

글쓰기 규칙은 레포가 직접 작성한 문서에만 적용한다.
업스트림에서 받은 페이지는 원문이므로 대상이 아니다.

위반이 있으면 사유를 출력하고 exit 1.
"""

import glob
import pathlib
import re
import sys

# 영어 페이지 판정 기준: 한글 글자 수가 이 값 미만이면 영어로 본다
HANGUL_THRESHOLD = 200

MARKER = "ⓔ"

# 금지 문장부호. 한국어 실무 문서에서 쓰지 않아 기계가 쓴 티가 난다.
# 검사 대상 문자는 이 파일 자신이 걸리지 않도록 이스케이프로 적는다.
BANNED_PUNCTUATION = [
    ("\u2014", "em dash"),
    ("\u2013", "en dash"),
    ("\u00b7", "가운뎃점"),
]

# 레포가 직접 작성한 문서. 업스트림에서 받은 페이지는 원문이므로 대상이 아니다.
AUTHORED_GLOBS = ["0*/README.md", ".claude/commands/*.md", ".claude/agents/*.md"]
AUTHORED_FILES = ["README.md", "CLAUDE.md"]


def read(path):
    return pathlib.Path(path).read_text(encoding="utf-8", errors="replace")


def hangul_count(text):
    return sum(1 for ch in text if 0xAC00 <= ord(ch) <= 0xD7A3)


def authored_files():
    seen = []
    for name in AUTHORED_FILES:
        if pathlib.Path(name).exists():
            seen.append(name)
    for pattern in AUTHORED_GLOBS:
        seen.extend(sorted(glob.glob(pattern)))
    return seen


def check_markers():
    """카테고리 README 의 ⓔ 마커가 실제 영어 페이지와 일치하는지 확인한다."""
    row = re.compile(r"\|\s*\[[a-z0-9-]+\]\(([a-z0-9-]+)\.md\)\s*" + MARKER)
    marked = set()
    for readme in sorted(glob.glob("0*/README.md")):
        for line in read(readme).splitlines():
            found = row.match(line)
            if found:
                marked.add(found.group(1))

    actual = set()
    for page in sorted(glob.glob("0*/*.md")):
        path = pathlib.Path(page)
        if path.name == "README.md":
            continue
        if hangul_count(read(path)) < HANGUL_THRESHOLD:
            actual.add(path.stem)

    if marked == actual:
        return []
    return [
        "ⓔ 마커와 실제 영어 페이지 불일치",
        "      마커: " + (" ".join(sorted(marked)) or "(없음)"),
        "      실제: " + (" ".join(sorted(actual)) or "(없음)"),
    ]


def check_writing():
    """레포 자체 작성물에 금지 문장부호가 없는지 확인한다."""
    hits = []
    for name in authored_files():
        text = read(name)
        found = [(label, text.count(ch)) for ch, label in BANNED_PUNCTUATION if ch in text]
        if found:
            detail = ", ".join(f"{label} {count}" for label, count in found)
            hits.append(f"      {name}: {detail}")
    if not hits:
        return []
    labels = ", ".join(label for _, label in BANNED_PUNCTUATION)
    return [f"금지된 문장부호 사용 ({labels})"] + hits


def main():
    problems = check_markers() + check_writing()
    for line in problems:
        print(line, file=sys.stderr)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
