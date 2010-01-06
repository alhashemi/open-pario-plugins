require 'redmine'

require_dependency 'footer_hook.rb'
# require_dependency 'project_join_hook.rb'

Redmine::Plugin.register :redmine_community do
  name 'Redmine Community plugin'
  author 'Yousef Alhashemi'
  description 'This plugin allows registered users to create and join projects'
  version '0.0.1'

  settings :default => {'member_role_id' => '4'}, :partial => 'settings/community_settings'
  #permission :create_project, { :create_project
  #menu :top_menu, :community
end
