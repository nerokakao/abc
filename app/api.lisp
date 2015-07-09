(in-package #:abc)

;;;; only check the result(effect row == 1) exists
;;;; execute will return 2 values but I need the first one only default
(defun verify-user (username password)
  (postmodern:with-connection *ds*
    (postmodern:execute
     "select 1 from users where (nickname = $1 or email = $1) and password = $2" username password)))
