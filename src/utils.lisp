(in-package :cl-user)
(defpackage ina.utils
  (:use :cl)
  (:export :prepare-url           
           :wirteline-to))

(defun prepare-url (url)
  (cond
    ((substp "http" url) url)
    ((string-starts-with url "//") url)
    (t (http-join url))))

(defun http-join (url)
  (let ((https-url (concatenate 'string "https://" url))
        (http-url (concatenate 'string "http://" url)))
    (handler-case (progn
                    (dex:get https-url)
                    https-url)
      (error () http-url))))

(defun substp (regex string)
  (if (cl-ppcre:scan-to-strings regex string)
      t
      nil))

(defun string-starts-with (string x)
    (if (string-equal string x :end1 (length x))
        t
        nil))

(defun writeline-to (file line)
  (with-open-file (stream file :direction :output :if-exists :append :if-does-not-exist :create)
    (write-line line stream)))
