( load-file "./readfile.el")

(defun hode-start ()
  "Important: process-send-string and call-process-shell-command are synchronous -- they block later operations while executing."
  ( interactive )
  ( setq hode-shell (shell "hode-shell" ) )
  ( call-process-shell-command
    ( file-contents "../config/docker-run.sh" ) )
  ( process-send-string ;; PITFALL: This can't be merged with the next call to process-send-string.
    hode-shell "docker exec -it hode bash\n" )
  ( process-send-string
    hode-shell "cd /mnt                         && \
                source /root/.venv/bin/activate && \
                PYTHONPATH=$PYTHONPATH:. ipython   \n" )
  ( process-send-string hode-shell
    ( concat "import python.viewfile as viewfile \n"
             "viewfile . initialize ()           \n" ) )
  ( find-file "~/hodal/hode6/hode-data/view.hode" )
  ( rename-buffer "hode-view" )
  ( setq hode-view ( current-buffer ) ) )

(defun hode-send-shell (beg end)
  (interactive "r")
  (process-send-region receiving-ghci-buffer beg end)
  (process-send-string receiving-ghci-buffer "\n") )

(defun hode-quit ()
  ( interactive )
  ( message "quitting Hode, please wait")
  ( let ( ( hode-shell-process
	    ( get-buffer-process hode-shell ) ) )
    ( interrupt-process hode-shell-process )
    ( shell-command "docker stop hode" )
    ( kill-buffer hode-view )
    ( makunbound 'hode-view )
    ( kill-process hode-shell-process )
    ( shell-command "docker rm hode" )
    ( kill-buffer hode-shell )
    ( makunbound 'hode-shell )
    )
  ( message "Hode is off." ) )

(defun hode-append-line-to-view ()
  ( interactive )
  ( process-send-string hode-shell
    ;; Tricky: Must escape not just the quotation marks,
    ;; but the leading \ in the internal newline --
    ;; the one that reaches hode-view rather than hode-shell.
    "viewfile.append ( \"another line!\\n\" ) \n" ) )
