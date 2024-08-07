(require 'json)

(defun text-file-as-string ( filename )
  ;; Use this to read config files, if necessary.
  ( let ( ( file-contents "" ) )
    ( with-temp-buffer
      ( insert-file-contents filename )
      ( setq file-contents ( buffer-string ) ) )
    file-contents ) )

(defun json-file-to-alist (jsonpath)
  (with-temp-buffer
    (insert-file-contents jsonpath)
    (json-parse-buffer :object-type 'alist)))

(defun hode-load-config (configpath)
  "Load configuration from JSON file into Elisp variables."
  (let ((config (json-file-to-alist configpath)))
    (setq hode-host-root (alist-get 'hode-host-root config))
    ;; TO EXTEND:
    ;; The next three lines show how to traverse nesting,
    ;; for instance if the config contained this:
    ;;  "preferences": {
    ;;    "theme": "dark",
    ;;    "fontSize": 14
    ;;  }
    ;; (setq hode-preferences (alist-get 'preferences config))
    ;; (setq hode-theme     (alist-get 'theme    hode-preferences))
    ;; (setq hode-font-size (alist-get 'fontSize hode-preferences))
))
