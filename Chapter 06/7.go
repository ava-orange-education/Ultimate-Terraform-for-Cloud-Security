package custom

import (
    "github.com/aquasecurity/tfsec/pkg/rule"
)

// init registers the custom rule when the package is imported.
func init() {
    rule.Register(rule.Rule{
        ID:          "CUSTOM_001",
        Service:     "AWS",
        ShortCode:   "s3-encryption",
        Summary:     "Ensure S3 Buckets have encryption enabled",
        Impact:      "Sensitive data stored in S3 could be exposed if not encrypted",
        Resolution:  "Enable server-side encryption on S3 buckets",
        Provider:    "aws",
        Severity:    rule.SeverityHigh,
        // Additional fields such as documentation URL or explanation can be added as needed.
    })
}
