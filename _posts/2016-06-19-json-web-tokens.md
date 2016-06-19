---
layout:        blogpost
title:         What are JSON Web Tokens?
subtitle:      A QnA style blogpost
date:          2016-06-19
tags:          [jwt, qna]
redirect_from: /C3K4N/
permalink:     C3K4N/jwt-json-web-tokens
image:         /assets/2016/notebook.jpg
---

This blogpost explains the basic idea behind JSON Web Tokens (short: JWT) in the context of web services and applications. It is written in a QnA style.

## Which purpose do JSON Web Tokens (JWT) fulfill?

The [explanation on Wikipedia](https://en.wikipedia.org/wiki/JSON_Web_Token) is basically quite good, so I just cite it:

> JSON Web Token (JWT) is a JSON-based open standard (RFC 7519) for passing claims between parties in web application environment. The tokens are designed to be compact, URL-safe and usable especially in web browser single sign-on (SSO) context. JWT claims can be typically used to pass identity of authenticated users between an identity provider and a service provider, or any other type of claims as required by business processes. The tokens can also be authenticated and encrypted.

I recommend you to have a look at the [RFC 7519 full text](https://tools.ietf.org/html/rfc7519) – it’s not that long and quite legible.

When you want to explore JWTs hands-on, then [jwt.io](https://jwt.io/) is a good starting point.

## How is “JWT” pronounced?

You can pronounce it like the english word “jot”[^1] or just spell it out (*Jay, Double-u, Tee*). Both ways are pretty common.

## What does a JWT look like?

A JWT consists of three parts:

1. A **header** section, that contains some meta information in JSON format, like the algorithm that was used for the signature or the content-type of the JWT.
2. The **claim** section (or: payload section), where the data is stored. This also is a JSON data structure.
3. The **signature**, so that the data integrity of the token can be validated.

The three parts are base64-encoded and then separated by a dot. A ready-made JWT would look like this:

{% highlight bash %}
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
{% endhighlight %}

The claim section contains the following data:

{% highlight json %}
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
{% endhighlight %}

## Which information can be stored in a JWT?

Any information that is needed to be exchanged can be stored in the JWT. In web applications this might be a user ID or some other fundamental data like the user role or access privileges.

Although the JWT looks cryptic at the first glance, its parts are just base64 encoded. That means, that the information is actually clear text. However, if the client (or an attacker) would manipulate the claim section, the signature would become invalid.

## Which information should not be stored in a JWT?

Don’t store sensitive information in the JWT, unless you encrypt the JWT. Also, remember that the JWT gets passed on each request, so make sure the payload isn’t too big.

## How are JWTs different from sessions?

A session means, that client information gets stored on the server. The client only obtains a session identifier, so the server knows what information belongs to it. There are two major problems with this:

1. The server has state. One and the same request behaves differently depending on the state of the internal session. This makes debugging and testing difficult.
2. A single storage is needed to hold all the session information. This can be a big challenge in distributed applications.

As opposed to this, JSON Web Tokens contain all the relevant data to identify a client and sends this along on each request.

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
- `jti` (**Jwt ID**): A unique identifier for the token. This can be used for black- or whitelisting tokens. (String)

There are two things to note about the values:

- **String or URI:** This can just be some name or a valid URI according to [RFC 3986](https://tools.ietf.org/html/rfc3986), e.g.: `http://myApp.com/some/uri` or `mailto:John.Doe@example.com`.
- **UNIX Timestamp:** Remember, that the UNIX time refers to the UTC timezone. This is an important detail, since JWT tokens are usually exchanged beyond the borders of operating systems and it’s not fair to assume, that the issuer is in the same timezone than the audience.

## How can JWTs be invalidated?

If a user executes a logout in a session based web application, the session is destroyed and thus the user’s session ID can no longer be resolved on the server.

A JWT doesn’t work like this, since there is no server-side state that the JWT is checked against. Of course you could maintain a list of all issued JWT tokens and validate the JWT on each request. But that way you would loose the benefits of being stateless on the server and you would produce a massive lookup overhead, especially in distributed applications.

The following pattern has established as a common practice to sort out this problem:

1. Keep the expiration time short, e.g. 15 minutes.
2. When your application finds the JWT to be expired, it automatically tries to renew the JWT at the authentication service.
3. The authentication service issues a new JWT, except when the former one is too old (like 1 week of inactivity) or if it was blacklisted (which is what you will do on logout).

## Are JWTs secure?

From a cryptographic point of view JWTs are as secure as the utilized algorithms (like RS256). So in theory, they can be considered pretty much reliable.

However, it makes a big difference, how the JWT logic is implemented in your application. Here are some advices:

- Don’t implement crypto stuff yourself and choose from one of the well-tested libraries that are available for many programming languages out there.
- Make use of the standard claims, especially `exp`. Keep the period of validity short.
- Ignore the `alg` header field[^2], if you already know the algorithm, that your JWT has been signed with.
- Take care of performing regular updates/upgrades of all code dependencies that are relevant to safety.

## What is the difference between the signature algorithms?

There are two approaches to choose from:

- **Symmetric algorithms** like HS256. The signature gets both created an validated with the same secret password.
- **Asymmetric algorithms** like RS256. The signature gets created with a private key and can be validated with a corresponding public key.

In a distributed application it suggests itself to choose asymmetric validation: The private key can remain in a single, well protected place, while the public key can be distributed unworriedly.

However, if issuer and audience of the JWT are one and the same, you can go with a symmetric algorithm.


[^1]: RFC 7519 suggests to pronounce it “jot”.
[^2]: In 2015 there had been [a critical bug](https://auth0.com/blog/2015/03/31/critical-vulnerabilities-in-json-web-token-libraries/) in several JWT libraries.
