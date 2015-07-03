(in-package #:abc)

;;; define/static resource start

(restas:mount-module -front-end-demo- (#:restas.directory-publisher)
  (:url "/assets/")
  (restas.directory-publisher:*directory* (merge-pathnames "assets/" *root-directory*))
  (restas.directory-publisher:*autoindex* nil));browser index dircetory

;;; define/static resource end

;;; main/home page
;(restas:define-route main/home/get ("/" :method :get)
;  (restas:redirect "/front-end-demo/fireworks/index.html"))
;
;(restas:define-route talk-with-me/get ("/talk-with-me" :method :get)
;  (let ((userid (tbnl:get-parameter "userid"))
;	(info (tbnl:get-parameter "info"))
;	(cb (tbnl:get-parameter "cb")))
;    (concatenate 'string cb "(" (ask userid info) ")")))
;
;(restas:define-route jsonp-test/get ("/jsonp" :method :get)
;  (let ((callback-fn (tbnl:get-parameter "cb")))
;    (concatenate 'string callback-fn "(" "{\"info\": \"from server\"}" ")")))


(restas:define-route sessiontest ("/sessiontest" :method :get)
  (tbnl:start-session)
  (format t "~a~%" (tbnl:session-id tbnl:*session*))
  (format t "~a~%" (tbnl:session-value "a"))
  "ok1")

(restas:define-route home ("/" :method :get)
  (restas:redirect "/assets/html/index.html"))


(restas:define-route login ("/login" :method :post)
  )

(restas:define-route logout ("/logout" :method :get)
  )



  
