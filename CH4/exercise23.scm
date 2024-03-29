
; 返回的是一个执行循环的程序

(define (analyze-sequence exps) 
	(define (execute-sequence procs env)
		(cond ((null? (cdr procs)) 
			  	((car procs) env))
			  (else
			  	((car procs) env)
				(execute-sequence (cdr procs) env))))
	(let ((procs (map analyze exps))) 
		(if (null? procs)
			(error "Empty sequence: ANALYZE")) 
		(lambda (env)
      		(execute-sequence procs env))))



(define (analyze-sequence exps) 
	(define (sequentially proc1 proc2)
		(lambda (env) (proc1 env) (proc2 env))) 
	(define (loop first-proc rest-procs)
		(if (null? rest-procs) 
			first-proc
        	(loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
	(let ((procs (map analyze exps)))
		(if (null? procs) (error "Empty sequence: ANALYZE")) 
		(loop (car procs) (cdr procs))))