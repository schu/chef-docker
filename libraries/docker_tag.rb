class Chef
  class Resource
    class DockerTag < ChefCompat::Resource
      use_automatic_resource_name

      property :target_repo, String, name_property: true
      property :target_tag, String
      property :to_repo, String
      property :to_tag, String

      #########
      # Actions
      #########

      action :tag do
        next if Docker::Image.exist?("#{to_repo}:#{to_tag}")
        begin
          i = Docker::Image.get("#{target_repo}:#{target_tag}")
          i.tag('repo' => to_repo, 'tag' => to_tag, 'force' => true)
        rescue Docker::Error => e
          raise e.message
        end
        updated_by_last_action(true)
      end
    end
  end
end
