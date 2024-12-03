# litdown

I wanted a way to write valid bash scripts that can easily be
transformed into documentation in the style of a notebook or some
other literate programming doc.  *litdown* is a simple Perl script
that transforms your source code files into markdown-formatted
documents. It treats specially prefixed comments as markdown text and
the remaining code as code blocks. This allows you to write executable
scripts or programs that are also well-documented in markdown,
facilitating literate programming practices.


## Features


- *Literate Programming*: Write documentation and code in the same file.
- *Markdown Generation*: Converts specially prefixed comments into markdown text.
- *Code Blocks*: Wraps code sections in fenced code blocks with appropriate syntax highlighting.
- *Customizable Comment Prefix*: Supports different comment styles for various programming languages.
- *Easy Integration*: Simple to use in scripts, build processes, or documentation pipelines.

## Installation

1. Clone the repository

```bash
git clone https://github.com/praetoriansentry/litdown.git
```

2. Make the script executable

```bash
cd litdown
chmod +x litdown.pl
```

3. *Optional* move the script into your `PATH`

```bash
sudo cp litdown.pl /usr/local/bin/litdown
````

## Usage

### Basic Usage

```bash
./litdown.pl [--prefix 'COMMENT_PREFIX'] input_file > output.md
```

- `--prefix`: (Optional) The comment prefix used to identify markdown lines. Defaults to `# `.
- `input_file`: The source code file to process.
- `output.md`: The generated markdown file.

### Options

- `--prefix 'COMMENT_PREFIX'`: Specifies the comment prefix for
  markdown lines. Adjust this based on your programming language's
  comment style.

### Examples

#### Example 1: Processing a Bash Script

This is the `example.sh` bash script:

```bash
#!/bin/bash

# # My Bash Script
# This script demonstrates how to convert comments into markdown.

echo "Hello, World!"

# Now we will list the contents of the current directory.
ls -l

# The script ends here.
```

We would use a command like this to generate the markdown file

```bash
./litdown.pl example.sh > example.md
```

This is the expected output:
````markdown
```sh
#!/bin/bash
```

# My Bash Script
This script demonstrates how to convert comments into markdown.

```sh
echo "Hello, World!"
```

Now we will list the contents of the current directory.

```sh
ls -l
```

The script ends here.

````

#### Example 2: Processing a Go Program

This is an example with Go.

```go
// # My Go Program
// This program demonstrates how to use litdown with Go.

package main

import "fmt"

// Main function
func main() {
	fmt.Println("Hello, World!")
}

// The program ends here.
```

Using this command:

```bash
./litdown.pl --prefix "// " example.go > example.md
```

We would get this output:

````markdown
# My Go Program
This program demonstrates how to use litdown with Go.

```go
package main

import "fmt"
```

Main function

```go
func main() {
	fmt.Println("Hello, World!")
}
```

The program ends here.

````

### Converting to Other Formats

Once your literate code is converted to markdown, you can use
[pandoc](https://pandoc.org) or some other markdown processor to
covert the generated markdown file to HTML, PDF, etc.


```bash
pandoc example.md -o example.html
```
