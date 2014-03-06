# ------------------------------------------------------------------------------
# Git Review
# ------------------------------------------------------------------------------
# Renames branches to show their current status
# Marks branches as in review, in development, or ready for release
#
# ------------------------------------------------------------------------------

IN_REVIEW_PREFIX="IN_REVIEW_"
RELEASE_READY_PREFIX="READY_"

# Mark branch as in code review (ir - in review)
function ir {
  old_branch_name=`branch_name`
  new_branch_name=${old_branch_name#$IN_REVIEW_PREFIX}
  new_branch_name=${new_branch_name#$RELEASE_READY_PREFIX}
  new_branch_name=$IN_REVIEW_PREFIX$new_branch_name

  rename_branch $old_branch_name $new_branch_name
}

# Mark branch as in development
function id {
  old_branch_name=`branch_name`
  new_branch_name=${old_branch_name#$IN_REVIEW_PREFIX}
  new_branch_name=${new_branch_name#$RELEASE_READY_PREFIX}

  rename_branch $old_branch_name $new_branch_name
}

# Mark branch as ready for release
function rr {
  old_branch_name=`branch_name`
  new_branch_name=${old_branch_name#$IN_REVIEW_PREFIX}
  new_branch_name=${new_branch_name#$RELEASE_READY_PREFIX}
  new_branch_name=$RELEASE_READY_PREFIX$new_branch_name

  rename_branch $old_branch_name $new_branch_name
}

# Get the current branch name
function branch_name() {
  git symbolic-ref HEAD --short
}

# Show the current status of branches
function bs {
  echo "-------------------- READY FOR RELEASE --------------------"

  git branch | grep --color=never $RELEASE_READY_PREFIX

  if [ $? -eq 1 ]
    then
    echo "                          (none)                            "
  fi

  echo
  echo "------------------------ IN REVIEW ------------------------"

  git branch | grep --color=never $IN_REVIEW_PREFIX

  if [ $? -eq 1 ]
    then
    echo "                          (none)                            "
  fi

  echo
  echo "--------------------- IN DEVELOPMENT ----------------------"

  git branch | grep -v "${IN_REVIEW_PREFIX}" | grep -v "${RELEASE_READY_PREFIX}"

  echo
  echo "------------------------- MASTER --------------------------"

  git branch | grep --color=never 'master'
}

# Name the current branch from $1 to $2
function rename_branch() {
  old_branch_name=$1
  new_branch_name=$2

  git branch -m $old_branch_name $new_branch_name
}