(define (fact n)
    (if (= n 1)
        1
        (* n (fact (- n 1)))))

(define (f1 x)
    (if (> x 5)
        10
        0))