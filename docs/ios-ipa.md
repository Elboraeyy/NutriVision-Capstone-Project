# iOS IPA GitHub Action

The workflow at `.github/workflows/ios-ipa.yml` builds the Flutter iOS app on a
macOS GitHub runner and uploads a downloadable IPA artifact.

## How to run it

- Push to `main`, or
- Open GitHub → Actions → **Build iOS IPA** → **Run workflow**.

When the run succeeds, open the run summary and download the artifact named
`nutrivision-ios-ipa-<run-number>`. It contains:

- `NutriVision-unsigned.ipa`
- `NutriVision-unsigned.ipa.sha256`

The workflow validates that the downloaded file is a valid IPA archive and
that it contains `Payload/Runner.app/Info.plist`.

## Signing note

The repository currently has no Apple signing certificate, provisioning profile,
or App Store Connect credentials. The workflow therefore uses
`--no-codesign` and produces a correctly packaged **unsigned** IPA. It is safe
to download and inspect, but an unsigned IPA cannot be installed on a physical
iPhone or uploaded to TestFlight.

To produce an installable/TestFlight IPA later, add Apple signing to a separate
protected workflow using GitHub Actions Secrets or Environments. Never commit
`.p12`, `.mobileprovision`, private keys, or App Store Connect credentials.
