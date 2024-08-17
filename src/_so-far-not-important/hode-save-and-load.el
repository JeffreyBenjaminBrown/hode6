;; PITFALL: So far this is unnecessary because the Docker image,
;; to my consternation, already saves data!
;; That persists from one `docker run` to the next!
;; Without the user needing to mount a folder for it!

(load-file "../main.el") ;; For the variables and function used that start with `hode`.

(setq hode-docker-mounted-server-data-copy
      "/mnt/write/server-data")
(setq hode-docker-internal-server-data
      "/opt/typedb-all-linux-x86_64/server/data")

(defun hode-save-db-to-host ()
  (interactive)
  ( call-process-shell-command
    ( mapconcat 'identity ;; insert spaces between everything in the list
      `( "docker exec hode cp -r" ;; quote the list to avoid treating its head as a function, then unquote the variables in the list
         ,hode-docker-internal-server-data
         ,hode-docker-mounted-server-data-copy)
      " " ) ) )

(defun hode-start-from-saved-data ()
  "Before starting the TypeDB console, copy the image of the TypeDB DB from the host system."
  ( interactive )
  ( hode-start
    ( mapconcat 'identity ;; insert spaces between everything in the list
      `( "cp -r" ;; quote the list to avoid treating head as function, then unquote the variables in the list
         ,hode-docker-mounted-server-data-copy
         ,hode-docker-internal-server-data)
      " " ) ) )
