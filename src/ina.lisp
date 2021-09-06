(in-package :cl-user)
(defpackage ina
  (:use :cl)
  (:export :ina))

(in-package :ina)

(defparameter *url* nil)
(defparameter *output-file* nil)
(defparameter *success* (make-hash-table :test 'equalp))
(defparameter *patterns* (make-hash-table :test 'equalp))

(defparameter *bad-codes* '(400 404))

(defparameter *format-output* "~&[~a] ~a~C~C~a | ~a | ~a~%")

(defmacro with-request (url &body body)
  `(handler-case
       (multiple-value-bind (document status headers quri-uri)
           (handler-bind ((dex:http-request-not-found #'dex:ignore-and-continue)
                          (dex:http-request-failed #'dex:ignore-and-continue))
             (dex:get ,url))
         (declare (ignorable headers quri-uri))
         (multiple-value-bind (length lines words)
             (count-stuff document)
           (progn ,@body)))
     (error (e) nil)))

(defun ina (host wordlist)
  (let ((url (prepare-url host)))
    (run-through url wordlist)))

(declaim (inline link))

(defun link (host word)
  (concatenate 'string host "/" word))

(defun run-through (host wordlist)
  (with-open-file (stream wordlist)
    (loop for line = (read-line stream nil)
          while line do (try (link host line)))))

(defun try (url)
  (with-request url
    (unless (member status *bad-codes*)
      (format t *format-output* status url #\tab #\tab length lines words))))

(defun count-stuff (document)
  (declare (type string document))
  (loop for i across document
        counting (char-equal #\Newline i) into lines
        counting (char-equal #\  i) into spaces
        counting i into length
        finally (return (values length lines (1+ spaces)))))

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
