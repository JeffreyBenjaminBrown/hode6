;; PURPOSE:
;; Emacs will draw a bullet ahead of each note.
;; It looks like an ordinary asterisk, but it is read-only,
;; and it contains the note's URI as hidden text.
;; If the note is not in the graph yet (and hence has no URI),
;; the bullet has no URI, and is blue rather than green.

(defun hode-insert-bullet (uri)
  "Insert a read-only bullet with an invisible URI, followed by a single writeable space."
  ;; TODO: Should be idempotent. Two bullets on one line = bad.
  (beginning-of-line)
  (let ((bullet ;; three extra characters: "* " and brackets
         (concat "*[" uri "]")))
    (insert bullet " ")
    (beginning-of-line)
    (let ((bullet-start    (point))
          (hidden-start (+ (point) 1)) ;; exclude the asterisk
          (bullet-end   (+ (point) 3   ;; 3 extra characters
                           (length uri))))
      ( put-text-property bullet-start bullet-end
        'hode-bullet t )
      ( add-text-properties bullet-start hidden-start
        `( font-lock-face
           ( :background ,(if uri "#00ffaa" "#777700")
             :foreground "#000000")
           read-only 'hode-bullet))
      ( add-text-properties hidden-start bullet-end
        '( invisible hode-uri
           read-only 'hode-bullet))
      (forward-char (+ 1 (length bullet))))))

(defun hode-bullet ()
  (interactive)
  (hode-insert-bullet nil))

(defun bullet-uri-and-positions ()
  "Returns (uri line-start left-bracket right-bracket)."
  (save-excursion
    (if (not (get-text-property (point) 'hode-bullet))
        (goto-char (previous-single-property-change
                    (point) 'hode-bullet)))
    (beginning-of-line)
    (let* ((line-start (point))
           (left-bracket (search-forward "["))
           (right-bracket (search-forward "]"))
           (uri ( buffer-substring-no-properties
                  left-bracket (- right-bracket 1))))
      (list uri line-start left-bracket right-bracket))))

(defun next-bullet-pos-or-eof ()
  (save-excursion
    (let ((text-start (nth 3 (bullet-uri-and-positions))))
      (if ;; If in a bullet, exit it to the right.
          (get-text-property (point) 'hode-bullet)
          (goto-char (next-single-property-change
                      (point) 'hode-bullet)))
      (let ((next-change (next-single-property-change
                          (point) 'hode-bullet)))
                 (if next-change next-change 0))
        (if next-change next-change (buffer-size))))))

(defun text-associated-with-bullet ()
  (save-excursion
    (let* ((start (+ (nth 3 (bullet-uri-and-positions)) 1))
           (end   (- (next-bullet-pos-or-eof)           1))
           (text (buffer-substring-no-properties
                  start end)))
      text ) ) )
