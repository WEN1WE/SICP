

#|
(let ((⟨var1⟩ ⟨exp1⟩) . . . (⟨varn⟩ ⟨expn⟩)) ⟨body⟩)


((lambda (⟨var1⟩ ... ⟨varn⟩) ⟨body⟩)
⟨exp1⟩ ... ⟨expn⟩)



(define (fib n)
	(let fib-iter ((a 1)
				  (b 0)
                  (count n)) 
        (if (= count 0)
        	b
        	(fib-iter (+ a b) a (- count 1)))))

(define (fib n)
	(define fib-iter
		(lambda (a b count) 
			(if (= count 0)
        		b
        		(fib-iter (+ a b) a (- count 1)))   
		)
	)

	(fib-iter 1 0 n)
)

|#

(define (eval exp env)
	(cond ((self-evaluating? exp) exp)
	        ((variable? exp) (lookup-variable-value exp env))
	        ((quoted? exp) (text-of-quotation exp))
	        ((assignment? exp) (eval-assignment exp env))
	        ((definition? exp) (eval-definition exp env))
	        ((if? exp) (eval-if exp env))
	        ((lambda? exp) (make-procedure (lambda-parameters exp)
	                                       (lambda-body exp)
	                                       env))

	        ((begin? exp)
         		(eval-sequence (begin-actions exp) env))
        	((cond? exp) (eval (cond->if exp) env))


        	((let? exp)  (eval (let->combination exp) env))


        	((application? exp)
         		(apply (eval (operator exp) env)
                	(list-of-values (operands exp) env)))
			(else
				(error "Unknown expression type: EVAL" exp))))



(define (let? exp) (tagged-list? exp 'let))

(define (let->combination exp)
	(if (symbol? (cadr exp))
		(let ((normal-let (cons (first-exp exp) (cddr exp)))
			  (proc (cadr exp))
			 )
			(list 'begin
				(list 'define proc (make-lambda (let-parameters (let-clauses normal-exp)) (let-body normal-exp)))
				(cons proc (let-exps normal-exp))
			)
		)
		(cons (make-lambda (let-parameters (let-clauses exp)) (let-body exp)) (let-exps exp))
	)
)

(define (let-clauses exp)
	(cadr exp)
)

(define (let-parameters clauses)
	(define (helper lambda-clauses)
		(if (null? lambda-clauses)
			'()
			(let ((clause (car lambda-clauses)))
				(cons (car clause) (helper (cdr lambda-clauses)))
			)

		)

	)
	(helper clauses)
)

(define (let-exps clauses)
	(define (helper lambda-clauses)
		(if (null? lambda-clauses)
			'()
			(let ((clause (car lambda-clauses)))
				(cons (cadr clause) (helper (cdr )))
			)

		)
	)
	(helper clauses)
)


(define (let-body exp)
	(cddr exp)
)


(define (list-of-values exps env) 
	(if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))


(define (make-lambda parameters body) 
	(cons 'lambda (cons parameters body)))




(define (last-exp? seq) (null? (cdr seq))) 
(define (first-exp seq) (car seq)) 
(define (rest-exps seq) (cdr seq))


