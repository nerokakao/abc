(in-package #:abc)


(defparameter *root-directory* "/Users/nero/daumkakao/playframework/abc/" "path is string")


;;;;who need? -> turing.lisp
(defparameter *turing-api-uri* "http://www.tuling123.com/openapi/api")
(defparameter *turing-key* "0eb9fc282e6dd9031bff8f62a991aeb3")


;;;; database configure
(defparameter *ds* '("test" "postgres" "asdf1234" "fwq" :port 5432 :pooled-p t))
