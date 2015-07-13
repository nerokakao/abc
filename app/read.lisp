(in-package #:abc)

;;;;SQL select

;;; return a list: 1 - effect number 2 - userid 3 - nickname
(defun verify-user (username password)
  (postmodern:with-connection *ds*
    (multiple-value-bind (ids effect-num)
    (postmodern:query
     "select id, nickname from users where (nickname = $1 or email = $1 or phone = $1) and password = $2 and status = '0'" username password :rows)
      (list effect-num (car (car ids)) (car (cdr (car ids)))))))

(defun news-info (news-id &optional (count 10))
  (let ((sql0 "select
a.id,
(select nickname from users where id = a.user_id),
a.title,
a.keywords,
a.content,
a.modify_dt,
(select count(id) from enjoy where a.id = news_id)
from news a where a.status = '0' and a.id")
	(sql1 (if (<= news-id 0) " > " " < "))
	(sql2 "$1 order by a.id desc limit $2"))
    (postmodern:with-connection *ds*
      (multiple-value-bind (info num)
	  (postmodern:query
	   (concatenate 'string sql0 sql1 sql2) news-id count :rows)
	(values
	 '("news-id"
	   "nickname"
	   "title"
	   "keywords"
	   "content"
	   "time"
	   "enjoy") info num)))))
;;;;HTTP get

(defun get-news-with-id (news-id)
  (multiple-value-bind (titles contents num) (news-info news-id)
    (if (<= num 0) 
	(simple-alist2json '(("code" . "1")
			     ("msg" . "no information")))
	(simple-alist2json `(("code" . "0")
			     ("msg" . "ok")
			     ("size" . ,num)
			     ("titles" . ,titles)
			     ("contents" . ,contents))))))
