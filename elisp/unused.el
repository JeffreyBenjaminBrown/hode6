(load-file "./hode.el") ;; For the variables and function used that start with `hode`.

(defun hode-start-from-saved-data ()
  "Before starting the TypeDB console, copy the image of the TypeDB DB from the host system."
  ( interactive )
  ( hode-start
    ( mapconcat 'identity ;; insert spaces between everything in the list
      `( "cp -r" ;; quote the list to avoid treating head as function, then unquote the variables in the list
         ,hode-docker-mounted-server-data-copy
         ,hode-docker-internal-server-data)
      " " ) ) )
