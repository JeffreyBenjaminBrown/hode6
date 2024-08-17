;; PURPOSE:
;; This demonstrates how to hide text,
;; based on matches to some searches.

(setq hide-start-symbol "[!hide-start¡]" )
(setq hide-stop-symbol  "[!hide-stop¡]" )

(defun goto-and-return-start-of-next-match (str)
  (if ;; In search-forward and search-backward,
      ;; nil second argument => search as far as possible,
      ;; and t third argument => return nil if no match found.
      (search-forward  str nil t) ;; end of the match
      (search-backward str nil t) ;; start of the match
    nil ) )

(defun next-should-be-invisible-passage ()
  "Returns the bounds of a passage that starts with `hide-start-symbol and ends with `hide-stop-symbol`."
  (let ( ( start ( goto-and-return-start-of-next-match
                   hide-start-symbol ) )
         ( end   ( search-forward
                   hide-stop-symbol nil t ) ) )
    (if (and start end) (list start end) nil) ) )

(defun hide-next-should-be-invisible-passage ()
  "If it finds such a passage, hides it and returns t. Otherwise returns nil."
  (let ( ( maybe-bounds ( next-should-be-invisible-passage ) ) )
    (if maybe-bounds
        (let ( (start (car maybe-bounds))
               (end (car (cdr maybe-bounds))))
          (put-text-property start end 'invisible 'hode )
          t )
      nil ) ) )

(defun hide-all-subsequent-should-be-invisible-passages ()
  (while (hide-next-should-be-invisible-passage)
    (ignore))) ;; This is a no-op.

(defun hide-all-should-be-invisible-passages ()
  (interactive)
  (let ((saved-point (point)))
    (goto-char 0)
    (hide-all-subsequent-should-be-invisible-passages)
    (goto-char saved-point)))

(;; Evaluating this will hide text following it.
 hide-all-subsequent-should-be-invisible-passages)

;; visible [!hide-stop¡] visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible [!hide-start¡] visible
