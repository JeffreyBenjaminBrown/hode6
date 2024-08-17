;; PURPOSE:
;; Defines the functions one can use to change the document,
;; from Emacs.
;;
;; (defun invis-demo-insert-node ...
;; (defun invis-demo-increment-node-at-cursor ...

;; PITFALL for users:
;; Each interface command begins with
;; 'exit-right-of-hidden-region-if-in-one'.
;; That is, it might invisibly move the cursor.
;; Doing that enables it to find the preceding UID
;; associated with the line the cursor is on, if it exists.

;; PITFALL for coders:
;; Perhaps surprisingly, none of this code hides text.
;; Instead, 'hide-all-should-be-invisible-passages'
;; is part of the 'after-revert-hook'
;; program associated with the view buffer.

(defun invis-demo-insert-node ()
  (interactive)
  (exit-right-of-hidden-region-if-in-one)
  (let ((saved-char (point)))
    ( process-send-string invis-demo-python-shell
      "invis.insert_node ()\n" )
    (goto-char saved-char) ) )

(defun invis-demo-increment-node-at-cursor ()
  (interactive)
  (exit-right-of-hidden-region-if-in-one)
  (if
    (search-backward hide-start-symbol nil t)
    (let* ( ( uid_start (search-forward hide-start-symbol nil t))
            ( uid_end
              (progn (search-forward hide-stop-symbol nil t)
                     (search-backward hide-stop-symbol nil t)))
            ( uid ( buffer-substring-no-properties
                    uid_start uid_end ) ) )
      ( process-send-string invis-demo-python-shell
        (format "invis.increment_node (\"%s\")\n" uid ) ) )
    (message "No UID found behind cursor.") ) )
