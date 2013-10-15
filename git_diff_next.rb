##############
# Git-Diff-Next
##############
#
# A script for my current git workflow
# - For each untracked change, do a git diff on the file
# - Add 'git add' for that file onto the clipboard

MODIFIED = "M"

tracked_files = `git status --untracked-files=no --short`

tracked_files.split("\n").each do |tracked_file|
  index_status = tracked_file[0]
  work_tree_status = tracked_file[1]
  file_name = tracked_file.split(" ")[1]

  next if index_status == MODIFIED

  `echo #{file_name} | tr -d '\n' | pbcopy`
  exec "git diff #{file_name}"
end