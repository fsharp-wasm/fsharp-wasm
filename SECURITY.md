# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| main branch | ✅ |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do not** open a public issue
2. Email the maintainers directly or use [GitHub Security Advisories](https://github.com/fsharp-wasm/fsharp-wasm/security/advisories/new)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and work with you to address the issue before any public disclosure.

## Scope

This project is a compiler backend. Security concerns primarily relate to:

- **Generated Wasm binaries** — ensuring compiled output does not contain unintended behavior
- **Supply chain** — integrity of dependencies (Fable, FCS, wasm-tools)
- **Input handling** — malformed F# input should not cause crashes or undefined behavior in the compiler
