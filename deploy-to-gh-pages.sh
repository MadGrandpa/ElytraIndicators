#!/bin/bash
echo "Starting deployment"
echo "Target: gh-pages branch"

DIST_DIRECTORY="build/libs"
CURRENT_COMMIT=`git rev-parse HEAD`
ORIGIN_URL=`git config --get remote.origin.url`
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/\/\/github.com/\/\/$GITHUB_TOKEN@github.com}

cp .gitignore $DIST_DIRECTORY || exit 1

#echo "Checking out gh-pages branch"
#git pull origin gh-pages
#git checkout gh-pages || exit 1

#echo "Removing old static content"
#git rm -rf . || exit 1
#force

git clone -b gh-pages --single-branch "$ORIGIN_URL" workwork

echo "Copying dist content to root"
cp -r $DIST_DIRECTORY/* workwork || exit 1
#cp $DIST_DIRECTORY/.gitignore . || exit 1

echo "Pushing new content to $ORIGIN_URL"
git config user.name "YOUR-GITHUB-USERNAME-HERE" || exit 1
git config user.email "YOUR-GITHUB-EMAIL-HERE" || exit 1


cd workwork

git add -A *.jar || exit 1
git commit --allow-empty -m "Regenerated static content for $CURRENT_COMMIT" || exit 1
git push --force --quiet "$ORIGIN_URL_WITH_CREDENTIALS" gh-pages > /dev/null 2>&1

cd ..

echo "Cleaning up temp files"
rm -Rf $DIST_DIRECTORY

echo "Deployed successfully."
exit 0