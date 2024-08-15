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
