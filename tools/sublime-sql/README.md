# Sublime-SQL

Tools for using sublime text 3 with sqlcl on an oracle database.

Build scripts 
-------------
Sublime can launch sqlplus and sqlcl without these scripts, but tends not to exit.  These scripts will ensure the sql session exits cleanly.

+ run_commit_exit.sql - run an sql script, then commit, and exit.
+ run_weave_exit.sql  - run db object script, then weave the object with sm_weaver, and exit.


Project Files
-------------

Each repo that uses Sublime-SQL as a submodule, will be represented by a branch using that repo's name, in the Sublime-SQL repo.
Basic configuration of the <repo>.sublime-project will be version controlled in that branch.

Each local clone of that repo will also need to skip-worktree on that sublime-project file

  Start git bash in the submodule dir.

  $ git update-index --skip-worktree <repo>.sublime-project
  $ git ls-files -v|grep '^S'

To undo

  $ git update-index --no-skip-worktree <repo>.sublime-project


Workspace Files
---------------
Workspace files are never version controlled.
Currently ignoring \*.sublime-workspace
