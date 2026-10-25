# Core errors

Put shared, transport-agnostic failure types and error-mapping contracts here.

Feature-specific failures should remain in the feature domain when they carry
business meaning. Widgets should receive typed state and should not parse raw
HTTP, Firebase, or provider exceptions.
