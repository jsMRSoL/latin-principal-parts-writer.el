(require 'ert)
(require 'latin-pps-writer)

(ert-deftest sp/test-latin-pps--write-regular ()
  (should (equal (sp/latin-pps--write-regular '("agito" "agitare" "agitavi" "agitatus") "chase")
		 "agito : I chase
agitare : to chase
agitavi : I chased
agitatus : having been chased
")))

(ert-deftest sp/test-latin-pps--write-irregular ()
  (should (equal (sp/latin-pps--write-irregular
		  '("habeo" "habere" "habui" "habitus")
		  '("have" "has" "had" "had" "having"))
		 "habeo : I have
habere : to have
habui : I had
habitus : having been had
")))

(ert-deftest sp/test-latin-pps--get-parts ()
  (should (equal (sp/latin-pps--get-parts "agito, agitare, agitavi, agitatus: chase")
		 '(("agito" "agitare" "agitavi" "agitatus") "chase"))))


(ert-deftest sp/test-latin-pps--process-line ()
  (with-temp-buffer
    (sp/latin-pps--process-line "habeo, habere, habui, habitus: have")
    (should (equal
	     (buffer-string)
"habeo : I have
habere : to have
habui : I had
habitus : having been had
"))))

(defun run-all-tests ()
  (interactive)
  (ert t))
