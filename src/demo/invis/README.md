See `try_invisible_characters_hode.org` in my public notes:

:ID:       5aada471-bf64-4e6e-911d-292c4a7eb77c
#+title: try invisible characters \ Hode

# in brief

* plan
  Python keeps a list of (id, int) pairs,
  which represent the document.
  It writes to a file, where the id is invisible,
  at the start of each line.
  Emacs reads the file, displays it accordingly.
  I write three Emacs functions:
    delete-line-at-point,
    insert-line-after-point,
    increment-line-at-point.
  Each line begins as the int 0.
