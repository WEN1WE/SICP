(define (make-leaf symbol weight) (list 'leaf symbol weight))

(define (leaf? object) (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right) 
	(list left
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))
    )
)

(define (left-branch tree) (car tree)) 
(define (right-branch tree) (cadr tree)) 
(define (symbols tree)
	(if (leaf? tree)
		(list (symbol-leaf tree)) 
		(caddr tree)))


(define (weight tree) 
	(if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
	(define (decode-1 bits current-branch)
		(if (null? bits) 
			'()
			(let ((next-branch (choose-branch (car bits) current-branch)))
			  (if (leaf? next-branch)
				(cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch))
            )
		)
	)
	(decode-1 bits tree)
)


(define (choose-branch bit branch)
	(cond ((= bit 0) (left-branch branch))
		((= bit 1) (right-branch branch))
		(else (error "bad bit: CHOOSE-BRANCH" bit))))


(define (adjoin-set x set) 
	(cond ((null? set) (list x))
		((< (weight x) (weight (car set))) (cons x set))
		(else (cons (car set)
				(adjoin-set x (cdr set))))))


(define (make-leaf-set pairs) 
	(if (null? pairs)
		'()
		(let ((pair (car pairs)))
        	(adjoin-set (make-leaf (car pair)
                               	   (cadr pair))

						(make-leaf-set (cdr pairs)))
        )
	)
)



(define (generate-huffman-tree pairs) 
	(successive-merge (make-leaf-set pairs)))


(define (successive-merge set)
	(if (null? (cdr set))
		(car set)
		(let ((first (car set)) (second (cadr set)))
			(let ((new (make-code-tree first second)))
				(successive-merge (adjoin-set new (cddr set)))
			)

		)
	)
)



(define test (list '(A 4) '(B 2) '(C 1) '(D 1)))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(define sample-tree (generate-huffman-tree test))

#|
1 ]=> (decode sample-message sample-tree)

;Value: (a d a b b c a)

length函数可以直接使用

|#



















