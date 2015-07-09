(in-package #:abc)

(defun login ()
  (if (not (eql nil tbnl:*session*))
      (return-from login (cl-json:encode-json-alist-to-string
			  '((:code . "2") (:msg . "you has login")))))
					;POST Content-Type: application/x-www-form-urlencoded
					;post-parameter will return nil if Content-Type is other
  (let ((username (tbnl:post-parameter "username"))
	(password (tbnl:post-parameter "password")))
					;check username and password
    (if (<= (verify-user username password) 0)
	(return-from login (cl-json:encode-json-alist-to-string
			    '((:code . "1") (:msg . "username or password error")))))
					;set session
    (tbnl:start-session)
    (setf (tbnl:session-value 'username) username)
    (cl-json:encode-json-alist-to-string `((:code . "0")
					   (:msg . "login ok")
					   (:username . ,username)))))

(defun logout ()
  (if (eql nil tbnl:*session*)
      (return-from logout (cl-json:encode-json-alist-to-string
			   '((:code . "0") (:msg . "logout ok")))))
  (let* ((username (tbnl:session-value 'username))
	 (msg (concatenate 'string username ": you has logout")))
    (tbnl:remove-session tbnl:*session*)
    (cl-json:encode-json-alist-to-string
     `((:code . "0") (:msg . ,msg)))))
