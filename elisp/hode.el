( load-file "./readfile.el")

(setq hode-host-root ;; this string must be edited manually
      "/home/jeff/hodal/hode6" )

(setq hode-docker-run-command
      ( concat
        ( file-contents "../config/docker-run.sh" )
        "\n" ) )

(defun eval-in-bash-buffer-after-echoing-command
    ( shell-buffer command )
  "Ordinarily, process-send-string sends the string silently
 -- it is not visible in the receiving shell buffer.
This makes it visible.

PITFALL: For reasons I don't understand,
only in the top Bash shell is a command like this needed.
In the Docker container under Bash, commands echo as expected.
And in the Python shell under the Docker container,
they echo with some strange noise, but at least they echo."
  ( process-send-string
    shell-buffer
    ( concat "echo \"" command "\" && " command "\n" ) ) )

(defun hode-start ()
  "Important: process-send-string and call-process-shell-command are synchronous -- they block later operations while executing."
  ( interactive )
  ( setq hode-shell (shell "hode-shell" ) )
  ( call-process-shell-command hode-docker-run-command )
  ( process-send-string ;; PITFALL: This can't be merged with the next call to process-send-string.
    hode-shell "docker exec -it hode bash\n" )
  ( process-send-string
    hode-shell "cd /mnt                         && \
                source /root/.venv/bin/activate && \
                PYTHONPATH=$PYTHONPATH:. ipython   \n" )
  ( process-send-string
    hode-shell ( concat "import python.view as view \n"
                 "view . initialize ()              \n" ) )
  ( find-file "~/hodal/hode6/hode-data/view.hode" )
  ( rename-buffer "hode-view" )
  ( setq hode-view ( current-buffer ) ) )

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
    "view.append ( \"another line!\\n\" ) \n" ) )
