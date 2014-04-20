---
layout: page
title: "Regular Expression Recipes"
comments: true
sharing: true
footer: true
---
## Identical character repetition detection
Match 2 repetitions of a character

    (.)\1

Match 3 repetitions of a character

    (.)\1{2}

Match 3 or more repetitions of a character

    (.)\1{2,}

**Note**: `\1` is referring to to group matched just before it.

## Matching beginning, and ending characters of input, or every line of input

Regex *Anchors* are used for this purpose. 

`\A` matches the beginning of the whole input string (the position, not a character). It does not match beginning of every line of input.

`^` in single line mode matches the beginning of the whole input; while in multi-line mode matches the beginning of every line of input. So it's behaviour is dependent upon how the regex engine has been instantiated.

`\Z` matches the end of the whole input string (again the position, not a character). It does not match end of every line of input. Matches the final line break only if the string ends with a *single* line break.

`\z` quite similar to `\Z` except that it never matches the final line break, even if the string ends with a single one.

`$` in single line mode matches the end of the whole input; while in multi-line mode matches the end of every line of input. It does not match lines that contain only line-breaks. In single line mode it behaves like `\Z`, i.e., it matches the final line break only if the input string ends with a single one.

Note that whenever `\Z`, and `$` match the final line breaks, they match the actual character, not the position. Therefore `.\Z` and `.$` patterns both match the character right before line-break.

