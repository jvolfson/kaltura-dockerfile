# Dockerized Kaltura server

Docker image(s) containing a pre-configured Kaltura community edition server.


## Usage

1. Add `<your-docker-machine-ip> dockerhost` to `/etc/hosts`
2. Start docker container. You can choose from two images:
```bash
# Either pre-configured Kaltura server running at port 11010...
docker run -d --name kaltura-port-11010 -p 11010:11010 yleisradio/kaltura-dev:port-11010
# ...or running at port 11011
docker run -d --name kaltura-port-11011 -p 11011:11011 yleisradio/kaltura-dev:port-11011
```

**ATTENTION:** It's very important that you set port forwarding to either
`11010:11010` or `11011:11011` and use `dockerhost` as your docker machine's
hostname. See the [following section](#why-does-this-image-exist) for more details.


### Credentials

Both images provide the following pre-configured credentials for admin console,
KMC and API usage.

```
# (Super) admin user
Partner ID:       -2
Username/email:   yle_local_dev@noreply.yle.fi
Admin password:   DEV@yle.fi
Admin secret:     029c0784d8029a9f77c046cd932f843f
 
# Template partner
Partner ID:       99
Username/email:   template@kaltura.com
Admin password:   0+JC2zFUSk=*1
Admin secret:     562bdd7ec07aae3e41243abaa1b0823a
```


## Why does this image exist?

In Yleisradio, we need to use Kaltura backend server in our local development
and CI builds. However, the official `kaltura/server` image requires developer to 
run the post-install steps every time a new container is created. The given
configurations also lock in the used port and hostname (full virtual hostname)
which means that in order to use the backend API/KMC, the exposed container port 
and docker machine hostname must match the pre-configured ones. In addition,
every time when post-install configuration is run, it randomly generates (admin)
secrets, which makes automated integrations extremely difficult.

These images have all post-install steps executed, enabling fast and deterministic
CI builds and local development environment setup.


## Creating partners via API

You can use admin user to create new partners via API. Here is an example
script we're using in Yle for automated partner creation (snipped MIT licensed,
Kaltura client AGPLv3 licensed):

```clj
; license MIT (Kaltura client: AGPLv3)
(ns yle.dev-kaltura
  (:require [clj-time.core :as t])
  (:import (com.kaltura.client.enums KalturaSessionType KalturaPartnerType)
           (com.kaltura.client.types KalturaPartner KalturaAccessControlProfile)
           (com.kaltura.client KalturaClient KalturaConfiguration)))

(defn- create-client! [{:keys [partner-id user-id admin-secret expiry]
                        :or   {expiry (t/minutes 1)}}]
  (let [client (-> (doto (KalturaConfiguration.)
                     (.setEndpoint "http://dockerhost:11010")
                     (.setTimeout 10000))
                   (KalturaClient.))
        session-id (.generateSession client
                                     admin-secret
                                     user-id
                                     KalturaSessionType/ADMIN
                                     partner-id
                                     (t/in-seconds expiry))]
    (.setSessionId client session-id)
    client))

(defn- create-ac-profile! [client name]
  (let [ap (KalturaAccessControlProfile.)]
    (set! (.name ap) name)
    (-> client
        (.getAccessControlProfileService)
        (.add ap)
        (.id))))

; =====

(def ADMIN-CREDENTIALS
  {:partner-id   -2
   :admin-secret "029c0784d8029a9f77c046cd932f843f"
   :user-id      "yle_local_dev@noreply.yle.fi"
   :expiry       (t/minutes 10)})

(def PREDEFINED-AC-PROFILES
  ["predef-1" "predef-2"])

(def admin-client
  (delay (create-client! ADMIN-CREDENTIALS)))


(defn create-partner! [partner-name]
  (let [p (KalturaPartner.)
        user-id (str "admin@" partner-name ".yle.fi")
        kmc-passwd "Password!!"]
    (set! (.name p) partner-name)
    (set! (.type p) KalturaPartnerType/KMC)
    (set! (.description p) "Local partner for local development")
    (set! (.adminName p) "admin")
    (set! (.adminEmail p) user-id)
    (set! (.phone p) "0123")
    (set! (.partnerPackage p) 6)                            ; 6 = Developer
    (set! (.templatePartnerId p) 99)                        ; 99 = default template
    (let [partner (-> @admin-client
                      (.getPartnerService)
                      (.register p kmc-passwd))
          partner-id (.id partner)
          admin-secret (.adminSecret partner)
          credentials {:partner-id   partner-id
                       :admin-secret admin-secret
                       :user-id      user-id}
          client (create-client! credentials)
          ac-profile-ids (doall (map (partial create-ac-profile! client) PREDEFINED-AC-PROFILES))
          [geo-fin geo-world no-security-geo-fin no-security-geo-world] ac-profile-ids]
      {:partner-id     partner-id
       :user-id        user-id
       :admin-secret   admin-secret
       :ac-profile-ids {:fin                geo-fin
                        :fin-noprotection   no-security-geo-fin
                        :world              geo-world
                        :world-noprotection no-security-geo-world}
       :client         client})))

```


## License 

AGPLv3

