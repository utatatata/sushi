(ns sushi
  (:require [lanterna.screen :as ls]
            [clojure.string :as s]))

(defn lane-length [width height]
  (+ (* 2 (- width 3))
     (* 2 (- height 3))))

(defn index-to-coord [n width height]
  (let [max-lane-x (- width 3)
        max-lane-y (- height 3)
        max-n (+ max-lane-x max-lane-y)
        n (if (<= n max-n)
            n
            (- n (* max-n 2)))]
    (map inc
      (cond
        (< n (- max-lane-y)) [(- (- n) max-lane-y) max-lane-y]
        (< n 0) [0 (- n)]
        (< n max-lane-x) [n 0]
        :else [max-lane-x (- n max-lane-x)]))))

(defn put-between [x seq y]
  (cons x (concat seq [y])))

(defn build-lane [width height]
  (let [outside-edge (concat [\+] (repeat (- width 2) \-) [\+])
        lane (concat [\|] (repeat (- width 2) \space) [\|])
        inside-edge (concat [\| \space \+] (repeat (- width 6) \-) [\+ \space \|])
        inside (concat [\| \space \|] (repeat (- width 6) \space) [\| \space \|])]
    (concat [outside-edge lane inside-edge]
            (repeat (- height 6) inside)
            [inside-edge lane outside-edge])))

(defn main-loop [scr]
  (loop [n 0]
    (let [[width height] (ls/get-size scr)]
      (ls/clear scr)
      (dorun (map-indexed
        (fn [idx line]
          (ls/put-string scr 0 idx (apply str line)))
        (build-lane width height)))
      (dorun (map-indexed
        (fn [idx chr]
          (let [[x y] (index-to-coord (+ n idx) width height)]
            (ls/put-string scr x y (str chr))))
        (seq "sushi")))
      (ls/redraw scr)
      (Thread/sleep 50)
      (recur (mod (inc n) (lane-length width height))))))

(defn start []
  (let [scr (ls/get-screen :swing)]
    (ls/in-screen scr
      (main-loop scr))))

(defn -main []
  (start))

