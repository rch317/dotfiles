#!/bin/sh

for i in $(ls -1 |grep ^dot)
  do
    ### Remove pre-existing symlinked files that match
    if [ -h "${HOME}/${i#"dot"}" ]; then
      rm ${HOME}/${i#"dot"}
    fi

    ### Regular files, lets create a backup
    if [ -f "${HOME}/${i#"dot"}" ]; then
      cp ${HOME}/${i#"dot"} ${HOME}/${i#"dot"}.old
    fi

    ### Remove old file, only if we created a backup
    if [ -f "${HOME}/${i#"dot"}" ] && [ -f "${HOME}/${i#"dot"}.old" ]; then
      rm ${HOME}/${i#"dot"}
    fi

    ### Any file
    ln -s ${PWD}/${i} ${HOME}/${i#"dot"}
  done
