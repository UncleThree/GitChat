require 'rest_client'
require 'yaml'

module Github
  class Base
    def self.api_url(point, token)
      #auth = token ? "#{username}%2Ftoken:#{token}@" : ""
      "https://github.com/api/v2/yaml#{point}?access_token=#{token}"
    end
  end
  class User
    def self.find(username)
      puts "Finding user: #{username}"
      #yaml = RestClient.get Github.api_uri("/user/show/#{username}", username, nil)
      yaml = RestClient.get "https://github.com/api/v2/yaml/user/show/#{username}"
      user = YAML.load(yaml)["user"]
      
      {
        :username => user["login"],
        :real_name => user["name"],
        :gravatar => user["gravatar_id"],
        :profile_link => "https://github.com/#{user["login"]}/"
      }
    end
  end
  
  class Repository
    def self.find_by_user(user, auth_user=nil, token=nil)
      puts Github::Base.api_url("/repos/show/#{user}", token)
      yaml = RestClient.get Github::Base.api_url("/repos/show/#{user}", token)
      repos = YAML.load(yaml)["repositories"]
      repos.collect do |repo|
        repo_hash = hash_for_repo repo
      end if repos
    end

    def self.network_for_repo(owner, name, token=nil)
      begin
        yaml = RestClient.get Github::Base.api_url("/repos/show/#{owner}/#{name}/network", token)
        network = YAML.load(yaml)["network"]
      rescue
        puts "failed on /repos/show/#{owner}/#{name}/network"
        network = []
      end
      #find the parent, which is the only one not a fork
      parent = network.find{|repo| !repo[:fork]}
      parent_string = "#{parent[:owner]}/#{parent[:name]}" if parent

      link = link_from_data(owner, name)
      
      network.collect{|fork| 
        hash_for_repo(fork, parent_string)
      }.reject{|fork| fork[:link] == link}
    end

    def self.collaborators_for_repo owner, name, token=nil
      begin
        url = "/repos/show/#{owner}/#{name}/collaborators"
        yaml = RestClient.get Github::Base.api_url(url, token)
        collabs = YAML.load(yaml)["network"]
      rescue
        puts "Failed to get collaborators for #{owner}/#{name}"
        collabs = []
      end
      collabsa
    end
    
    private
    def self.hash_for_repo repo, parent=nil
      {
        :link => repo[:url],
        :name => repo[:name],
        :description => repo[:description],
        :creator => repo[:owner],
        :parent_repo => parent,
        :private => repo[:private]
      }
    end

    def self.link_from_data owner, name
      "https://github.com/#{owner}/#{name}"
    end
  end
  
  class Issues
    def self.find_by_repository(repo, open=true, username=nil, token=nil)
      yaml = RestClient.get Github::Base.api_url("/issues/list/#{repo}/#{open ? "open" : "closed"}", token)
      issues = YAML.load(yaml)["issues"]
      issues.collect do |issue|
        {
          :creator => issue["user"],
          :title => issue["title"],
          :text => issue["body"],
          :github_id => issue["number"],
          :repo => "#{username}/#{repo}",
          :created_date => issue["created_at"],
          :closed_date => issue["closed_at"]
        }
      end
    end
    
    def self.comments_for_issue(repo, issue, username=nil, token=nil)
      yaml = RestClient.get Github::Base.api_url("/issues/comments/#{repo}/#{issue}", token)
      comments = YAML.load(yaml)["comments"]
      comments.collect do |comment|
        {
          :gravatar => comment["gravatar_id"],
          :created_at => comment["created_at"],
          :author => comment["user"],
          :text => comment["body"]
        }
      end
    end
  end
  
  class Commits
    def self.find_by_repository(repo, branch="master", username=nil, token=nil)
      yaml = RestClient.get Github::Base.api_url("/commits/list/#{repo}/#{branch}", token)
      commits = YAML.load(yaml)["commits"]
      commits.collect do |commit|
        {
          :hash => commit["id"],
          :repository => repo,
          :branch => branch,
          :time => commit["committed_date"],
          :commit_msg => commit["message"],
          :author => commit["committer"]["login"]
        }
      end
    end
  end
end
