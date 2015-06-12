(in-package #:abc)

;create table users (
;id serial primary key,
;email varchar(32) unique not null,
;phone varchar(11) unique not null,
;nickname varchar(32) not null,
;password varchar(32) not null,
;birthday varchar(8) default '19700101',
;sex varchar(1) default '0',
;create_dt varchar(14) not null,
;status varchar(1) not null
;);

;create table news (
;id serial primary key,
;user_id integer not null,
;title varchar(32) not null,
;keywords varchar(32),
;content varchar(2048) not null,
;create_dt varchar(14) not null,
;modify_dt varchar(14) not null,
;status varchar(1) not null
;);
;create table enjoy (
;id serial primary key,
;news_id integer not null,
;user_id integer not null,
;status varchar(1) not null
;);

;create table comments (
;id serial primary key,
;news_id integer not null,
;user_id integer not null,
;content varchar(512) not null,
;create_dt varchar(14) not null,
;status varchar(1) not null
;);

;create table replys (
;id serial primary key,
;comment_id integer not null,
;user_id integer not null,
;content varchar(512) not null,
;create_dt varchar(14) not null,
;status varchar(1) not null
;);


(defparameter *reg-exp-email* "^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$")
(defparameter *reg-exp-phone* "^\\d{11}$")
(defparameter *reg-exp-nickname* "^.{5,20}$")
(defparameter *reg-exp-password* "^.{6,20}$")
(defparameter *reg-exp-birthday* "^[1-9]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}$")
(defparameter *reg-exp-sex* "^[0-2]{1}$")
(defparameter *reg-exp-create-dt* "^[1-9]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}$")
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
  (cond ((eql nil (ppcre:scan *reg-exp-email* email)) (values 0 0))
	((eql nil (ppcre:scan *reg-exp-phone* phone)) (values 0 0))
	((eql nil (ppcre:scan *reg-exp-nickname* nickname)) (values 0 0))
	((eql nil (ppcre:scan *reg-exp-password* password)) (values 0 0))
	((eql nil (ppcre:scan *reg-exp-birthday* birthday)) (values 0 0))
	((eql nil (ppcre:scan *reg-exp-sex* sex)) (values 0 0))
	(t (handler-case
	       (postmodern:with-connection *ds*
		 (postmodern:execute
		  " insert into
users (email, phone, nickname, password, birthday, sex, create_dt, status)
values ($1, $2, $3, $4, $5, $6, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
		  email phone nickname password birthday sex))
	     (cl-postgres-error:unique-violation () (values 0 0))))))


(defun add-one-news (user-id title keywords content)
  (cond ((eql nil (ppcre:scan "^\\d{1,}$" user-id)) (values 0 0))
	((eql nil (ppcre:scan "^.{0,24}$" title)) (values 0 0))
	((eql nil (ppcre:scan "^.{1,2000}$" content)) (values 0 0))
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
news (user_id, title, keywords, content, create_dt, modify_dt, status)
values ($1, $2, $3, $4,
to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'),
to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       user-id title keywords content))
	   (cl-postgres-error:data-exception () (values 0 0))))))


(defun add-one-enjoy (news-id user-id)
  (cond ((eql nil (ppcre:scan "^\\d{1,}$" news-id)) (values 0 0))
	((eql nil (ppcre:scan "^\\d{1,}$" user-id)) (values 0 0))
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
enjoy (news_id, user_id, status)
values ($1, $2, '0') "
					       news-id user-id))))))


(defun add-one-comment (news-id user-id content)
  (cond ((eql nil (ppcre:scan "^\\d{1,}$" news-id)) (values 0 0))
	((eql nil (ppcre:scan "^\\d{1,}$" user-id)) (values 0 0))
	((eql nil (ppcre:scan "^.{1,500}$" content)) (values 0 0))
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
comments (news_id, user_id, content, create_dt, status)
values ($1, $2, $3, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       news-id user-id content))))))

(defun add-one-reply (comment-id user-id content)
  (cond ((eql nil (ppcre:scan "^\\d{1,}$" comment-id)) (values 0 0))
	((eql nil (ppcre:scan "^\\d{1,}$" user-id)) (values 0 0))
	((eql nil (ppcre:scan "^.{1,500}$" content)) (values 0 0))
	(t (handler-case (postmodern:with-connection *ds*
			   (postmodern:execute " insert into
replys (comment_id, user_id, content, create_dt, status)
values ($1, $2, $3, to_char(now()::timestamp(0)without time zone, 'YYYYMMDDhh24miss'), '0') "
					       comment-id user-id content))))))
