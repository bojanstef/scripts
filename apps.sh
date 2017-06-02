#!/usr/bin/env bash

FILE="${HOME}/.apps"

echo "# brew list" > $FILE
eval brew list >> $FILE
echo "" >> $FILE

echo "# brew cask list" >> $FILE
eval brew cask list >> $FILE
echo "" >> $FILE

echo "# mas list" >> $FILE
eval mas list >> $FILE
echo "" >> $FILE

