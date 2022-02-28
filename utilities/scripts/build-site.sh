#!/bin/bash

if ! which hugo > /dev/null; then
    echo -e "please install hugo. Example:"
    echo "wget https://github.com/gohugoio/hugo/releases/download/v0.93.0/hugo_0.93.0_Linux-64bit.tar.gz -P ~/Downloads/"
    echo "sudo tar -xzf ~/Downloads/hugo_0.93.0_Linux-64bit.tar.gz --directory=/usr/local/bin"
    exit 1
fi

pushd $(dirname $0)/../hugo > /dev/null
# remove stale site
rm -rf public/
rm -rf ../../docs

# write current site, including drafts, to local public folder for testing
hugo -D

# write current site to docs folder
hugo -d ../../docs/

echo "Site saved to $PWD/public folder"
echo "'cd' into $PWD and run 'hugo serve -D' to start a local webserver on port 1313 to preview draft content"
popd > /dev/null

echo "Site saved to docs folder. Push changes to main branch to deploy site."
