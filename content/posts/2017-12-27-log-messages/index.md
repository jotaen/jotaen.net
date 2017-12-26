+++
draft = true
title = "Critical debug info"
subtitle = "Sensible logging in web applications"
date = "2017-12-27"
tags = ["logging", "operating"]
image = "/posts/2017-12-27-log-messages/yoyogi-park.jpg"
id = "oGBQj"
url = "oGBQj/critical-debug-info"
aliases = ["oGBQj"]
+++

<!--Log strategy: why do we log? for whom do we log?-->

# Log levels

The usage of a certain set of log levels is widely supported by log libraries and has been established to be a common best practice. Some libraries define additional log levels and therefore allow for a more fine-granular shading or slightly different semantics. But at its heart it boils down to five essential ones: critical, error, warning, info, debug.

### Critical

A “critical” log means that the application is in an overall undefined or inconsistent state. Critical errors are usually not scoped to one request, but they affect the application on a global level. They usually deserve immediate reaction, because either the application fails as a whole or more harm is about to be done. For example:

- The webserver fails to start altogether because some mandatory configuration was not provided. (Think of a missing SSL certificate or an incorrect database password.)
- Write operations on the file system fail due to all disk space being eaten up. (Pro-tip: it’s handy to have some sort of heads-up prior to this situation – once it happens though, it’s critical.)

Bottom line: something is fundamentally going wrong and requires immediate fixing. Use this level if you want an alert to be triggered.

### Error

A log event with level “error” means that the current task failed to execute, but the application is (assumably) in an overall healthy state:

- A request could not be processed because the database didn’t send a response in time.
- In a non transaction-safe system, a sequence of write operations fails irrecoverably halfway between, leaving data in an incosistent state.

Bottom line: some business functionality has failed and the application can neither recover from the failure nor gracefully deal with it. Use this level if you want an error to be reviewed and taken care of individually.

The difference between “error” and “critical” is mostly about scope and impact of a problem. The second scenario is a good example here: depending on the case, a data inconsistency might also be critical if you would expect the malformed data to spread and cause more damage.

### Warning

A warning is an indication that an error is likely about to happen near future. Imagine something along the lines of:

- A database connection pool falls below a certain threshold of available connections.
- An network operation was close to running into a timeout.

Bottom line: nothing has gone wrong yet, but chances are that something will go wrong very soon – precautionary action might be necessary. Use this level if you want to bring something to the attention of software engineers proactively. (However, be disciplined and don’t overuse it.)

One thought about warnings from personal experience: I use warnings very scarcely and almost always find that there are more effective ways to receive preventive notices about potentially precarious system state; of which more later.

### Info

“info” logs should yield the broad picture of the things that are going on in the application. They can be crucial for fixing bugs or tracing issues that get reported by users. Moreover, they allow for comprehensive statistical analysis of the app usage.

Bottom line: use this level to describe the current state of a request from a higher perspective.

### Debug

While “info” logs tell you *what* has happend, the “debug” logs provide context to understand *why* and *how exactly* something occured. Context is fluent or at least transient, meaning that it will vanish or change over time. With “debug” statements you can capture the most important bits in the logs.

Bottom line: use this level to provide contextual information that allow you to backtrace and understand an issue later on. (Tip: maybe it helps you to put yourself into the shoes of a developer who needs to fix a bug.)

The only limits for debug logs are probably disk space and data privacy.


# Logging in real life

Knowing what log levels there are and understanding the idea behind them is only half the battle. In order to use logging in a sensible way there are practical aspects you should be aware of. Let me illustrate this with some piece of code: in the following example you see a method from a service layer of a web application. Its job is to read a post (e.g. a blog post) from a database and serve it to the user. (Of course only in case the post was found and the user has appropriate permissions to access it.)

[^1]
```java
Post read(String postId, User principal)
throws PostException, DatabaseException
{
    log.info("User requesting post.")
    log.debug("Post id: " + postId);
    log.debug("User id: " + principal.getId());

    try {
        Post post = database.findPostById(postId);

        if (post == null) {
            log.info("Not found: Post is not existing.");
            throw new NotFoundException();
        }

        Auth auth = post.canBeReadBy(principal);
        if (!auth.isGranted()) {
            log.info("Access denied: user not allowed to see post.");
            log.debug("Reason: " + auth.getReason());
            log.debug("User roles: " + user.getRoles());
            throw new AccessDeniedException();
        }

        return post;
    } catch (ConnectionException e) {
        log.error("Database connection failed.", e);
        throw e;
    }
}
```


