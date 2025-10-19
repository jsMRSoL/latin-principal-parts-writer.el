;;; latin-pps-writer.el --- Convert principal parts to lines for bulk flashcard uploads -*- lexical-binding: t -*-

;; working with

;; habeo, habere, habui, habitus: have
;; fero, ferre, tuli, latus: bear
;; agito, agitare, agitavi, agitatus: chase
;; invenio, invenire, inveni, inventus: find


(defvar sp/english-irregular-verbs-table
  (let ((table (make-hash-table :test 'equal)))
    (puthash "awake" '("awake" "awakes" "awoke" "awoken" "awaking") table)
    (puthash "be" '("be" "is" "was" "been" "being") table)
    (puthash "bear" '("bear" "bears" "bore" "borne" "bearing") table)
    (puthash "beat" '("beat" "beats" "beat" "beaten" "beating") table)
    (puthash "become" '("become" "becomes" "became" "become" "becoming") table)
    (puthash "begin" '("begin" "begins" "began" "begun" "beginning") table)
    (puthash "bend" '("bend" "bends" "bent" "bent" "bending") table)
    (puthash "bet" '("bet" "bets" "bet" "bet" "betting") table)
    (puthash "bid" '("bid" "bids" "bid" "bid" "bidding") table)
    (puthash "bite" '("bite" "bites" "bit" "bitten" "biting") table)
    (puthash "bleed" '("bleed" "bleeds" "bled" "bled" "bleeding") table)
    (puthash "blow" '("blow" "blows" "blew" "blown" "blowing") table)
    (puthash "break" '("break" "breaks" "broke" "broken" "breaking") table)
    (puthash "breed" '("breed" "breeds" "bred" "bred" "breeding") table)
    (puthash "bring" '("bring" "brings" "brought" "brought" "bringing") table)
    (puthash "broadcast" '("broadcast" "broadcasts" "broadcast" "broadcast" "broadcasting") table)
    (puthash "build" '("build" "builds" "built" "built" "building") table)
    (puthash "burn" '("burn" "burns" "burnt/burned" "burnt/burned" "burning") table)
    (puthash "burst" '("burst" "bursts" "burst" "burst" "bursting") table)
    (puthash "buy" '("buy" "buys" "bought" "bought" "buying") table)
    (puthash "catch" '("catch" "catches" "caught" "caught" "catching") table)
    (puthash "choose" '("choose" "chooses" "chose" "chosen" "choosing") table)
    (puthash "come" '("come" "comes" "came" "come" "coming") table)
    (puthash "cost" '("cost" "costs" "cost" "cost" "costing") table)
    (puthash "cut" '("cut" "cuts" "cut" "cut" "cutting") table)
    (puthash "deal" '("deal" "deals" "dealt" "dealt" "dealing") table)
    (puthash "dig" '("dig" "digs" "dug" "dug" "digging") table)
    (puthash "do" '("do" "does" "did" "done" "doing") table)
    (puthash "draw" '("draw" "draws" "drew" "drawn" "drawing") table)
    (puthash "dream" '("dream" "dreams" "dreamt/dreamed" "dreamt/dreamed" "dreaming") table)
    (puthash "drink" '("drink" "drinks" "drank" "drunk" "drinking") table)
    (puthash "drive" '("drive" "drives" "drove" "driven" "driving") table)
    (puthash "eat" '("eat" "eats" "ate" "eaten" "eating") table)
    (puthash "fall" '("fall" "falls" "fell" "fallen" "falling") table)
    (puthash "feed" '("feed" "feeds" "fed" "fed" "feeding") table)
    (puthash "feel" '("feel" "feels" "felt" "felt" "feeling") table)
    (puthash "fight" '("fight" "fights" "fought" "fought" "fighting") table)
    (puthash "find" '("find" "finds" "found" "found" "finding") table)
    (puthash "fly" '("fly" "flies" "flew" "flown" "flying") table)
    (puthash "forget" '("forget" "forgets" "forgot" "forgotten" "forgetting") table)
    (puthash "forgive" '("forgive" "forgives" "forgave" "forgiven" "forgiving") table)
    (puthash "freeze" '("freeze" "freezes" "froze" "frozen" "freezing") table)
    (puthash "get" '("get" "gets" "got" "got" "getting") table)
    (puthash "give" '("give" "gives" "gave" "given" "giving") table)
    (puthash "go" '("go" "goes" "went" "gone" "going") table)
    (puthash "grind" '("grind" "grinds" "ground" "ground" "grinding") table)
    (puthash "grow" '("grow" "grows" "grew" "grown" "growing") table)
    (puthash "hang" '("hang" "hangs" "hung" "hung" "hanging") table)
    (puthash "have" '("have" "has" "had" "had" "having") table)
    (puthash "hear" '("hear" "hears" "heard" "heard" "hearing") table)
    (puthash "hide" '("hide" "hides" "hid" "hidden" "hiding") table)
    (puthash "hit" '("hit" "hits" "hit" "hit" "hitting") table)
    (puthash "hold" '("hold" "holds" "held" "held" "holding") table)
    (puthash "hurt" '("hurt" "hurts" "hurt" "hurt" "hurting") table)
    (puthash "keep" '("keep" "keeps" "kept" "kept" "keeping") table)
    (puthash "know" '("know" "knows" "knew" "known" "knowing") table)
    (puthash "lay" '("lay" "lays" "laid" "laid" "laying") table)
    (puthash "lead" '("lead" "leads" "led" "led" "leading") table)
    (puthash "leave" '("leave" "leaves" "left" "left" "leaving") table)
    (puthash "lend" '("lend" "lends" "lent" "lent" "lending") table)
    (puthash "let" '("let" "lets" "let" "let" "letting") table)
    (puthash "lie" '("lie" "lies" "lay" "lain" "lying") table)
    (puthash "lose" '("lose" "loses" "lost" "lost" "losing") table)
    (puthash "make" '("make" "makes" "made" "made" "making") table)
    (puthash "mean" '("mean" "means" "meant" "meant" "meaning") table)
    (puthash "meet" '("meet" "meets" "met" "met" "meeting") table)
    (puthash "pay" '("pay" "pays" "paid" "paid" "paying") table)
    (puthash "put" '("put" "puts" "put" "put" "putting") table)
    (puthash "quit" '("quit" "quits" "quit" "quit" "quitting") table)
    (puthash "read" '("read" "reads" "read" "read" "reading") table)
    (puthash "ride" '("ride" "rides" "rode" "ridden" "riding") table)
    (puthash "ring" '("ring" "rings" "rang" "rung" "ringing") table)
    (puthash "rise" '("rise" "rises" "rose" "risen" "rising") table)
    (puthash "run" '("run" "runs" "ran" "run" "running") table)
    (puthash "say" '("say" "says" "said" "said" "saying") table)
    (puthash "see" '("see" "sees" "saw" "seen" "seeing") table)
    (puthash "sell" '("sell" "sells" "sold" "sold" "selling") table)
    (puthash "send" '("send" "sends" "sent" "sent" "sending") table)
    (puthash "set" '("set" "sets" "set" "set" "setting") table)
    (puthash "shake" '("shake" "shook" "shaken" "shaking") table)
    (puthash "shed" '("shed" "shed" "shed" "shedding") table)
    (puthash "shine" '("shine" "shone" "shone" "shining") table)
    (puthash "shoot" '("shoot" "shot" "shot" "shooting") table)
    (puthash "show" '("show" "showed" "shown" "showing") table)
    (puthash "shut" '("shut" "shut" "shut" "shutting") table)
    (puthash "sing" '("sing" "sang" "sung" "singing") table)
    (puthash "sink" '("sink" "sank" "sunk" "sinking") table)
    (puthash "sit" '("sit" "sat" "sat" "sitting") table)
    (puthash "sleep" '("sleep" "slept" "slept" "sleeping") table)
    (puthash "speak" '("speak" "spoke" "spoken" "speaking") table)
    (puthash "spend" '("spend" "spent" "spent" "spending") table)
    (puthash "spill" '("spill" "spilled/spilt" "spilled/spilt" "spilling") table)
    (puthash "stand" '("stand" "stood" "stood" "standing") table)
    (puthash "steal" '("steal" "stole" "stolen" "stealing") table)
    (puthash "stick" '("stick" "stuck" "stuck" "sticking") table)
    (puthash "sting" '("sting" "stung" "stung" "stinging") table)
    (puthash "stink" '("stink" "stank" "stunk" "stinking") table)
    (puthash "stride" '("stride" "strode" "stridden" "striding") table)
    (puthash "strike" '("strike" "struck" "struck" "striking") table)
    (puthash "swear" '("swear" "swore" "sworn" "swearing") table)
    (puthash "sweep" '("sweep" "swept" "swept" "sweeping") table)
    (puthash "swim" '("swim" "swam" "swum" "swimming") table)
    (puthash "swing" '("swing" "swung" "swung" "swinging") table)
    (puthash "take" '("take" "took" "taken" "taking") table)
    (puthash "teach" '("teach" "taught" "taught" "teaching") table)
    (puthash "tear" '("tear" "tore" "torn" "tearing") table)
    (puthash "tell" '("tell" "told" "told" "telling") table)
    (puthash "think"   '("think" "thinks" "thought" "thought" "thinking") table)
    (puthash "throw"   '("throw" "throws" "threw" "thrown" "throwing") table)
    (puthash "understand" '("understand" "understands" "understood" "understood" "understanding") table)
    (puthash "wake"    '("wake" "wakes" "woke" "woken" "waking") table)
    (puthash "wear"    '("wear" "wears" "wore" "worn" "wearing") table)
    (puthash "win"     '("win" "wins" "won" "won" "winning") table)
    (puthash "write"   '("write" "writes" "wrote" "written" "writing") table)
    table)
  "Create table of irregular English verb parts.
   The sequence is: base, 3rd pers sing, simple past, past participle, pres participle")

(defun sp/latin-pps--check-eng-and-write (latin-pps eng-basic)
  "Check if the meaning is in the English irregular verbs table.
   Write out the meanings of the Latin principal parts accordingly."
  (let ((eng-pps (gethash eng-basic sp/english-irregular-verbs-table :NF)))
    (if (equal eng-pps :NF)
	(sp/latin-pps--write-regular latin-pps eng-basic)
      (sp/latin-pps--write-irregular latin-pps eng-pps))))

(defun sp/latin-pps--write-regular (latin-pps eng-base)
  "Write out the meanings of Latin principal parts on the assumption
   that the English verb is regular."
  (let* ((eng-base-bare (string-trim-right eng-base "e"))
	 (flashcard-lines (list
     (format "%s : I %s\n" (nth 0 latin-pps) eng-base)
     (when (>= (length latin-pps) 2)
       (format "%s : to %s\n" (nth 1 latin-pps) eng-base))
     (when (>= (length latin-pps) 3)
       (format "%s : I %sed\n" (nth 2 latin-pps) eng-base-bare))
     (when (= (length latin-pps) 4)
       (format "%s : having been %sed\n" (nth 3 latin-pps) eng-base-bare)))))
    (mapconcat 'identity flashcard-lines)))

(defun sp/latin-pps--write-irregular (latin-pps eng-pps)
  "Write out the meanings of Latin principal parts on the assumption
   that the English verb is irregular."
  (let ((flashcard-lines 
	 (list
	  (format "%s : I %s\n" (nth 0 latin-pps) (nth 0 eng-pps))
	  (when (>= (length latin-pps) 2)
	    (format "%s : to %s\n" (nth 1 latin-pps) (nth 0 eng-pps)))
	  (when (>= (length latin-pps) 3)
	    (format "%s : I %s\n" (nth 2 latin-pps) (nth 2 eng-pps)))
	  (when (= (length latin-pps) 4)
	    (format "%s : having been %s\n" (nth 3 latin-pps) (nth 3 eng-pps))))))
    (mapconcat 'identity flashcard-lines)))

(defvar sp/latin-pps--latin-eng-split-token nil
  "The user will be asked for the split char on the first run
   of sp/latin-pps-and-translation.")

(defun sp/latin-pps--get-parts (line)
  "Split a buffer line into a list of lists:
   E.g. '((\"habeo\" \"habere\" \"habui\" \"habitus\") \"have\")"
  (let* ((split-var (if sp/latin-pps--latin-eng-split-token
			sp/latin-pps--latin-eng-split-token
		      (setq sp/latin-pps--latin-eng-split-token (read-string "Split Latin and meaning on: " ":"))))
	 (verb-and-meaning
	  (let ((parts (string-split line split-var t "\\s-+")))
	    (unless (= (length parts) 2)
	      (insert (concat line "\n"))
	      (error "Line missing separator '%s': '%s'" split-var line))
	    parts))
	 (verb-string (nth 0 verb-and-meaning))
	 (pps (string-split verb-string "," t "\\s-+"))
	 (meaning (nth 1 verb-and-meaning)))
    (list pps meaning)))

(defun sp/latin-pps--process-line (line)
  "Convert a string in the format [comma-separated principal parts][separator][basic meaning]
   into a string or strings in the format [specific part] : [specific meaning]."
  (let*
      ((latin-pps-and-meaning (sp/latin-pps--get-parts line))
       (latin-pps (nth 0 latin-pps-and-meaning))
       (meaning (nth 1 latin-pps-and-meaning))
       (answer-string 
	(sp/latin-pps--check-eng-and-write latin-pps meaning)))
    (insert answer-string)))


;;;###autoload
(defun sp/latin-pps-write-region-or-line ()
  "For lines which give comma-separated Latin verb principal parts followed by
   another separator and English meaning, e.g.

   habeo, habere, habui, habitus: have

   replace the current line, or lines in the current active region, with lines
   of the format [specific principal part] : [specific English meaning], e.g.

   habeo : I have
   habere : to have
   habui : I had
   habitus : having been had

   Lines may have 1-4 principal parts.
   Any standard separator between Latin and English which is not a comma or a space
   should work, but it is assumed that the same separator is used in each line. The
   user is asked to specify the separator on first run.

   LIMITATIONS:
   Only one English meaning may be specified."
  (interactive)
  (let*
      ((lines
	(if (not (region-active-p))
	    (list (string-trim-right (thing-at-point 'line t) "\n"))
	  (string-split (buffer-substring-no-properties
			 (region-beginning) (region-end)) "\n" t " "))))
    (if (region-active-p)
	(delete-region (region-beginning) (region-end))
      (delete-region (line-beginning-position) (line-beginning-position 2)))
    (mapc #'sp/latin-pps--process-line lines)))


(provide 'latin-pps-writer)
;;; latin-pps-writer.el ends here
