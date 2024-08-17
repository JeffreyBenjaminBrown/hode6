;; PURPOSE:
;; Utilities for hiding text, based on search matches.
;; The interface, the only interactive function,
;; is `hide-all-should-be-invisible-passages`.
;; See DEMO to see it in action.

(defun exit-right-of-hidden-region-if-in-one ()
  "PITFALL: This assumes there are only two values for 'invisible, the true one ('hode) and the false one (nil)."
  (if (get-text-property (point) 'invisible)
      (goto-char (next-single-property-change
                  (point) 'invisible))))

(defun is-point-in-invisible-region ()
  (message "%s" (get-text-property (point) 'invisible) ))

(setq hide-start-symbol
      (string-trim
       (text-file-as-string
        "../../../data/hide-start-symbol.txt")))
(setq hide-stop-symbol
      (string-trim
       (text-file-as-string
        "../../../data/hide-stop-symbol.txt")))

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
  (let ((saved-char (point)))
    (goto-char 0)
    (hide-all-subsequent-should-be-invisible-passages)
    (goto-char saved-char)))

;; DEMO:
;; Evaluating the following expression
;; will hide some of the text below it.
;; (hide-all-subsequent-should-be-invisible-passages)
;;
;; visible [!hide-stop¡] visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible
;; visible [!hide-start¡] invisible [!hide-stop¡]
;; visible [!hide-start¡] visible
