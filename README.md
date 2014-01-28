LoAuth (Layered OAuth)
===

---------------------

Shared access library for Ruby/Rails that supports OAuth2 with multiple layers of security.

Multi-layered security
-----------------------

LoAuth implements multi-layered security, with basic token access at the bottom layer and full OAuth2 compliance at the top layer. 

The amount of data exposed to a consumer matches their level of compliance with OAuth2. So non-compliant consumers can still log in and receive a token, but this token may be restricted.

Concerns
------

The reader may be thinking: 

__"Isn't this less secure than just forcing all consumers to comply with OAuth2?"__

LoAuth applies the strategy of "defense in depth," meaning the focus is on slowing down an attacker rather than preventing attacks outright. 

Out of scope
------------

- User authentication library
- Single sign-on library
- Session persistence library

Three levels of security
------------------------

Levels 2 and 3 are designed to be used with SSL/TLS enabled.

#### Level 1: Basic

HTTP Basic equivalence: A global access token for a user is created at login, and destroyed at logout. Consumers do not need to be registered to use the access token.

This is ideal when you don't have any immediate need for OAuth2 compliance, but just need shared state across multiple domains, managed by a central server.

#### Level 2: Lite (PENDING)

Builds on Level 1 by adding scope- and consumer-specific access tokens.

This allows your users to select which content they allow a consumer to access. It follows the OAuth2 standard for both the authorization code flow and the implicit grant flow. However, only access tokens are issued -- not refresh tokens -- and access tokens are not short-lived.

#### Level 3: Full (PENDING)

This level introduces the refresh token, and requires consumers to be fully OAuth2-compliant. Access tokens are generated as needed, and they expire quickly. The refresh token is used to poll for new access tokens.

Data siloing
----------------------

Attributes on Rails models can be restricted by security level, which is automatically assigned to each access token by LoAuth based on how the token was requested by the consumer. 

Usage for Rails
---------------

LoAuth includes a generator. called "lo_auth:install". Type "rails g lo_auth:install" to install LoAuth into your Rails app.

This will create the files necessary to begin using LoAuth in your app. These files are well-commented and form a minimal LoAuth integration. Developers are encouraged to study the generated code and extend it to suit their application's needs.
