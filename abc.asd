;;;; abc.asd

(asdf:defsystem #:abc
  :description "Describe abc here"
  :author "nero.tan"
  :license nil
  :depends-on (#:restas
               #:postmodern
               #:closure-template)
  :serial t
  :components ((:file "package")
               (:file "abc")))

