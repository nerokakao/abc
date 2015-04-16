(in-package #:abc)

;;;;turing robot 接口地址：http://www.tuling123.com/openapi/cloud/access_api.jsp


;;;; return/data type: json
(defun ask (userid info)
  (let ((uri (concatenate 'string *turing-api-uri* "&userid=" userid "&info=" info)))
    (multiple-value-bind (a b c d e f g)
	(drakma:http-request uri
			     :method :get
			     :content-type "text/html; charset=utf-8"
			     :external-format-out :utf-8
			     :external-format-in :utf-8)
      (if (= b 200) a "机器人离开了 ..."))))




