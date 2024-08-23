;; PURPOSE:
;; Emacs will draw a bullet ahead of each note.
;; It looks like an ordinary asterisk, but it is read-only,
;; and it contains the note's URI as hidden text.
;; If the note is not in the graph yet (and hence has no URI),
;; the bullet has no URI, and is blue rather than green.

(defun hode-insert-bullet (uri)
  (beginning-of-line)
  (let ((bullet ;; four extra characters: "* " and brackets
         (concat "*[" uri "] ")))
    (insert bullet)
    (beginning-of-line)
    (let ((bullet-start    (point))
          (hidden-start (+ (point) 1)) ;; exclude the asterisk
          (bullet-end   (+ (point) 4   ;; 4 extra characters
                           (length uri))))
      ( put-text-property bullet-start (- bullet-end 1)
        'hode-bullet t )
      ( add-text-properties bullet-start hidden-start
        `( font-lock-face
           ( :background ,(if uri "#00ffaa" "#777700")
             :foreground "#000000")
           read-only 'hode-bullet))
      ( add-text-properties hidden-start (- bullet-end 1)
        '( invisible hode-uri
           read-only 'hode-bullet))
      (forward-char (length bullet)))))

(defun hode-bullet ()
  (interactive)
  (hode-insert-bullet nil))

(defun this-or-previous-uri ()
  "Move point to follow bullet. Return bullet URI."
  (if (not (get-text-property (point) 'hode-bullet))
      (goto-char (previous-single-property-change
                  (point) 'hode-bullet)))
  (beginning-of-line)
  (let ((line-start (point))
        (left-bracket (search-forward "["))
        (right-bracket (search-forward "]")))
    (forward-char 1)
    ( buffer-substring-no-properties
      left-bracket (- right-bracket 1))))
