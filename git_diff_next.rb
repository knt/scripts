MODIFIED = "M"

tracked_files = `git status --untracked-files=no --short`

tracked_files.split("\n").each do |tracked_file|
  index_status = tracked_file[0]
  work_tree_status = tracked_file[1]
  file_name = tracked_file.split(" ")[1]

  next if index_status == MODIFIED

  `echo git add #{file_name} | tr -d '\n' | pbcopy`
  exec "git diff #{file_name}"
end