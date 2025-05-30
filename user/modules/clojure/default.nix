{ config, ... }:
{

  home.file.".clojure/injections".source = ./injections;

  home.file.".clojure/deps.edn".text = ''
    {:aliases {:user {:extra-deps {global/user {:local/root "${config.metadata.homeDir}/.clojure/injections"}
                                   djblue/portal {:mvn/version "${config.metadata.clojurePortal.version}"}}}
               :async-profiler {:extra-deps {com.clojure-goes-fast/clj-async-profiler {:mvn/version "1.4.0"}}
                                :jvm-opts ["-Djdk.attach.allowAttachSelf"]}}}
  '';

  home.file.".lein/profiles.clj".text = ''
    {:user {:dependencies [[djblue/portal "${config.metadata.clojurePortal.version}"]]
            :injections [(load-file "${config.metadata.homeDir}/.clojure/injections/src/tap.clj")
                         (alter-var-root #'default-data-readers
                                         (fn [v]
                                           (-> v
                                               (assoc 'tap #'tap/>-reader)
                                               (assoc 'tapd #'tap/d-reader))))
                         (require 'portal.api)
                         (portal.api/tap)]}}
  '';

  home.file.".config/clj-kondo/config.edn".text = ''
    {:linters {:unresolved-namespace {:exclude [portal tap]}}}
  '';

}
