(load-file "../read-files.el")
(hode-load-config "../../config/config.json")

(setq hode-docker-mounted-server-data-copy
      "/mnt/write/server-data")

(defun viewfile-demo-start ()
  "Important: process-send-string and call-process-shell-command are synchronous -- they block later operations while executing."
  ( interactive )
  ( setq viewfile-demo-python-shell
    (shell "viewfile-demo-python-shell" ) )
  ( call-process-shell-command
    ;; PITFALL: The Docker container is called hode,
    ;; when it ought to be called viewfile-demo,
    ;; because so far that's hard-coded into docker/run.sh.
    ( concat
      ( concat "host_root=" hode-root " && " )
      ( text-file-as-string "../../docker/run.sh" ) ) )
  ( process-send-string ;; PITFALL: This can't be merged with the next call to process-send-string.
    viewfile-demo-python-shell
    "docker exec -it hode bash\n" )
  ( process-send-string viewfile-demo-python-shell
    "cd /mnt                              && \
     source /home/user/.venv/bin/activate && \
     PYTHONPATH=$PYTHONPATH:. ipython        \n" )
  ( process-send-string viewfile-demo-python-shell
    ( concat "import src.viewfile_demo.viewfile as viewfile \n"
             "viewfile . initialize ()           \n" ) )
  ( find-file ( file-name-concat
                hode-root "hode-data/view.hode" ) )
  ( rename-buffer "viewfile-demo-view" )
  ( setq viewfile-demo-view ( current-buffer ) ) )

(defun viewfile-demo-quit ()
  ( interactive )
  ( message "quitting Viewfile-Demo, please wait")
  ( let ( ( python-shell-process
	    ( get-buffer-process viewfile-demo-python-shell ) ) )
    ( interrupt-process python-shell-process )
    ( shell-command "docker stop hode" )
    ( kill-buffer viewfile-demo-view )
    ( makunbound 'viewfile-demo-view )
    ( kill-process python-shell-process )
    ( shell-command "docker rm hode" )
    ( kill-buffer viewfile-demo-python-shell )
    ( makunbound 'viewfile-demo-python-shell ) )
  ( message "Viewfile-Demo is off." ) )

(defun viewfile-demo-append-line-to-view ()
  ( interactive )
  ( process-send-string viewfile-demo-python-shell
    ;; Tricky: Must escape not just the quotation marks,
    ;; but the leading \ in the internal newline --
    ;; the one that reaches viewfile-demo-view,
    ;; rather than viewfile-demo-python-shell.
    "viewfile.append ( \"another line!\\n\" ) \n" ) )
