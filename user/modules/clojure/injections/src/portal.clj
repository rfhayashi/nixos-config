(ns portal
  (:require [portal.api :as p]))

(defonce portal-atom (atom nil))

(defn open []
  (if-let [p @portal-atom]
    (p/open p)
    (reset! portal-atom (p/open))))

(defn send [v]
  (when-let [p @portal-atom]
    (reset! p v)))

(defn fetch []
  (when-let [p @portal-atom]
    @p))
