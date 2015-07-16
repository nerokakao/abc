(in-package #:abc)
;;;;SQL delete

;;;;HTTP delete
(defun logout ()
  (if (eql nil tbnl:*session*)
      (return-from logout (simple-alist2json
			   '(("code" . "0")
			     ("msg" . "logout ok")))))
  (let* ((username (tbnl:session-value 'username))
	 (msg (concatenate 'string username ": you has logout")))
    (tbnl:remove-session tbnl:*session*)
    (simple-alist2json
     `(("code" . "0")
       ("msg" . ,msg)))))
