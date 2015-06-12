(defpackage #:test
  (:use :cl))

(in-package #:test)




(format t "test~%")


#+test
(format t "hello")
