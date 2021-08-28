(in-package :cl-user)
(defpackage ina
  (:use :cl)
  (:export :ina))

(in-package :ina)

(defparameter *url* nil)
(defparameter *success* (make-hash-table :test 'equalp))
(defparameter *patterns* (make-hash-table :test 'equalp))

(defun ina (host wordlist)
  (let ((url (prepare-url host)))
    ))

(defun run-through (wordlist)
  (with-open-file (stream wordlist)
    (loop for line = (read-line stream nil)
          while line do ())))


(defun try (host word)
  ;;TODO
  )

(defun link (host word)
  (concatenate 'string host "/" word))

(defun write-to (file table)
  ;;TODO
  )

(defmacro request (url)
  `(handler-case
       (multiple-value-bind (body status headers quri-uri)
           (dex:get url)
         (declare (ignorable status headers quri-uri))
         (let ((content-length (length body)))
           (progn ,@body)))
     (error (e) (print e))))

(defun count-words (arg)
  ;;TODO
  )

(defun count-lines (arg)
  ;;TODO
  )

(defun prepare-url (url)
  (cond
    ((substp "http" url) url)
    ((string-starts-with url "//") url)
    (t (http-join url))))

(defun http-join (url &key (https nil))
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
