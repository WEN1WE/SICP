(1 3 (5 7) 9) = (list 1 3 (list 5 7) 9)
(car (cdr (car (cdr (cdr items)))))


((7)) = (list (list 7))
(car (car items))

(1 (2 (3 (4 (5 (6 7)))))) = (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7))))))
(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr items))))))))))))


(list 1 (list 2 3)) = (1 (2 3))
(cons 1 (list 2 3)) = (1 2 3)


