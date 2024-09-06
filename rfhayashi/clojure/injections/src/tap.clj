(ns tap
 (:refer-clojure :exclude [>]))

(defn m [message v]
  (tap> {:message message
         :tap v})
  v)

(defn >-reader [form]
  `(let [t# ~form]
     (tap> t#)
     t#))

(defmacro > [form]
  (>-reader form))

(defn d-reader [form]
  `(let [t# ~form]
     (tap> {:code (pr-str (quote ~form))
            :tap t#})
     t#))

(defmacro d [form]
  (d-reader form))


