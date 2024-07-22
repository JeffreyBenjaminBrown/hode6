(defun eval-in-shell-buffer-after-echoing-command
    (shell-buffer command)
  "Ordinarily, process-send-string sends the string silently -- it is not visible in the receiving shell buffer. This makes it visible."
  (process-send-string
   "hode-buffer"
   (concat "echo \"" command "\" && " command "\n")))

(defun hode-buffer ()
  (interactive)
  (setq hode-buffer (shell "hode-buffer"))
  (eval-in-shell-buffer-after-echoing-command
   hode-buffer
   "docker run --name typedb -d         \
     -v typedb-data:/opt/               \
     -v /home/jeff/hode6/hode-data:/mnt \
     -p 1729:1729                       \
     --platform linux/amd64             \
     vaticle/typedb:latest           && \
   docker exec -it typedb bash          \n" ) )
