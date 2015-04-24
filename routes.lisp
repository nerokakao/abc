(in-package #:abc)

(restas:define-route talk-with-me/get ("/talk-with-me" :method :get)
  (let ((userid (tbnl:get-parameter "userid"))
	(info (tbnl:get-parameter "info"))
	(cb (tbnl:get-parameter "cb")))
    (concatenate 'string cb "(" (ask userid info) ")")))

(restas:define-route jsonp-test/get ("/jsonp" :method :get)
  (let ((callback-fn (tbnl:get-parameter "cb")))
    (concatenate 'string callback-fn "(" "{\"info\": \"from server\"}" ")")))


