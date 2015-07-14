(in-package #:abc)

;;;;DATABASE insert
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
;;;;HTTP post 不具幂等，用于资源新增

;;;rest风格设计下，很难在post和put之间选择
;;;后来选择post是因为：每次登陆时，新增session(虽然函数start-session在有session时会取现有session)
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

;;; 参数检验应该在此处进行 但操作DB的函数已经有了检验 先忽略
(defun add-news ()
  (cond ((eql nil tbnl:*session*) (simple-alist2json '(("code" . "1") ("msg" . "not login."))))
	(t (let ((user-id (tbnl:session-value 'userid))
		 (title (tbnl:post-parameter "title"))
		 (keywords (tbnl:post-parameter "keywords"))
		 (content (tbnl:post-parameter "content")))
	     (if (eql nil (add-one-news (write-to-string user-id) title keywords content))
		 (simple-alist2json '(("code" . "2") ("msg" . "may be params invalid or database error.")))
		 (simple-alist2json '(("code" . "0") ("msg" . "add news ok"))))))))
