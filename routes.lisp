(in-package #:abc)

;;; define/static resource start

(restas:mount-module -front-end-demo- (#:restas.directory-publisher)
  (:url "/front-end-demo/")
  (restas.directory-publisher:*directory* (merge-pathnames "front-end-demo/" *root-directory*))
  (restas.directory-publisher:*autoindex* t));browser index dircetory

;;; define/static resource end

;;; main/home page
(restas:define-route main/home/get ("/" :method :get)
  (restas:redirect "/front-end-demo/fireworks/index.html"))

(restas:define-route talk-with-me/get ("/talk-with-me" :method :get)
  (let ((userid (tbnl:get-parameter "userid"))
	(info (tbnl:get-parameter "info"))
	(cb (tbnl:get-parameter "cb")))
    (concatenate 'string cb "(" (ask userid info) ")")))

(restas:define-route jsonp-test/get ("/jsonp" :method :get)
  (let ((callback-fn (tbnl:get-parameter "cb")))
    (concatenate 'string callback-fn "(" "{\"info\": \"from server\"}" ")")))



  