## Log severity and client errors are separate things

Only because something failed on the server doesn’t mean that the client must bring this to the attention of the user. The same holds true the other way around: only because the client displays an error doesn’t mean that something went wrong on the server.

Consider the database connection failure: a read operation on a post resource is idempotent and a network failure is most likely a temporary thing. If the server did translate `ConnectionException` into HTTP status 503, the client could just wait a couple of seconds and then retry the operation. The retry is likely to succeed and the user would hardly ever notice about it.

On the other hand, imagine the cases where the post is not found or the user doesn’t have proper rights to access to it. The client will show an error to the user explaining them why the post cannot be retrieved. However, from the point of view of the server this is actually well-defined behaviour. (Performing this check is literally in the job description of that method.) The server only informs in the logs about this occurrence, but there is nothing going wrong in the first place – hence the “info” level.

## Logging only becomes powerful with heuristic analysis

Log statements should be written from the current point of view of the application. They shouldn’t make assumptions about any external implications or the circumstances that might have led to the failure to begin with.

- A single connection timeout can stem from a temporary glitch in the local network. However, if the connections continue to fail over a longer period of time, a more fundamental problem might be the root cause.
- A single failing authentication check can be triggered by one user whose session was expired. However, a rapid increase in failing authentication checks can indicate that someone is trying to brute-force the API.

Especially if you consider the second case it’s arguably not wrong to bump the log level to “warning”. However, the effect that you are aiming for cannot be accomplished by the logging alone; instead you might even end up with producing a lot of noise in the logs due to false positives.

A more suitable way is to complement your logging setup with tools[^2] that are able to perform heuristic analysis of logs, preferrably in realtime. This allows you – on an overarching level – to define precise thresholds, visualise borderline behaviour and respond to unfolding deficiencies effectively.

## Log statements should be machine processable

In the example above I use “info” logs for plain descriptions and provide concrete values in “debug” logs. This is only a personal preference: you can also find good reasons to provide the values within one single “info” statement. But no matter how you do it eventually, you should make sure that logs can be found and aggregated by their message.

Imagine we replaced the three log statements in the authentication failure with one single line and inserted the data into the continuous text, like so:
*“User with id `%s` is not allowed to access post with id `%s` because their role is `%s`”*. This format is unnecessarily hard to search for:

- If you are interested how often that code branch gets invoked you would need to search for only a fragement of the sentence which doesn’t contain any ids.
- If you are interested in all events with a particular post-id or user-id you would need to take into account how exactly these sentences are phrased. (As opposed to having a unified format.)

One related tip: it is very convenient if you can identify all logs on a per-request basis. That way, if you see an error in the logs, you can inspect all log messages of that particular request that got issued prior to the error. Consult the documentation of your HTTP framework and log library on how to do that. Supplementing this technique with a log prerocessor can make for a powerful setup.

## Logging is impure

Logging something in the application is very meta and therefore might feel like an extraordinary thing to do. If you use battle-proof libraries (which you should) it is furthermore a cheap and resilient operation. Keep in mind though, that every log line that gets written or sent somewhere is technically a side effect that relies on global state.

In the example above `canBeReadBy` could also just return a boolean value instead of an `Auth` object. However, then we either wouldn’t get to know why the authentication check has failed in the first place, or we would need to log within the `Post` class. The first might not be acceptable from a debugging perspective, whereas the latter might not be acceptable from a code design perspective (e.g. because the permission check is designed to be strictly pure). Returning the authentication result in form of an object allows us to pass on the responsibility of logging to the caller while still providing enough of the original context.

Another downside of logging can be its verbosity: if you copy & pasted the example into an editor and omit all log statements you would see how much more concise the code will become all of a sudden. I personally prefer to keep logging in the upper layers of my application, but I leave it as explicit and granular as necessary there.


[^1]: This is the method written in Java. Just assume this: 1) The principal represents the inquiring user. 2) The log and database objects were injected into the class upon construction. 3) Exceptions are handled by an upper layer and get translated into HTTP status codes there.

[^2]: Examples for full-featured logging tools are [Kibana](https://www.elastic.co/products/kibana), [Google Stackdriver](https://cloud.google.com/stackdriver) or [AWS CloudWatch](https://aws.amazon.com/cloudwatch/).