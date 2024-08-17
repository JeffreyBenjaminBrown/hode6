(defun hode-send-shell (beg end)
  "PURPOSE: Send a highlighted region to Python to evaluate.

PROBLEM: Chokes on whitespace or something.
Instead, just run
  exec ( open ( filename ) . read () )
from the Python shell."
  (interactive "r")
  (process-send-region receiving-ghci-buffer beg end)
  (process-send-string receiving-ghci-buffer "\n") )
