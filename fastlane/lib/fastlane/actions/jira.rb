module Fastlane
  module Actions
    class JiraAction < Action

      def self.run(params)
        require 'jira'

        site         = params[:url]
        context_path = ""
        auth_type    = :basic
        username     = params[:username]
        password     = params[:password]
        ticketID     = params[:ticketID]
        commentText  = params[:commentText]

        options = { :site         => site,
                    :context_path => context_path,
                    :auth_type    => auth_type,
                    :username     => username,
                    :password     => password }

        client = JIRA::Client.new(options)
        issue = client.Issue.find(ticketID)
        comment = issue.comments.build
        comment.save({ 'body' => commentText })

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Leave a comment on JIRA tickets."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                      env_name: "FL_JIRA_SITE", # The name of the environment variable
                                      description: "URL for Jira instance", # a short description of this parameter
                                       verify_block: proc do |value|
                                         raise "No url for Jira given, pass using `url: 'url'`".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_JIRA_USERNAME", # The name of the environment variable
                                       description: "Username for JIRA instance", # a short description of this parameter
                                       verify_block: proc do |value|
                                         raise "No username".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_JIRA_PASSWORD", # The name of the environment variable
                                       description: "Password for Jira", # a short description of this parameter
                                       verify_block: proc do |value|
                                         raise "No password".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :ticketID,
                                       env_name: "FL_JIRA_TICKET_ID", # The name of the environment variable
                                       description: "Ticket ID for Jira, i.e. IOS-123", # a short description of this parameter
                                       verify_block: proc do |value|
                                         raise "No Ticket specified".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :commentText,
                                       env_name: "FL_JIRA_COMMENT_TEXT", # The name of the environment variable
                                       description: "Text to addd to the ticket as a comment", # a short description of this parameter
                                       verify_block: proc do |value|
                                         raise "No comment specified".red unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.output
      end

      def self.return_value
      end

      def self.authors
        ["iAmChrisTruman"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
