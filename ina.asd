(defsystem "ina"
  :version "0.1.0"
  :author "walpurgisnatch"
  :license "MIT"
  :depends-on ("dexador"
               "quri")
  :components ((:module "src"
                :serial t
                :components
                ((:file "ina"))))
  :description "Dirbuster")
