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
      ( add-text-properties bullet-start hidden-start
        `( font-lock-face
           ( :background ,(if uri "#00ffaa" "#777700")
             :foreground "#000000")
           read-only t))
      ( add-text-properties hidden-start (- bullet-end 1)
        '( invisible hode-uri
           read-only t))
      (forward-char (length bullet)))))

(defun hode-bullet ()
  (interactive)
  (hode-insert-bullet nil))
