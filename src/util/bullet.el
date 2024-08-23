;; PURPOSE:
;; Emacs will draw a bullet ahead of each note.
;; It looks like an ordinary asterisk, but it is read-only,
;; and it contains the note's URI as hidden text.
;; If the note is not in the graph yet (and hence has no URI),
;; the bullet has no URI, and is blue rather than green.

(defun hode-insert-bullet-works (uri)
  (beginning-of-line)
  (let ((bullet (concat "* [" uri "] ")))
    (insert bullet)
    ( add-text-properties (- (point) (length bullet))
      (point)
     '( font-lock-face ( :background "#00ff00"
                         :foreground "#000000")
        read-only t))))
(hode-insert-bullet-works "hello")

(defun hode-insert-bullet (uri)
  (beginning-of-line)
  (let ((bullet ;; four extra characters: "* " and brackets
         (concat "* [" uri "]")))
    (insert bullet)
    (beginning-of-line)
    (let ((bullet-start    (point))
          (hidden-start (+ (point) 2)) ;; 2 extra character
          (bullet-end   (+ (point) 4   ;; 4 extra characters
                           (length uri))))
      ( add-text-properties bullet-start hidden-start
        '( font-lock-face ( :background "#00ff00"
                            :foreground "#000000")
           read-only t))
      ( add-text-properties hidden-start bullet-end
        '( invisible hode-uri
           read-only t))
      (forward-char (length bullet)))))

(defun hode-bullet ()
  (interactive)
  (hode-insert-bullet nil))
