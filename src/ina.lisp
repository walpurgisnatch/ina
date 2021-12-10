(in-package :cl-user)
(defpackage ina
  (:use :cl :ina.utils)
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
      (format t *format-output* status #\tab length lines words #\tab url))))

(defun count-stuff (document)
  (declare (type string document))
  (loop for i across document
        counting (char-equal #\Newline i) into lines
        counting (char-equal #\  i) into spaces
        counting i into length
        finally (return (values length lines (1+ spaces)))))

