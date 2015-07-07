(in-package #:abc)

;;; input: string/string
;;; return t/nil
(defun verify-reg-exp (reg-exp-str param)
  (if (or (eql nil (typep reg-exp-str 'string))
	  (eql nil (typep param 'string)))
      nil
      (if (eql nil (handler-case (ppcre:scan reg-exp-str param)
		     (type-error () nil)
		     (ppcre:ppcre-syntax-error () nil))) nil t)))

;;; input/require: '(("reg-exp" . "str") ... ...)
(defun verify-reg-exp-s (lists)
  (dolist (lst lists)
    (if (not (verify-reg-exp
	      (car lst) (cdr lst)))
	(return-from verify-reg-exp-s nil)))
  t)

(defun read-file (path)
  (with-open-file (stream path)
    (do ((line (read-line stream) (read-line stream nil 'eof))
	 (str nil))
	((eq line 'eof) str)
      (setf str (concatenate 'string str line)))))
