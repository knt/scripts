#!/usr/bin/env ruby

##############
# Git-Branch-Merge
##############
#
# WARNING: This script is higly experimental and might break things
# You have been warned.
#
# A ruby script to iterate over each branch and merge in changes from master
# This can probably be done with a complicated git command, but I'm doing this
# more as an exercise in writing scripts in Ruby
#
# TO-DO: Properly handle merge failures

def git_branch_merge
  initial_branch = get_current_branch

  branches.each do |branch|
    `git checkout #{branch}`
    `echo "Merging master into #{branch}" >&2`
    `git pull --rebase origin master`
    `echo "Master merged into #{branch}" >&2`
  end

  `git checkout #{initial_branch}`
end

def branches(show_untracked = true)
  branches = `git branch`
  branches.gsub(/[\* ]/, '').split("\n")
end

def get_current_branch
  `git rev-parse --abbrev-ref HEAD`
end


git_branch_merge