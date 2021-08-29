(defsystem "ina"
  :version "0.3.0"
  :author "walpurgisnatch"
  :license "MIT"
  :depends-on ("dexador"
               "quri"
               "cl-ppcre")
  :components ((:module "src"
                :serial t
                :components
                ((:file "ina"))))
  :description "Dirbuster")
