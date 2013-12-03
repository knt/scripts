#!/usr/bin/env ruby

##############
# Git-Diff-Next
##############
#
# A script for my current git workflow
# - For each change, do a git diff on the file
# - Add the filename to the clipboard, for quick git adding or other git commanding
#
# Git Status Documentation: https://www.kernel.org/pub/software/scm/git/docs/git-status.html
#
# TO-DO: This currently doesnt work for unmerged changes
# TO-DO: Can be cleaned up heavily after I read the Command Line tools book
#

def git_diff_next
  unstaged_git_files.each do |unstaged_file|
    if unstaged_file.untracked?
      # TODO: For some reason an echo here wouldn't work...why?
      puts "UNTRACKED FILE #{unstaged_file.filename}"
    elsif !unstaged_file.has_unstaged_changes?
      next
    end

   `echo #{unstaged_file.filename} | tr -d '\n' | pbcopy`
   exec "git diff #{unstaged_file.filename}"
  end
end

def unstaged_git_files(show_untracked = true)
  tracked_flag = show_untracked ? "normal" : "no"

  files = `git status --untracked-files=#{tracked_flag} --short`
  files.split("\n").map { |file| GitFile.new(file)}
end


class GitFile
  UNTRACKED_STATUS = "?"
  MODIFIED_STATUS = "M"
  ADDED_STATUS = "A"
  RENAMED_STATUS = "R"
  COPIED_STATUS = "C"
  DELETED_STATUS = "D"
  UNMODIFIED_STATUS = ""

  attr_reader :index_status, :work_tree_status, :filename

  def initialize(git_file_status)
    @index_status = git_file_status[0]
    @work_tree_status = git_file_status[1]
    @filename = git_file_status.split(" ")[1]
  end

  def untracked?
    @work_tree_status == UNTRACKED_STATUS
  end

  def has_unstaged_changes?
    [MODIFIED_STATUS, DELETED_STATUS].include?(@work_tree_status)
  end
end

git_diff_next