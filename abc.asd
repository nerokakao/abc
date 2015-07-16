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
	       #:yason
	       #:cl-json)
  :serial t
  :pathname ""
  :components ((:file "package")
	       
	       (:module "conf"
			:components ((:file "configure")))

	       (:module "sys"
			:depends-on ("conf")
			:components ((:file "abc")
				     (:file "utils")))

	       (:module "app"
			:depends-on ("sys")
			:components ((:file "create")
				     (:file "read")
				     (:file "update")
				     (:file "delete")
				     (:file "routes")))))

