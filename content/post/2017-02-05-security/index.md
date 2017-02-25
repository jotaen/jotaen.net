+++
layout = "post"
title = "Protect yourself"
subtitle = "A basic guideline to computer security"
date = "2017-02-05"
tags = ["security"]
image = "/assets/2017/abus-lock.jpg"
id = "dSXhh"
url = "dSXhh/protect-yourself"
aliases = ["dSXhh"]
+++

Every now and then, friends or relatives ask me for advice on how to protect their computers against hackers and malware. This is a tough question and there is no magic bullet or golden answer one could give. First of all: why are we getting hacked at all? Basically for the same reasons why people vandalize, steal or rob in real life: They want to enrich themselves, demonstrate superiority or just do damage for whatever reason. 

- Back in 2000 the computer worm [ILOVEYOU](https://en.wikipedia.org/wiki/ILOVEYOU) spread all over the globe: its purpose was to overwrite random data on the infected machines, eventually causing a damage of several billion USD worldwide.
- In 2012 the database of the business network [LinkedIn was hacked](https://en.wikipedia.org/wiki/2012_LinkedIn_hack) and account credentials of ~6.5 million users were leaked. Due to weak scrambling, some of the passwords could be reconstructed as plain text.
- [CryptoLocker](https://en.wikipedia.org/wiki/CryptoLocker) is a ransomware trojan discovered in 2013. It targets Windows computers and encrypts parts of the local filesystem. Once it is activated, the victim is pressed to pay money within a certain period of time in order to obtain the decryption key from the hacker.
- Social engineering attacks gain more and more popularity nowadays. Mostly, they are aimed at one specific person and can be impressingly sophisticated: there is one case in which a hacker has put a considerable amount of effort into taking over a [precious twitter handle](https://medium.com/@N/how-i-lost-my-50-000-twitter-username-24eb09e026dd#.yo2agtgls).

These are just a few examples and they are somewhat frightening. So, how can we prevent that from happening to us? Instead of being fearful and doing things just for the sake of doing them, it is important to understand the vulnerabilities of a computer system and how they can be exploited. A certain risk will always be remaining.[^1] However, if you want to setup effective barriers of defense, you have to know what you want to protect against.


# Protection strategies

## Passwords

> **Always use long and strong passwords. Never reuse one for multiple services. Never type in a password in an untrusted environment.**

Passwords are only secure as long as they are secret. Never use the same password for multiple sign ups, because if someone gets into possession of it, he would be able to login into other services as well.

Furthermore, the password must be impossible to guess. When it comes to passwords, it’s obvious that the human brain functions entirely different than a computer. A password like `a3Jfi9nC` looks complicated and therefore you might think it were secure. Infact, this password could be cracked within a mere 2 hours on average laptop hardware.[^2]

A good and strong password is…

1.  **…long**: The strength of a password grows dramatically by its length. Every single character you add makes a crucial difference.
2.  **…arbitrary**: Don’t underestimate the effectiveness of modern cracking algorithms. Avoid words, names, birthdates and literally any other predictable pattern.

The best way of dealing with passwords is a password manager. It generates a fresh password each time you sign up somewhere and automatically handles the authentication process for you. That way, you can use passwords like `XED[b%jYlom*SVA1-#P+nGL5>Kw]$u2R&L` but you don’t have to bother about typing it.

Since a password manager is the single point of failure you should protect it with a strong master password. (No, there is no way around that!) Other than that, apps like [Keypass](http://keepass.info/) allow you to add an extra layer of security by using an additional keyfile.

In order to avoid phishing attacks, you should never type in a password on a device that you don’t trust. Only enter your credentials when you can verify that you are on the correct website or in the correct application. A password manager can help here, because you can configure it to work only on the genuine sites.


## 2-factor authentication (2FA)

> **Enable 2-factor authentication whenever possible. 2FA is a must-have for accounts that are related to identity, personal data or finances.**

Using passwords solely is not enough for critical services. Once the password is leaked, you immediately loose control over your account. The idea of 2FA is that you need to authenticate yourself via a second component in addition to providing the correct password. For instance, you need to confirm a security token that gets send to your cell phone or some other device. That way, you must both know the password and be in possession of a particularly registered device.

For me, the unavailability of 2FA is a show-stopper when signing up for a service out of these categories:

- Email address
- Social media account
- Cloud storage
- Bank account
- Payment service

Note, that especially the email address is critical, since many passwords can be restored via mail.


## Files and apps

> **Never load files or apps, unless you trust both the creator and the source of distribution.**

A lot of malware is installed with the unknowing assistance of the user itself. Viruses can be camouflaged and therefore mistakenly recognized as image, text file, app or movie. They come as mail attachment, regular download or even via the good old USB stick. Since malware can be so harmful, you should – without exception – stick to these rules:

- Configure your mail account so it doesn’t load attachments automatically.
- Never download any kind of file from dubious sources
- Only install apps from verified vendors or distributors
- Never plugin hardware that you don’t trust


## Encryption and access control

> **Encrypt all physical devices and always activate access control mechanisms.**

Electronic devices like laptops or smartphones are full of personal data; email and social media software are setup and ready to go. If someone steals one your devices he should not be able to access any of this. However, just configuring a login password is not sufficient, because the thief can extract the storage drive and copy all the data, thereby bypassing the login mechanism of the operating system.

Harddrive encryption is cheap and easy nowadays, and every modern operating system offers seamless support for it. Without knowing the password, the storage remains safe. Use full disc encryption for all devices, especially:

- Computers
- Portable devices (e.g. smartphone)
- External storage drives (e.g. for backups)
- USB sticks


## Networks

> **Never connect to untrusted networks. Never exchange meaningful data via unsecure communication channels.**

Every time you login somewhere or you send an email, data will be transmitted via a network connection. When you connect to some random WiFi hotspot in your neighbourhood, you cannot know whether it is infiltrated or otherwise contaminated – it is not overly complicated to setup a network router to record all data being exchanged. Unless you don’t use secure protocols like HTTPS or IMAP SSL, you should consider all of your communication to be public.


## Backups and recovery

> **Backup all critical data regularly. Keep recovery keys available in a safe place.**

Remember, that all the security mechanisms that you setup for protection take effect to *everyone*. The login prompt of your computer cannot know whether its you or some evil invader. In case you forget the password with which you had encrypted your hard drive, all your data remains inaccessable. There will be no backdoor, and nobody can help you to recover any of your data whatsoever. Therefore you should always keep the reverse scenario in mind. For example, many services offer you recovery keys – you can print them out and then keep them stored in a safe place.

By the way: Making regular backups is actually no security specific thing. However, remember to encrypt your backup drives the same way like your computer, since they contain the same sensitive data.



[^1]: Even big banks cannot be completely secured: Read this story of [the theft of about USD 70 million](https://en.wikipedia.org/wiki/Banco_Central_burglary_at_Fortaleza) from the central bank of brazil.

[^2]: Rate your password in this [password strength checker](https://howsecureismypassword.net/). However, take the result with a grain of salt, since the estimated time of a brute force attack can vary by great measure.
