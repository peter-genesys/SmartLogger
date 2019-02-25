# apex2git

Skip worktree for config file env.json

$ git update-index --skip-worktree env.json
$ git ls-files -v|grep '^S'
S env.json