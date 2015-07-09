(in-package #:abc)

(defclass enjoy ()
  ((id :col-type integer :initarg :id :accessor id)
   (news-id :col-type integer :initarg :news-id :accessor news-id)
   (user-id :col-type integer :initarg :user-id :accessor user-id)
   (status :col-type string :initarg :status :accessor status))
  (:metaclass postmodern:dao-class)
  (:keys id))
  
