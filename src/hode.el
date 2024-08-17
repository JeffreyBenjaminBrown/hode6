(load-file "./util/read-files.el")
(hode-load-config "../data/config.json")

(setq hode-docker-mounted-server-data-copy
      "/mnt/write/server-data")
(setq hode-docker-internal-server-data
      "/opt/typedb-all-linux-x86_64/server/data")

(defun hode-start
    ( run-in-docker-before-starting-typedb ;; string for Bash
      )
  "Important: process-send-string and call-process-shell-command are synchronous -- they block later operations while executing.

Note that this is *not* interactive; it is a helper function."
  ( setq hode-python-shell (shell "hode-python-shell" ) )
  ( setq hode-typedb-shell (shell "hode-typedb-shell" ) )
  ( call-process-shell-command
    ( concat
      ( concat "host_root=" hode-root " && " )
      ( text-file-as-string "../docker/run.sh" ) ) )
  ( process-send-string ;; PITFALL: This can't be merged with the next call to process-send-string.
    hode-python-shell "docker exec -it hode bash\n" )
  ( process-send-string
    hode-typedb-shell "docker exec -it hode bash\n" )
  ( process-send-string hode-python-shell
    "cd /mnt                              && \
     source /home/user/.venv/bin/activate && \
     PYTHONPATH=$PYTHONPATH:. ipython        \n" )
  ( process-send-string hode-typedb-shell
    ( concat ;; Remember that && is synchronous.
      (if run-in-docker-before-starting-typedb
          run-in-docker-before-starting-typedb
        ":") ;; ":" (without quotes) is the Bash noop
      " "
      " && /opt/typedb-all-linux-x86_64/typedb server \n" ) )
  ( process-send-string hode-python-shell
    ( concat "import src.viewfile as viewfile \n"
             "viewfile . initialize ()           \n" ) )
  ( find-file ( file-name-concat
                hode-root "mutable-data/view.hode" ) )
  ( rename-buffer "hode-view" )
  ( setq hode-view ( current-buffer ) ) )

(defun hode-start-fresh ()
  ;; PITFALL: Don't merge this and hode-start into one function,
  ;; because it would break some of
  ;;   ./_so-far-not-important/hode-save-and-load.el
  ( interactive )
  ( hode-start nil ) )

(defun hode-quit ()
  ( interactive )
  ( message "quitting Hode, please wait")
  ( let ( ( python-shell-process
	    ( get-buffer-process hode-python-shell ) )
          ( typedb-shell-process
	    ( get-buffer-process hode-typedb-shell ) ) )
    ( interrupt-process python-shell-process )
    ( interrupt-process typedb-shell-process )
    ( shell-command "docker stop hode" )
    ( kill-buffer hode-view )
    ( makunbound 'hode-view )
    ( kill-process python-shell-process )
    ( kill-process typedb-shell-process )
    ( shell-command "docker rm hode" )
    ( kill-buffer hode-python-shell )
    ( makunbound 'hode-python-shell )
    ( kill-buffer hode-typedb-shell )
    ( makunbound 'hode-typedb-shell ) )
  ( message "Hode is off." ) )

(defun hode-append-line-to-view ()
  ( interactive )
  ( process-send-string hode-python-shell
    ;; Tricky: Must escape not just the quotation marks,
    ;; but the leading \ in the internal newline --
    ;; the one that reaches hode-view,
    ;; rather than hode-python-shell.
    "viewfile.append ( \"another line!\\n\" ) \n" ) )
