(load-file "../../read-files.el")
(load-file "./hide-should-be-invisible-passages.el")
(hode-load-config "../../../data/config.json")

(setq hode-docker-mounted-server-data-copy
      "/mnt/write/server-data")

(defun invis-demo-start ()
  "Important: process-send-string and call-process-shell-command are synchronous -- they block later operations while executing."
  ( interactive )
  ( setq invis-demo-python-shell
    (shell "invis-demo-python-shell" ) )
  ( call-process-shell-command
    ;; PITFALL: The Docker container is called hode,
    ;; when it ought to be called invis-demo,
    ;; because so far that's hard-coded into docker/run.sh.
    ( concat
      ( concat "host_root=" hode-root " && " )
      ( text-file-as-string
        ( file-name-concat hode-root "docker/run.sh" ) ) ) )
  ( process-send-string ;; PITFALL: This can't be merged with the next call to process-send-string.
    invis-demo-python-shell
    "docker exec -it hode bash\n" )
  ( process-send-string invis-demo-python-shell
    "cd /mnt                              && \
     source /home/user/.venv/bin/activate && \
     PYTHONPATH=$PYTHONPATH:. ipython        \n" )
  ( process-send-string invis-demo-python-shell
    ( concat "import src.demo.invis.invis as invis \n"
      "invis.write_viewfile ()\n"
      ) )
  ( find-file ( file-name-concat
                hode-root "mutable-data/view.hode" ) )
  ( rename-buffer "invis-demo-view" )
  ( setq invis-demo-view ( current-buffer ) )
  (with-current-buffer invis-demo-view
    (add-hook ;; Upon reloading data, hide appropriate passages.
     'after-revert-hook
     (lambda ()
       (progn
         (hide-all-should-be-invisible-passages)
         (save-buffer ;; TODO : This is necessary because the previous hide-all command make Emacs think the buffer has been edited. All it changes is properties, not the text itself, so that's weird to me. There's probably a better way.
          )))
     100 ;; "depth" ~ execution order
     t ) ) ;; makes it buffer-local
  )

(defun invis-demo-quit ()
  ( interactive )
  ( message "quitting Invis-Demo, please wait")
  ( let ( ( python-shell-process
	    ( get-buffer-process invis-demo-python-shell ) ) )
    ( interrupt-process python-shell-process )
    ( shell-command "docker stop hode" )
    ( kill-buffer invis-demo-view )
    ( makunbound 'invis-demo-view )
    ( kill-process python-shell-process )
    ( shell-command "docker rm hode" )
    ( kill-buffer invis-demo-python-shell )
    ( makunbound 'invis-demo-python-shell ) )
  ( message "Invis-Demo is off." ) )

(defun invis-demo-insert-node ()
  ( interactive )
  ( process-send-string invis-demo-python-shell
    "invis.insert_node ()\n" ) )

(defun invis-demo-increment-node-at-cursor ()
  (interactive)
  (if
    (search-backward hide-start-symbol nil t)
    (let* ( ( uid_start (search-forward hide-start-symbol nil t))
            ( uid_end
              (progn (search-forward hide-stop-symbol nil t)
                     (search-backward hide-stop-symbol nil t)))
            ( uid ( buffer-substring-no-properties
                    uid_start uid_end ) ) )
      ( process-send-string invis-demo-python-shell
        (format "invis.increment_node (\"%s\")\n" uid ) ) )
    (message "No UID found behind cursor.")))
