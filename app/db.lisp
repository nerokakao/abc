(in-package #:abc)

(defparameter *reg-exp-email* "^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$")
(defparameter *reg-exp-phone* "^\\d{11}$")
(defparameter *reg-exp-nickname* "^.{5,32}$")
(defparameter *reg-exp-password* "^.{6,32}$")
(defparameter *reg-exp-birthday* "^[1-9]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}$")
(defparameter *reg-exp-sex* "^[0-2]{1}$")

#+test
(postmodern:with-connection *ds*
  (postmodern:query "select * from users" :plists))

#+test
(postmodern:with-connection *ds*
  (postmodern:execute "insert into users (email, phone, nickname, password, birthday)
values ($1, $2, $3, $4, $5)"
		    "tskshy1@163.com"
		    "15818381818"
		    "nero.b"
		    "abc123"
		    "19881212"		    
		    :none))


(defun add-one-user (email phone nickname password birthday sex)
  (cond ((not (verify-reg-exp-s `((,*reg-exp-email* . ,email)
				  (,*reg-exp-phone* . ,phone)
				  (,*reg-exp-nickname* . ,nickname)
				  (,*reg-exp-password* . ,password)
				  (,*reg-exp-birthday* . ,birthday)
				  (,*reg-exp-sex* . ,sex)))) nil)
	(t (handler-case
	       (postmodern:with-connection *ds*
		 (postmodern:execute
		  " insert into
users (email, phone, nickname, password, birthday, sex, create_dt, status)
values ($1, $2, $3, $4, $5, $6, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
		  email phone nickname password birthday sex))
	     (cl-postgres-error:unique-violation () nil)))))


(defun add-one-news (user-id title keywords content)
  (cond ((not (verify-reg-exp-s `(("^\\d{1,}$" . ,user-id)
				  ("^.{0,32}$" . ,title)
				  ("^.{0,32}$" . ,keywords)
				  ("^.{1,2048}$" . ,content)))) nil)
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
news (user_id, title, keywords, content, create_dt, modify_dt, status)
values ($1, $2, $3, $4,
to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'),
to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       user-id title keywords content))
	     (cl-postgres-error:data-exception () nil)))))


(defun add-one-enjoy (news-id user-id)
  (cond ((eql nil (ppcre:scan "^\\d{1,}$" news-id)) nil)
	((eql nil (ppcre:scan "^\\d{1,}$" user-id)) nil)
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
enjoy (news_id, user_id, status)
values ($1, $2, '0') "
					       news-id user-id))))))


(defun add-one-comment (news-id user-id content)
  (cond ((not (verify-reg-exp-s `(("^\\d{1,}$" . ,news-id)
				  ("^\\d{1,}$" . ,user-id)
				  ("^.{1,512}$" . ,content)))) nil)
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
comments (news_id, user_id, content, create_dt, status)
values ($1, $2, $3, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       news-id user-id content))))))

(defun add-one-reply (comment-id user-id content)
  (cond ((not (verify-reg-exp-s `(("^\\d{1,}$" . ,comment-id)
				  ("^\\d{1,}$" . ,user-id)
				  ("^.{1,512}$" . ,content)))) nil)
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
replys (comment_id, user_id, content, create_dt, status)
values ($1, $2, $3, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       comment-id user-id content))))))
