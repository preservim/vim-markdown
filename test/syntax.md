# Original markdown

This section covers only features from the [original markdown](daringfireball.net/projects/markdown/syntax), in the same order that they are defined on the specification.

Extensions will be tested on a separate section.

## Paragraphs

Paragraph.

Line  
break.

## Headers

The following should be highlighted as headers:

# h1

 # h1

# h1 #

h1
==

## h2

## h2 ##

h2
--

### h3

#### h4

##### h5

###### h6

The following is unspecified by Markdown and may not highlight properly:

####### h7

## Blockquotes

> Block quote

> First line only
block quote

> Block quote
> > Block quote level 2

> # Markdown inside block quote
>
> [Link text](link-url)

## Lists

Only the list marker should be highlighted:

* 0
* 1

+ 0
+ 1

- 0
- 1

1. 0
2. 1

*Not* lists:

1 0

 - 0

## Links

[Link text](link-url)

Reference style link: [Link text][reference]

With space: [Link text] [reference]

[reference]: address
[reference2]: address "Optional Title"

## Code blocks

Inline: `inline code`

Indented:

    indented code block

    # not a header

    - not a list

Indented code block and lists:

- 0

    Paragraph.

        indented code block inside list

- 0

    - 1

        Paragraph (TODO FAIL).

            indented code block inside list

## Emphasis

The following should be italicized:

*single asterisks*

_single underscores_

The following should be boldface:

**double asterisks**

__double underscores__

# Extensions

Fenced code blocks TODO add option to turn ON/OFF:

```
fenced code block
```

Fenced code living in an indented environment is correctly highlighted:

1. run this command to do this:

    ```
some command
    ```

2. Subsequent list items are correctly highlighted.

Fenced code block with language:

```ruby
def f
  0
end
```
