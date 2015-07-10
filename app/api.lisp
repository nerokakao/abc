(in-package #:abc)

;;;; only check the result(effect row == 1) exists
;;;; execute will return 2 values but I need the first one only default
(defun verify-user (username password)
  (postmodern:with-connection *ds*
    (postmodern:execute
     "select 1 from users where (nickname = $1 or email = $1 or phone = $1) and password = $2" username password)))

(defun news-info (news-id &optional (count 10))
  (let ((sql0 "select
a.id as newsid,
(select nickname from users where id = a.user_id) as nickname,
a.title as title,
a.keywords as keywords,
a.content as content,
a.modify_dt as dt,
(select count(id) from enjoy where a.id = news_id) as enjoys
from news a where a.id")
	(sql1 (if (<= news-id 0) " > " " < "))
	(sql2 "$1 order by a.id desc limit $2"))
    (postmodern:with-connection *ds*
      (postmodern:query
       (concatenate 'string sql0 sql1 sql2) news-id count :alists))))
