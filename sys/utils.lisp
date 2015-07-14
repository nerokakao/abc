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

(defun cl2json (fn cl)
  (with-output-to-string (stream)
    (funcall fn cl stream)))

;;; alist require: '(("a" . "b") ("c" . "d") ... )
(defun simple-alist2json (alist)
  (let ((result (make-hash-table :test #'equal :size (length alist))))
    (dolist (alst alist)
      (setf (gethash (car alst) result) (cdr alst)))
    (cl2json #'yason:encode result)))

;(defun set-k-v-with-hashtable (hashtabel k v)
; (setf (gethash k hashtabel) v))

#+test
(let ((m (make-hash-table :test #'equal))
      (a (make-array 5 :initial-element "a")))
  (set-k-v-with-hashtable m "code" "0")
  (setf (gethash "titles" m) '("a" "b"))
  (setf (gethash "contents" m) '(("c" "d") ("e" "f")))
  (setf (gethash "arr" m) a)
  (cl2json #'yason:encode m))

