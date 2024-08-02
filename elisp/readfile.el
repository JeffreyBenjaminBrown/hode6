(defun file-contents ( filename )
  ;; Use this to read config files, if necessary.
  ( let ( ( file-contents "" ) )
    ( with-temp-buffer
      ( insert-file-contents filename )
      ( setq file-contents ( buffer-string ) ) )
    file-contents ) )
