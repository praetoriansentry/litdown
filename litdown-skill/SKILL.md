---
name: litdown
description: Author literate programming source files using the litdown syntax — runnable source code (bash, Go, Python, etc.) where specially-prefixed comments are meant to render as markdown prose and everything else as fenced code blocks. Use when the user asks to write a "literate" script/program in litdown form, or any file that doubles as runnable code and markdown documentation.
---

# Authoring litdown files

litdown is a convention for writing a source file that is **valid, runnable code
first** and **readable markdown documentation second**. A separate renderer
turns the file into markdown by a simple line-based rule; this skill is about
structuring the source file correctly so it renders well. (Rendering is out of
scope — the user runs their own litdown tool for that.)

## The rule

A litdown renderer reads the file line by line, with one configurable **comment
prefix** (default `# `):

- **Prose line** — a line beginning with the prefix has the prefix stripped and
  becomes raw markdown. A line that is just the bare prefix character (e.g. a
  lone `#`) becomes a blank markdown line.
- **Code line** — every other line is collected into a fenced code block. The
  fence language is the file's extension (`.sh` → `sh`, `.go` → `go`).
  Consecutive code lines group into one block; the block closes when the next
  prose line appears.
- Leading/trailing blank lines inside a code block are trimmed.

That's the whole model. Structuring a good litdown file is just deciding which
lines are prose comments and which are code.

## Rules to get right when authoring

- **The prefix includes its trailing space.** `# ` matches `# hello` but not
  `#hello` and not `#!/bin/bash`. A shebang therefore stays code and the file
  remains executable — keep it as the first line.
- **Headings double the marker.** Prose is "prefix + markdown". So in a bash
  file (prefix `# `) a markdown `# Title` heading is written `# # Title`, and
  `## Subhead` is written `# ## Subhead`. In a `// ` file it's `// # Title`.
- **Separate prose from code with a bare-prefix blank line.** A lone `#` (or
  `//`) emits a blank markdown line and keeps paragraphs visually distinct from
  the code blocks that follow.
- **The prefix must be a real comment in the target language**, so the file
  still runs/compiles: `# ` for bash/python/ruby, `// ` for go/c/js/rust.
- **Prose is narrative between code blocks, not line annotations.** Write it
  like the cells of a notebook: a paragraph of explanation, then the code it
  describes. An inline comment dropped in the *middle* of a code section splits
  the block in two — avoid mid-block comments unless you actually want a prose
  break there.

## Pattern

For a request like "write a literate bash script that does X, Y, Z":

1. Write a correct, runnable script for the task as you normally would.
2. Add a title + intro paragraph at the top as prose comments.
3. Precede each logical section with a short prose comment explaining *why*,
   separated from the code by a bare-prefix blank line.
4. Leave the actual commands as plain code lines.

### Example (bash, default `# ` prefix)

```bash
#!/bin/bash

# # Backup script
# Archives a directory into a timestamped tarball at a destination path.

set -euo pipefail

# Capture the source and destination from the arguments.

SRC="$1"
DEST="$2"

# Build a timestamped filename so repeated runs don't clobber each other.

STAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE="$DEST/backup-$STAMP.tar.gz"

# Create the archive and report where it landed.

tar -czf "$ARCHIVE" "$SRC"
echo "Wrote $ARCHIVE"
```

When rendered: `# Backup script` becomes an `<h1>`, each prose comment becomes a
paragraph, and each run of commands becomes a ` ```sh ` code block. The shebang
and the commands stay as code, so the file is still a working script.

### Example (Go, `// ` prefix)

Same idea with `// ` comments — `// # Title` for the heading, `// ` paragraphs
between blocks of Go code. The renderer is pointed at the `// ` prefix for these
files.

## Checklist

- [ ] File still runs/compiles as-is (shebang first, commands uncommented).
- [ ] Prose uses the language's real comment prefix.
- [ ] Markdown headings use the doubled marker (`# # Title` / `// # Title`).
- [ ] Prose and code paragraphs separated by bare-prefix blank lines.
- [ ] No accidental mid-block comments splitting code you meant to keep together.
