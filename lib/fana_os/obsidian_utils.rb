require 'git'

module FanaOs
  class ObsidianUtils
    def self.push_git 
      git = Git.open(OBSIDIAN_ROOT)
      git.add(all: true)
      git.commit_all("Stash Obsidian on #{DateTime.current}")
      git.push
    end
  end
end