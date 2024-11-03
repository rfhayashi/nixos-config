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

(def ^:private !timers (atom {}))

(defn start-timer [id]
  (let [start (System/currentTimeMillis)]
    (tap> [:start-timer id])
    (swap! !timers update id (fn [v]
                               (if-not v
                                 start
                                 (throw (ex-info "Timer already started" {:timer-id id})))))
    nil))

(defn end-timer [id]
  (if-let [start (get @!timers id)]
    (let [end (System/currentTimeMillis)]
      (tap> [:end-timer id (- end start)])
      (swap! !timers dissoc id))
    (throw (ex-info "Timer has not been started" {:timer-id id}))))

(defn reset-timer [id]
  (swap! !timers dissoc id))

