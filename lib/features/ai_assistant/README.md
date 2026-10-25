# AI assistant feature

Owns meal analysis, nutrition questions, and AI recommendation presentation.
The Flutter client talks only to a protected application endpoint through a
repository. Provider SDKs, prompts, API keys, retrieval, and schema
validation belong in `backend/` or behind the data boundary.

Every AI response must define loading, timeout, quota, unsafe-content,
unavailable, malformed-response, and offline behavior. Store prompt/model
versions with persisted results when reproducibility matters.
