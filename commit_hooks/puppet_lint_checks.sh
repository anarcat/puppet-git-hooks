#!/bin/sh

git_root=`git rev-parse --show-toplevel`
syntax_errors=0

# De-lint puppet manifests
if [ `which puppet-lint` ]; then
    for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep \.*.pp$`; do
        puppet-lint --fail-on-warnings --with-filename --no-80chars-check $git_root/$puppetmodule
        RC=$?
        if [ $RC -ne 0 ]; then
            syntax_errors=$(expr $syntax_errors + 1)
            echo "Error: styleguide violation in $puppetmodule (see above)"
        fi
    done
fi

if [ $syntax_errors -ne 0 ]; then
    echo "Error: $syntax_errors styleguide violation(s) found.  Commit will be aborted."
    exit 1
fi

exit 0