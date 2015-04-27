;;;; abc.asd

(asdf:defsystem #:abc
  :description "Describe abc here"
  :author "nero.tan"
  :license nil
  :depends-on (#:restas
	       #:restas-directory-publisher
               #:postmodern
               #:closure-template
	       #:drakma)
  :serial t
  :components ((:file "package")
	       (:file "configure")
               (:file "abc")
	       (:file "routes")
	       (:file "turing")))

