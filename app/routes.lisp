(in-package #:abc)

;;; define/static resource start

(restas:mount-module -front-end-demo- (#:restas.directory-publisher)
  (:url "/assets/")
  (restas.directory-publisher:*directory* (merge-pathnames "assets/" *root-directory*))
  (restas.directory-publisher:*autoindex* t));browser index dircetory

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


(restas:define-route home/get ("/" :method :get)
  (restas:redirect "/assets/html/index.html"))


(restas:define-route login/post ("/login" :method :post
					;this is response content-type
					  :content-type "application/json")
  (login))


(restas:define-route logout/get ("/logout" :method :get
					   :content-type "application/json")
  (logout))

(restas:define-route next-ten-news/get ("/next-ten-news/:current-max-news-id" :method :get
									      :content-type "application/json")
  (:sift-variables (current-max-news-id 'integer))
  (yason:encode-alist '((:a . "v"))))




  ;(with-output-to-string (stream) (yason:encode-alist '((:a . "b")) stream))
