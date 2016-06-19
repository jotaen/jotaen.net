---
layout:        blogpost
title:         What are JSON Web Tokens?
subtitle:      A short QnA
date:          2016-06-10
tags:          [jwt, qna]
redirect_from: /abcdef/
permalink:     abcdef/jwt-json-web-tokens
image:         /assets/2016/.jpg
---

This blogpost explains the basic idea behind JSON Web Tokens (short: JWT) in the context of web services and applications. It is written in a QnA style.

## What is the idea of JSON Web Tokens (JWT)?

## What does a JWT look like?

A JWT consists of three parts:

1. A **header** section, that contains some meta information, like the algorithm that was used for the signature or the content-type of the JWT.
2. The **claim** section (or: payload section), where the data is stored.
3. The **signature**, so that the data integrity of the token can be validated.

The three parts are Base64-encoded and separated by a dot. A typical JWT would look like this:

{% highlight bash %}
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
{% endhighlight %}

The claim section contains the following data structure:

{% highlight json %}
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
{% endhighlight %}

## Which information can be stored in a JWT?

Any information that is needed to be exchanged can be stored in the JWT. In web applications this might be a user ID or some other fundamental data like the user role or access privileges.

Although the JWT looks cryptic at the first glance, its parts are just base64 encoded. That means, that the information is actually clear text. If you want to store sensitive information, the JWT must be encrypted.

Also, remember that the JWT gets passed on each request, so make sure the payload isn’t too big.

## How are JWTs different from Sessions?

A session
- Session: Client context gets stored on server
- JWT: Client context gets sent on each request
- Session: Hard to debug / test
- Session: Single storage needed (complicated in distributed apps!)

## How do I have to construct the claim section?

You are completely free on how to model the claim section, as long as all consumers of your JWT agree on the format. However, the JWT specification suggests some predefined claims (see next question) and you are good advised to keep your own claims separate from those.

## Are there any predefined claims?

Yes, there are a few registered (reserved) claims, which are described in RFC 7519:

- `iss` (**issuer**): An identifier of the authority, that generated (issued) the token. This could e.g. be an authentication service. The value can be either a string or a URI.
- `sub` (**subject**): The subject, for whom or which the token was created. (String or URI)
- `aud` (**audience**): The recipients, that the token is intended for. This can be used to restrict the “scope” of the token to specific applications or services. (Value: String or URI)
- `exp` (**expiration time**): The time, as of the JWT is expired and must be considered invalid (UNIX Timestamp)
- `nbf` (**not before**): The time, when the token becomes valid. Before that time, the token must not be accepted. (UNIX Timestamp)
- `iat` (**issued at**): Timestamp, when the token was created (UNIX Timestamp)
- `jti` (**Jwt ID**): A unique identifier for the token. This can be use for black- or whitelisting tokens. (String)

There are two things to note about the values:

- **String or URI:** This can just be some name or a valid URI according to [RFC 3986](https://tools.ietf.org/html/rfc3986), e.g.: `http://myApp.com/some/uri` or `mailto:John.Doe@example.com`.
- **UNIX Timestamp:** Remember, that the UNIX time refers to the UTC timezone. This is an important detail, since JWT tokens are usually exchanged beyond the borders of operating systems and it’s not fair to assume, that the issuer is in the same timezone than the audience.

## How can JWTs be invalidated?

If a user executes a logout in a session based web application, than the session is destroyed and thus the user’s session ID can no longer be resolved on the server.

- Not directly
- exp claim
- blacklisting / whitelisting

## Are JWTs secure?

From a cryptographic point of view JWTs are as secure as the utilized algorithms (like RSA). So in theory, they can be considered pretty much reliable.

However, it makes a big difference, how the JWT logic is implemented in your application. Here are some advices:

- Don’t implement crypto stuff yourself and choose from one of the well-tested libraries that are available for many programming languages by this time.
- Make use of the standard claims, especially `exp`. Keep the period of validity short.
- Ignore the `alg` header field, if you know the algorithm, that your JWT has been signated with.[^2] Take care of performing regular updates/upgrades of all dependencies that are relevant to safety.

## What is the difference between the signature algorithms?

There are two algorithms to choose from:

- **Symmetric**


[^2]: There had been [a critical bug](https://auth0.com/blog/2015/03/31/critical-vulnerabilities-in-json-web-token-libraries/) in several JWT libraries.
