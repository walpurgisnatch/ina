(in-package :cl-user)
(defpackage ina
  (:use :cl))

(in-package :ina)

(defparameter *success* (make-hash-table :test 'equalp))
(defparameter *patterns* (make-hash-table :test 'equalp))


(defun run-through (host wordlist)
  (declare (optimize (speed 3) (safety 2))
           (type fixnum buffer-size))
  (let ((buffer (make-array buffer-size :element-type 'character))
        (end buffer-size)
        (temp buffer-size))
    (declare (type fixnum end temp))
    (with-open-file (stream wordlist)
      (loop
        (when (< end buffer-size)
          (return))
        (setf (subseq buffer 0) (subseq buffer temp buffer-size))
        (setf end (read-sequence buffer in :start (- buffer-size temp)))
        (setf temp 0)
        (dotimes (i end)
          (declare (type fixnum i)
                   (dynamic-extent i))
          (when (char-equal #\Newline
                            (aref buffer i))
            (let ((word (subseq buffer temp i)))
              (try host word))
            (setf temp (1+ i))))))))

(defun try (host word)
  ;;TODO
  )

(defun request (url)
  ;;TODO
  )

(defun link (host word)
  ;;TODO
  )

(defun write-to (file table)
  ;;TODO
  )

