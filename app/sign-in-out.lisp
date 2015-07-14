(in-package #:abc)

(defun login ()
  (if (not (eql nil tbnl:*session*))
      (return-from login (simple-alist2json
			  '(("code" . "2")
			    ("msg" . "you has signed in")))))
					;POST Content-Type: application/x-www-form-urlencoded
					;post-parameter will return nil if Content-Type is other
					;h ere, username may be: email/phone/nickname
  (let ((username (tbnl:post-parameter "username"))
	(password (tbnl:post-parameter "password"))
	(user-info nil))
					;check username and password
    (setf user-info (verify-user username password))
    (if (/= (car user-info) 1)
	(return-from login (simple-alist2json
 			    '(("code" . "1")
			      ("msg" . "username or password error")))))
					;set session
    (tbnl:start-session)
    (setf (tbnl:session-value 'userid) (car (cdr user-info)))
    (setf (tbnl:session-value 'username) (car (cdr (cdr user-info))))
    (simple-alist2json `(("code" . "0")
			 ("msg" . "login ok")
			 ("username" . ,(car (cdr (cdr user-info))))))))

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
