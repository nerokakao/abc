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


(defun read-template-file (file-name &optional (dir *tepl-directory*))
  (let ((path (merge-pathnames dir file-name)))
    (with-open-file (file path)
      (do ((line (read-line file) (read-line file nil 'eof))
	   (str nil))
	  ((eq line 'eof) str)
	(setf str (format nil "~a~%~a" str line))))))
