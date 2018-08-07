#!/bin/bash
set -m # Enable Job Control

forkedBy="jethromx"
masterBy="kiegroup"

function getRepoGitHub() {
  line=$1;


  if [ ! -d "$line" ];then
    echo "*************** Cloning... : $line"
    git clone "git@github.com:${forkedBy}/${line}"

    echo "*************** Add upstream"
    reference="git@github.com:${masterBy}/${line}"
    git --git-dir=${line}/.git --work-tree=${line} remote add upstream $reference

  fi

  #git --git-dir=${line}/.git --work-tree=${line} remote set-url origin "git@github.com:${forkedBy}/${line}"
  #git --git-dir=${line}/.git --work-tree=${line} remote set-url upstream "git@github.com:${masterBy}/${line}"

  echo "*************** Update from upstream to master(fork)"
  git --git-dir=${line}/.git --work-tree=${line} pull upstream master

  echo "*************** Add all "
  git --git-dir=${line}/.git --work-tree=${line} add .

  echo "*************** Commit "
  git --git-dir=${line}/.git --work-tree=${line} commit -m "update from upstream"

  echo "*************** Push to github"
  git --git-dir=${line}/.git --work-tree=${line} push origin master

}


while IFS='' read -r line || [[ -n "$line" ]]; do
  getRepoGitHub $line $forkedBy $masterBy &
done < "$1"

# "fg" to bring a background job into the foreground. It does this in a
#  loop until fg returns 1 ($? == 1)
# Wait for all parallel jobs to finish
while [ 1 ]; do fg 2> /dev/null; [ $? == 1 ] && break; done

echo "Done"
