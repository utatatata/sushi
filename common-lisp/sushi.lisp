(defconstant *default-conveyor*
  #1a("+--------------------------------------+"
      "|sushi                                 |"
      "| +----------------------------------+ |"
      "| |                                  | |"
      "| |                                  | |"
      "| |                                  | |"
      "| |                                  | |"
      "| |                                  | |"
      "| +----------------------------------+ |"
      "|                                      |"
      "+--------------------------------------+"))
(defconstant *default-sushi-pos* '((1 1) (1 2) (1 3) (1 4) (1 5)))

(defun topp (i j)
  (and (equal i 1)
       (and (< 0 j)
            (< j 38))))

(defun rightp (i j)
  (and (equal j 38)
       (and (< 0 i)
            (< i 9))))

(defun bottomp (i j)
  (and (equal i 9)
       (and (< 1 j)
            (< j 39))))

(defun leftp(i j)
  (and (equal j 1)
       (and (< 1 i)
            (< i 10))))

(defun next (i j)
  (if (and(< i 11)
          (< j 40))
      (cond ((topp    i j) (values    i    (+ j 1)))
            ((rightp  i j) (values (+ i 1)    j))
            ((bottomp i j) (values    i    (- j 1)))
            ((leftp   i j) (values (- i 1)    j)))
      (values -1 -1)))

(defun on ()
  (let ((i (random 11))
        (j (random 40)))
    (if (or (topp    i j)
            (rightp  i j)
            (bottomp i j)
            (leftp   i j))
        (values i j)
        (on))))

(defun next-sushi-pos (sushi-pos)
  (mapcar (lambda (pos)
            (multiple-value-bind
                  (i j)
                (next (car pos) (car (cdr pos)))
              (list i j)))
          sushi-pos))

(defun next-conveyor (sushi-pos next-sushi-pos)
  (let ((next-conv (copy-seq *default-conveyor*)))
    (mapcar (lambda (pos next-pos chr)
              (setf (char (aref next-conv (car pos)) (car (cdr pos))) #\ )
              (setf (char (aref next-conv (car next-pos)) (car (cdr next-pos))) chr)
              )
            (reverse sushi-pos)
            (reverse next-sushi-pos)
            (reverse '(#\s #\u #\s #\h #\i)))
    next-conv))

(defun conveyor-belt-sushi (&optional (sushi-pos *default-sushi-pos*))
  (or (equal (read-line) "quit")
      (let ((next-sushi-pos (next-sushi-pos sushi-pos)))
        (princ (next-conveyor sushi-pos next-sushi-pos))
        (fresh-line)
        (conveyor-belt-sushi next-sushi-pos))))

;; (conveyor-belt-sushi)

