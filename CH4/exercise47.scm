
;会进入死循环
(define (parse-verb-phrase) 
	(amb (parse-word verbs) 
		(list 'verb-phrase
                (parse-verb-phrase)
                (parse-prepositional-phrase))))


(define (parse-verb-phrase)
	(define (maybe-extend verb-phrase)
	    (amb verb-phrase
	    	(maybe-extend
	          (list 'verb-phrase
					verb-phrase
	                (parse-prepositional-phrase)))))
	(maybe-extend (parse-word verbs)))