boot-notify
-----------

"boot-notify" is a systemd service the sole purpose of which is to e-mail boot and shutdown notifications. The mail recipient learns that the remote computer is on and finds out remote computer's external address. The ultimate purpose is to make it possible for the mail recipient to ssh into the remote computer.


SCRIPTS USED BY BOOT-NOTIFY
- sendopen.sh  -  sends e-mail with information about the current local network IP and the current external IP;
- sendclose.sh -  sends e-mail notifying that the host computer has been shut down.

Both the scripts can be called manually.

Both the scripts take recipient's e-mail address as a parameter. If the e-mail address is missing, the scripts look for recepient's address in /etc/aliases as defined for the $USER who sends the message. 
Be careful to configure e-mail server/passwords correctly, and note that that at boot time e-mail is sent by root while your e-mail configuration may have been made for another user. Beware of permissions. During the boot time you may have to use "sudo -u $USER..." for e-mail to work.


DEPENDENCIES AND CONFIGURATION REQUIREMENTS
- systemd
- msmtp   (or any other smtp client)
- s-nail  (or heirloom-mailx) (MUA = Mail User Agent)
- gpg     (optional)
- curl    (or wget)

Note 1: Both s-nail and heirloom-mailx provide command "mail" ("mailx") used to send mail to an SMTP server.

Note 2: If you use msmtp create a symbolic link /usr/bin/sendmail pointing to /usr/bin/msmtp. You can do it manually, by installing sm-c (sendmail connector; see http://github/wiemag/sm-c), or by installing mta-msmtp.

Note 3: The gpg is needed if you want to conceal your passwords. However, empty password to decode a file with the password is used. Stilil, it raises the security level of e-mail passwords.

Note 4: Although the information sent at boot time is supposed to help ssh into the sender's computer, no information about SSH is included. The recepient has already got to know the port, the user name and the ssh password to be able to make such a connection.


ASSUMPTIONS
- The msmtp and s-nail have been installed and configured.
- The symbolic link (see Note 2 avove) has been created. The author uses sm-c.
- (Not required yet, see below) Thunderbird installed on the recepient's side.


FURTHER DEVELOPMENT (as on 2013-10-27)

The author already uses a script that reads thunderbird's inbox to find out remote computer's IP and connects through ssh to that computer. The script is not universal yet, and so it cannot be published.
The author will eventually make the script universal, but has no intension to make the script work with other e-mail clients.
