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

(defn t-reader [form]
  `(let [start# (System/currentTimeMillis)]
     (try
       ~form
       (finally
         (let [end# (System/currentTimeMillis)]
           (tap> {:code (pr-str (quote ~form))
                  :time-ms (- end# start#)}))))))

(defmacro t [form]
  (t-reader form))

