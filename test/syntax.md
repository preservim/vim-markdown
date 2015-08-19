# Fenced code living in an indented environment is correctly highlighted

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

# Links

[a](b "c")

[a]()

[good spell](a)

[badd spell](a)

[a](b "c")

[a]( b
"c" )

a (`a`) b. Fix: <https://github.com/plasticboy/vim-markdown/issues/113>

Escaped:

\[a](b)

[a\]b](c)

## Known failures

Escape does not work:

[a\](b)

Should not be links because of whitespace:

[a] (b)

[a](a
b)

[a](a b)

# Reference links

Single links:

[a][b]

[good spell][a]

[badd spell][a]

[a][]

[a] []

[a][b] c [d][e]

Reference link followed by inline link:

[a] [b](c)

## Known failures

Should be shortcut reference links:

[a]

[a] b [c]

Should be a single link:

[a] [b]

[a] b [c](d)

# Italics, bold and bold+italics

The 'ipsum', escaped characters and 'dolor' should all be italic:

lorem *ipsum\*dolor* sit

lorem _ipsum\_dolor_ sit

The 'ipsum', escaped characters and 'dolor' should all be bold:

lorem **ipsum\*\*dolor** sit

lorem __ipsum\_\_dolor__ sit

The 'ipsum', escaped characters and 'dolor' should all be bold+italic:

lorem ***ipsum\*\*\*dolor*** sit

lorem ___ipsum\_\_\_dolor___ sit

The escaped character and 'lorem' should be plain, and the 'ipsum' italic:

\*lorem*ipsum*

## Known failures

The escaped character and 'lorem' should be plain, and the 'ipsum' italic:

\_lorem_ipsum_

The 'lorem' should be italic, and 'ipsum dolor' bold:

\**lorem***ipsum dolor**

\__lorem___ipsum dolor__

The 'lorem' should be bold, and 'ipsum dolor' bold+italics:

\***lorem*****ipsum dolor***

\___lorem_____ipsum dolor___

