(define (=zero? x) (apply-generic '=zero? x))
(define (sub x y) (apply-generic 'sub x y)) 

(define (apply-generic op . args)
	(let ((type-tags (map type-tag args)))
		(let ((proc (get op type-tags))) 
			(if proc
            	(apply proc (map contents args))
          		(error
          			"No method for these types: APPLY-GENERIC"
            	(list op type-tags))))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
	(and (variable? v1) (variable? v2) (eq? v1 v2)))


(define (add-poly p1 p2)
	(if (same-variable? (variable p1) (variable p2))
      	(make-poly (variable p1)
                 (add-terms (term-list p1) (term-list p2)))
		(error "Polys not in same var: ADD-POLY" (list p1 p2))))


(define (mul-poly p1 p2)
	(if (same-variable? (variable p1) (variable p2)) 
		(make-poly (variable p1)
        		(mul-terms (term-list p1) (term-list p2)))
      			(error "Polys not in same var: MUL-POLY" (list p1 p2))))


(define (install-polynomial-package)
	;; internal procedures
;	; representation of poly
	(define (make-poly variable term-list) (cons variable term-list)) 
	(define (variable p) (car p))
	(define (term-list p) (cdr p))
	(define (variable? x) (symbol? x))

	(define (same-variable? v1 v2)
		(and (variable? v1) (variable? v2) (eq? v1 v2)))
	;; representation of terms and term lists


	(define (adjoin-term term term-list) 
		(if (=zero? (coeff term))
			term-list
			(cons term term-list)))




	(define (add-poly p1 p2) . . .)
	⟨procedures used by add-poly⟩
	(define (mul-poly p1 p2) . . .)
	⟨procedures used by mul-poly⟩

	(define (zero-poly? p)
		(define (zero-terms? terms)
			(or (empty-termlist? terms)
                (and (=zero? (coeff (first-term terms))))
                     (zero-terms (rest-terms terms))
			)
		)
		(zero-terms? (term-list p))
	)

	;; interface to rest of the system
	(define (tag p) (attach-tag 'polynomial p))
	(put 'add '(polynomial polynomial)
		(lambda (p1 p2) (tag (add-poly p1 p2)))) 
	(put 'mul '(polynomial polynomial)
		(lambda (p1 p2) (tag (mul-poly p1 p2)))) 
	(put 'make 'polynomial
		(lambda (var terms) (tag (make-poly var terms)))) 

	(put '=zero? '(polynomial) zero-poly?)
	(put 'sub? '(polynomial polynomial) 
		(lambda (p1 p2) (tag (sub-terms p1 p2))))


	'done)



(define (add-terms L1 L2)
	(cond ((empty-termlist? L1) L2)
		((empty-termlist? L2) L1) 
		(else
		(let ((t1 (first-term L1)) 
			 (t2 (first-term L2)))
			(cond ((> (order t1) (order t2)) 
				  (adjoin-term
                   t1 (add-terms (rest-terms L1) L2)))
                 ((< (order t1) (order t2))
                 	(adjoin-term
                   t2 (add-terms L1 (rest-terms L2))))
				(else 
					(adjoin-term
                   		(make-term (order t1)
                              (add (coeff t1) (coeff t2)))
                  		 (add-terms (rest-terms L1)
                              (rest-terms L2)))))))))

(define (sub-terms L1 L2)
	(cond ((empty-termlist? L2) L1)
		  (else 
		  	  (let ((t1 (first-term L1))
		  	  		(t2 (first-term L2))
		  	  	   )
		  	       (cond ((> (order t1) (order t2))
		  	       	     	(sub-terms (rest-terms t1) t2))
		  	       	     ((< (order t1) (order t2))
		  	       	        (adjoin-term 
		  	       	        	(make-term (order t2) (mul -1 ((coeff t2))))
		  	       	        	(sub-terms L1 (rest-terms L2))))

		  	       	     (else 
		  	       	     	(adjoin-term
		  	       	     		(make-term (order t1) (sub (coeff t1) (coeff t2)))
		  	       	     		(sub-terms (rest-terms L1) (rest-terms L2))

		  	       	     	)
		  	       	     )

		  	       	)



		  	  )


		  )


	)

)

(define (mul-terms L1 L2) 
	(if (empty-termlist? L1) 
		(the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))


(define (mul-term-by-all-terms t1 L) 
	(if (empty-termlist? L)
		(the-empty-termlist)
		(let ((t2 (first-term L)))
        	(adjoin-term
         		(make-term (+ (order t1) (order t2))
                           (mul (coeff t1) (coeff t2)))
         		(mul-term-by-all-terms t1 (rest-terms L))))))



(define (adjoin-term term term-list) 
	(if (=zero? (coeff term))
		term-list
		(cons term term-list)))


(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list)) 
(define (rest-terms term-list) (cdr term-list)) 
(define (empty-termlist? term-list) (null? term-list)) 
(define (make-term order coeff) (list order coeff))
(define (order term) (car term)) 
(define (coeff term) (cadr term))


(define (make-polynomial var terms) 
	((get 'make 'polynomial) var terms))


















