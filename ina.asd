(defsystem "ina"
  :version "0.1.0"
  :author "walpurgisnatch"
  :license "MIT"
  :depends-on ("dexador")
  :components ((:module "src"
                :components
                ((:file "ina"))))
  :description ""
  :in-order-to ((test-op (test-op "ina/tests"))))
