# Freebox API in shell

The aim of this project: update port forwarding on the freebox in shell scripts.

Use case: I host my website, and expose only https on 443, with a let's encrypt certificate.  
One automatic way to renew the certificate is to expose the challenge file on http 80 for a short laps of time. So, my renew script will be:
- activate http server on 80 (create a sym link in sites-enabled)
- open http 80
- launch certbot
- close http 80
- disable site on http 80.

# What can you do with this scripts ?

* Create an application to call the freebox api (v0.1)
* login to you freebox (v0.1)
* add / delete port forwarding (v0.1)
* update a rule (v0.2)

Since you have the skeleton and the login phase, you can call all the other API by creating you own shells scripts.

# How to use it

* Create the application in the freebox:
  * copy .env.example to .env
  * populate value in .env as you wish
  * call: `./request-token`
* Add a port forwarding rule:
  * call: `./add-port-forwarding-rule.sh  .fr.freebox.my_app 192.168.0.250 80 8080 false certbot`
  * This create a rule to redirect traffic incoming on port 80 on the wan interface to the port 8080 of the server binded on 192.168.0.250
* Delete a port forwarding rule:
  * call: `./delete-port-forwarding-rule.sh .fr.freebox.my_app comment certbot`
  * This will search a rule with "certbot" in the comment field, and delete the rule.
* Update a port forwarding rule:
  * call: `./update-port-forwarding-rule.sh .fr.freebox.my_app comment certbot enabled true`
  * This will search a rule with "certbot" in the comment field, and update the field enable to true.
  
# External documentation

* [Certbot / Let's encrypt](https://certbot.eff.org/lets-encrypt/debianbuster-nginx)
* [Freebox official api](https://dev.freebox.fr/sdk/os/)
