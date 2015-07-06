;;;; abc.asd

(asdf:defsystem #:abc
  :description "Describe abc here"
  :author "nero.tan"
  :license nil
  :depends-on (#:restas
	       #:restas-directory-publisher
               #:postmodern
               #:closure-template
	       #:drakma
	       #:yason)
  :serial t
  :components ((:file "package")
	       (:file "configure")
	       (:file "common-funcs")
               (:file "abc")
	       (:file "bus-api")
	       (:file "routes")
	       (:file "turing")
	       (:file "db")))

