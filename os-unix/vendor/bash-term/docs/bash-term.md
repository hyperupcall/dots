## Index

* [term.cursor_to](#termcursor_to)
* [term.cursor_moveto](#termcursor_moveto)
* [term.cursor_up](#termcursor_up)
* [term.cursor_down](#termcursor_down)
* [term.cursor_forward](#termcursor_forward)
* [term.cursor_backward](#termcursor_backward)
* [term.cursor_line_next](#termcursor_line_next)
* [term.cursor_line_prev](#termcursor_line_prev)
* [term.cursor_horizontal](#termcursor_horizontal)
* [term.cursor_savepos](#termcursor_savepos)
* [term.cursor_restorepos](#termcursor_restorepos)
* [term.cursor_save](#termcursor_save)
* [term.cursor_restore](#termcursor_restore)
* [term.cursor_hide](#termcursor_hide)
* [term.cursor_show](#termcursor_show)
* [term.cursor_getpos](#termcursor_getpos)
* [term.erase_line_end](#termerase_line_end)
* [term.erase_line_start](#termerase_line_start)
* [term.erase_line](#termerase_line)
* [term.erase_screen_end](#termerase_screen_end)
* [term.erase_screen_start](#termerase_screen_start)
* [term.erase_screen](#termerase_screen)
* [term.erase_saved_lines](#termerase_saved_lines)
* [term.scroll_down](#termscroll_down)
* [term.scroll_up](#termscroll_up)
* [term.tab_set](#termtab_set)
* [term.tab_clear](#termtab_clear)
* [term.tab_clearall](#termtab_clearall)
* [term.screen_save](#termscreen_save)
* [term.screen_restore](#termscreen_restore)
* [term.style_reset](#termstyle_reset)
* [term.style_bold](#termstyle_bold)
* [term.style_dim](#termstyle_dim)
* [term.style_italic](#termstyle_italic)
* [term.style_underline](#termstyle_underline)
* [term.style_inverse](#termstyle_inverse)
* [term.style_hidden](#termstyle_hidden)
* [term.style_strikethrough](#termstyle_strikethrough)
* [term.style_hyperlink](#termstyle_hyperlink)
* [term.color_black](#termcolor_black)
* [term.color_red](#termcolor_red)
* [term.color_green](#termcolor_green)
* [term.color_orange](#termcolor_orange)
* [term.color_blue](#termcolor_blue)
* [term.color_purple](#termcolor_purple)
* [term.color_cyan](#termcolor_cyan)
* [term.color_light_gray](#termcolor_light_gray)
* [term.color_dark_gray](#termcolor_dark_gray)
* [term.color_light_red](#termcolor_light_red)
* [term.color_light_green](#termcolor_light_green)
* [term.color_yellow](#termcolor_yellow)
* [term.color_light_blue](#termcolor_light_blue)
* [term.color_light_purple](#termcolor_light_purple)
* [term.color_light_cyan](#termcolor_light_cyan)
* [term.color_white](#termcolor_white)
* [term.beep](#termbeep)
* [term.hyperlink](#termhyperlink)
* [term.bold](#termbold)
* [term.italic](#termitalic)
* [term.underline](#termunderline)
* [term.strikethrough](#termstrikethrough)

### term.cursor_to

Move the cursor position to a supplied row and column. Both default to `0` if not supplied

#### Arguments

* **$1** (int): row
* **$1** (int): column

### term.cursor_moveto

Moves cursor position to a supplied _relative_ row and column. Both default to `0` if not supplied (FIXME: implement)

#### Arguments

* **$1** (int): row
* **$1** (int): column

### term.cursor_up

Moves the cursor up. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_down

Moves the cursor down. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_forward

Moves the cursor forward. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_backward

Moves the cursor backwards. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_line_next

Moves the cursor to the next line. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_line_prev

Moves the cursor to the previous line. Defaults to `1` if not supplied

#### Arguments

* **$1** (int): count

### term.cursor_horizontal

Moves the cursor ?

#### Arguments

* **$1** (int): count

### term.cursor_savepos

Saves the current cursor position

_Function has no arguments._

### term.cursor_restorepos

Restores cursor to the last saved position

_Function has no arguments._

### term.cursor_save

Saves

_Function has no arguments._

### term.cursor_restore

Restores

_Function has no arguments._

### term.cursor_hide

Hides the cursor

_Function has no arguments._

### term.cursor_show

Shows the cursor

_Function has no arguments._

### term.cursor_getpos

Reports the cursor position to the application as (as though typed at the keyboard)

_Function has no arguments._

### term.erase_line_end

Erase from the current cursor position to the end of the current line

_Function has no arguments._

### term.erase_line_start

Erase from the current cursor position to the start of the current line

_Function has no arguments._

### term.erase_line

Erase the entire current line

_Function has no arguments._

### term.erase_screen_end

Erase the screen from the current line down to the bottom of the screen

_Function has no arguments._

### term.erase_screen_start

Erase the screen from the current line up to the top of the screen

_Function has no arguments._

### term.erase_screen

Erase the screen and move the cursor the top left position

_Function has no arguments._

### term.erase_saved_lines

_Function has no arguments._

### term.scroll_down

_Function has no arguments._

### term.scroll_up

_Function has no arguments._

### term.tab_set

_Function has no arguments._

### term.tab_clear

_Function has no arguments._

### term.tab_clearall

_Function has no arguments._

### term.screen_save

Save screen

_Function has no arguments._

### term.screen_restore

Restore screen

_Function has no arguments._

### term.style_reset

Construct reset

#### Arguments

* **$1** (string): text

### term.style_bold

Construct bold

#### Arguments

* **$1** (string): text

### term.style_dim

Construct dim

#### Arguments

* **$1** (string): text

### term.style_italic

Construct italic

#### Arguments

* **$1** (string): text

### term.style_underline

Construct underline

#### Arguments

* **$1** (string): text

### term.style_inverse

Construct inverse

#### Arguments

* **$1** (string): text

### term.style_hidden

Construct hidden

#### Arguments

* **$1** (string): text

### term.style_strikethrough

Construct strikethrough

#### Arguments

* **$1** (string): text

### term.style_hyperlink

Construct hyperlink

#### Arguments

* **$1** (string): text
* **$2** (string): url

### term.color_black

Construct black color

#### Arguments

* **$1** (string): text

### term.color_red

Construct red color

#### Arguments

* **$1** (string): text

### term.color_green

Construct green color

#### Arguments

* **$1** (string): text

### term.color_orange

Construct orange color

#### Arguments

* **$1** (string): text

### term.color_blue

Construct blue color

#### Arguments

* **$1** (string): text

### term.color_purple

Construct purple color

#### Arguments

* **$1** (string): text

### term.color_cyan

Construct cyan color

#### Arguments

* **$1** (string): text

### term.color_light_gray

Construct light gray color

#### Arguments

* **$1** (string): text

### term.color_dark_gray

Construct dark gray color

#### Arguments

* **$1** (string): text

### term.color_light_red

Construct light red color

#### Arguments

* **$1** (string): text

### term.color_light_green

Construct light green color

#### Arguments

* **$1** (string): text

### term.color_yellow

Construct yellow color

#### Arguments

* **$1** (string): text

### term.color_light_blue

Construct light blue color

#### Arguments

* **$1** (string): text

### term.color_light_purple

Construct light purple color

#### Arguments

* **$1** (string): text

### term.color_light_cyan

Construct light cyan color

#### Arguments

* **$1** (string): text

### term.color_white

Construct white color

#### Arguments

* **$1** (string): text

### term.beep

Construct a beep

_Function has no arguments._

### term.hyperlink

(DEPRECATED) Construct hyperlink

#### Arguments

* **$1** (string): text
* **$2** (string): url

### term.bold

(DEPRECATED) Construct bold

#### Arguments

* **$1** (string): text

### term.italic

(DEPRECATED) Construct italic

#### Arguments

* **$1** (string): text

### term.underline

(DEPRECATED) Construct underline

#### Arguments

* **$1** (string): text

### term.strikethrough

(DEPRECATED) Construct strikethrough

#### Arguments

* **$1** (string): text

