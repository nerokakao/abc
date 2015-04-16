(in-package #:abc)

(restas:define-route talk-with-me/get ("talk-with-me" :method :get)
  (let ((userid (tbnl:get-parameter "userid"))
	(info (tbnl:get-parameter "info")))
    (ask userid info)))
