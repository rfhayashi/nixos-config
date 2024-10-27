{ metadata, ... }:
{

  home.file.".clojure/injections".source = ./injections;

  home.file.".clojure/deps.edn".text = ''
    {
      :aliases {:user {:extra-deps {global/user {:local/root "${metadata.home-dir}/.clojure/injections"}
                                    djblue/portal {:mvn/version "${metadata.clojure-portal.version}"}}}}
    }
  '';

  home.file.".lein/profiles.clj".text = ''
    {:user {:dependencies [[djblue/portal "${metadata.clojure-portal.version}"]]
            :injections [(load-file "${metadata.home-dir}/.clojure/injections/src/tap.clj")
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
