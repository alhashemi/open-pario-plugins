require 'redmine'
require 'data_gathering'

Redmine::Plugin.register :redmine_dgath do
  name 'Redmine data-gathering plugin'
  author 'Yousef Alhashemi'
  description 'This plugin logs all HTTP requests and saves them for analysis later'
  version '0.0.1'
end
