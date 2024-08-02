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
  ( interactive )
  ( setq hode-shell (shell "hode-shell" ) )
  ( eval-in-bash-buffer-after-echoing-command
    hode-shell
    hode-docker-run-command )
  ( sit-for 1.5 ) ;; todo ? This is hacky. Nicer, but much more work, would be to check repeatedly and quickly for whether the docker container has loaded bash yet, and continue once it has.
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

(defun hode-append-line-to-view ()
  ( interactive )
  ( process-send-string hode-shell
    ;; Tricky: Must escape not just the quotation marks,
    ;; but the leading \ in the internal newline --
    ;; the one that reaches hode-view rather than hode-shell.
    "view.append ( \"another line!\\n\" ) \n" ) )
