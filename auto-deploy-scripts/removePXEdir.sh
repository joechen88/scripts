#!/bin/bash

# USERNAME=$1
# H=$(sudo -H -u  joechen bash -c 'echo $HOME')

echo "BEFORE:"
du -chs $HOME/public_html
echo "Remove previous pxe image in ${HOME}/public_html/pxeinstall to free up some space..."
rm -rf $HOME/public_html/pxeinstall
echo "AFTER:"
du -chs $HOME/public_html
