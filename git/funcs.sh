# Git aliases are inspired by
# https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh

# ==================================================
# Preparing a commit
# ==================================================
alias giA='git add -A'
alias gia="git add"
alias gir="git restore --staged"

alias gwc="git clean -id"
alias gwu="git restore --worktree"

alias gcm="git commit"
alias gce="git commit --amend --reuse-message HEAD"
alias gcE="git commit --amend"

# Git "Commit All and Push"
function gcap() {
    git add . && git commit -m "$*" && git push
}
# Usage: gcap "Fixed the header padding and updated README"

# ==================================================
# Status
# ==================================================
alias gws="git status --short"
alias gwsi="git fuzzy status"

# ==================================================
# Diff
# ==================================================
alias gdd="git diff --stat -p"            # diff with stat and patch (via git-delta viewer)
alias gds="git --no-pager diff --stat"    # diff with stat only
alias gdt='git difftool'                  # difftool in Vim
alias gdtui='git difftool --gui'          # DiffMerge or whatever GUI diff tool

# git fuzzy diff, plus opening selected files in "git difftool"
function gdi(){
  IFS=$'\n'
  files=($(git fuzzy diff "$@"))

  if [ -n "$files" ]; then
    git difftool "$@" -- "${files[@]}"
  fi
}

# Use Git’s colored diff when available
hash git &>/dev/null;
    if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@";
    }
    fi;

# ==================================================
# Merging
# ==================================================
alias gmm='git merge --no-ff'
alias gmt='git mergetool --no-ff'
alias gmb="git show-branch --merge-base" # show commit merge-base between multiple refs
alias gmc='git log --left-right --oneline --merge' # in case of conflicting merge, show which commits contribute to a conflict

# ==================================================
# Branching
# ==================================================

# list all branchs. Add "-a" to list both local and remote
alias gbl="git branch -v"
# find which branches contain given ref
alias gbhas="git branch --contains"
# show graph of branches, use --topics and --independent flags if needed
alias gbg="git show-branch --date-order --sha1-name"

# git checkout
alias gbc="git checkout"
# <git branch checkout interactive>

# Without arguments, shows all branch to choose from in fzf, with "git log" preview
# With arguments, acts as a bare "git checkout"
# <git branch checkout interactive x2>
function gbci() {
  if [ "$#" -gt 0 ]; then
    git checkout "$@"
  else
    local source_command="git branch -a"
    local preview_command="git log --graph --decorate --date-order -n 50 --color=always --pretty=format:\"$_git_log_oneline_format\" {-1}"
    local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

    if [[ -n "$selection" ]]; then
      git checkout "$(trim $selection)"
    fi
  fi
}

alias gbcii="git fuzzy branch"

# git checkout where HEAD was 1 movement before (using 1st entry from reflog)
# <git branch checkout back>
function gbback(){
  local head_prev_commit=$(git rev-parse HEAD@{1})
  local head_prev_name=$(git name-rev "$head_prev_commit" | awk '{print $2}')
  git checkout $head_prev_name
}

# Check out the commit before HEAD (first parent)
function prec() {
    git checkout HEAD^1
}

# Check out the commit after HEAD on a branch (default master); undoes prec
# $ nextc feature-x
function nextc() {
    git log --reverse --pretty=%H "${1:-master}" | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
}

# Interactive rebase of the last N commits
# $ griii 3
function griii() {
    git rebase -i HEAD~$1;
}

# ==================================================
# Explore single commit
# ==================================================

# Show single commit description by given revision
alias gcs="git --no-pager show -s --oneline"
alias gcS="git --no-pager show --stat"

# git fuzzy diff for a single commit, similar to git show <commit>
function gcsi() {
  local rev=${1:-HEAD}
  gdi "$rev~" "$rev"
}


# ==================================================
# Log & history
# ==================================================

# git log
# TODO: generate log with messages only
alias glo='git log --topo-order --pretty=format:"$_git_log_oneline_format"'
alias glg="glo --topo-order --boundary --graph"
alias gla="glo --topo-order --boundary --graph --all"

# show left-right markers of triple dot revision syntax
# $ gllr HEAD...MERGE_HEAD
alias gllr="git log --oneline --graph --left-right --boundary --decorate"

# List authors by number of commits, with their email
alias glistauthors="git shortlog -nse"
# List remote branches by last commit date, with its author
alias glistb="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"

# Show every commit by an author, with its diff
# $ gitlistcommits nadell
function gitlistcommits() {
   git log --author="$1" --format=%H | xargs git show
}

# One line per commit by an author: hash, author, age, subject
# $ listbyauthor nadell
function listbyauthor() {
   git log --author="$1" --pretty=format:"%h - %an, %ar : %s"
}

# Count commits on either side of HEAD...<rev> (in one but not both)
# $ gsince master
function gsince()  {
   git log HEAD...$^1 --oneline | wc -l
}

# ==================================================
# Working with remotes
# ==================================================

alias gp="git push"
alias gP='git push --set-upstream origin "$(git branch --show-current)"'
alias gpl="git pull"

# ==================================================
# Stashing
# ==================================================
alias gss="git stash"
alias gsS="git stash save --include-untracked"
alias gsp="git stash pop"

# Git stash interactive list
# Apply selected stash
function gsi() {
  local source_command="git stash list"
  local preview_command="echo {1} | awk -F: '{ print \$1 }' | xargs git --no-pager stash show"
  local selection=$($source_command | fzf +m --ansi --preview-window="right:70%:nohidden:nowrap" --preview "$preview_command")

  if [[ -n "$selection" ]]; then
    echo $selection | awk -F: '{ print $1 }' | xargs git stash apply
  fi
}


# ==================================================
# Misc
# ==================================================

# The "Panic Button"
function git-undo() {
    git reset --soft HEAD~1
}
