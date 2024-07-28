(setq hode-docker-launch-command
      "docker run --name hode -d            \
         -v typedb-data:/opt/               \
         -v /home/jeff/hode6/hode-data:/mnt \
         -p 1729:1729                       \
         --platform linux/amd64             \
         jeffreybbrown/hode:latest       && \
       docker exec -it hode bash            \n")

(defun eval-in-bash-buffer-after-echoing-command
    (shell-buffer command)
  "Ordinarily, process-send-string sends the string silently
 -- it is not visible in the receiving shell buffer.
This makes it visible.

PITFALL: For reasons I don't understand,
only in the top Bash shell is a command like this needed.
In the Docker container under Bash, commands echo as expected.
And in the Python shell under the Docker container,
they echo with some strange noise, but at least they echo."
  (process-send-string
   shell-buffer
   (concat "echo \"" command "\" && " command "\n")))

(defun hode-buffer ()
  (interactive)
  (setq hode-buffer (shell "hode-buffer"))
  (eval-in-bash-buffer-after-echoing-command
   hode-buffer
   hode-docker-launch-command )
  (sit-for 1.5) ;; todo ? This is hacky. Nicer, but much more work, would be to check repeatedly and quickly for whether the docker container has loaded bash yet, and continue once it has.
  (process-send-string
   hode_buffer "ipython \n") )
