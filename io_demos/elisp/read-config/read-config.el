(require 'json)

(defun json-file-to-alist (file)
  (with-temp-buffer
    (insert-file-contents file)
    (json-parse-buffer :object-type 'alist)))

(defun load-config ()
  "Load configuration from JSON file into Elisp variables."
  (let ((config (json-file-to-alist "config.json")))
    (setq user-username    (alist-get 'username config))
    (setq user-email       (alist-get 'email config))
    (setq user-age         (alist-get 'age config))

    ;; The next three lines show how to traverse nesting.
    (setq user-preferences (alist-get 'preferences config))
    (setq user-theme       (alist-get 'theme user-preferences))
    (setq user-font-size   (alist-get 'fontSize user-preferences))))

;; Example usage:
(load-config)
(message "Username: %s" user-username)
(message "Font Size: %d" user-font-size)
