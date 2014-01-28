LoAuth
===

Shared access library for Ruby/Rails that supports progressive enhancement and OAuth2.

What LoAuth is *not*
--------------------

- User authentication library
- Single sign-on library

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

Each token is associated with a certain security level, and can only be used to fetch data at or below that security level. It is possible to return a different representation of a single Rails model for each security level.

This gives an assurance that sensitive data will not be shared except with consumers above a certain threshold of security.

Usage for Rails
---------------

LoAuth includes a generator. called "lo_auth:install". Type "rails g lo_auth:install" to install LoAuth into your Rails app.

This will create files necessary to begin using LoAuth in your app. These files are well-commented and form a minimal LoAuth integration. Developers are encouraged to extend the generated code to suit their application's needs.

