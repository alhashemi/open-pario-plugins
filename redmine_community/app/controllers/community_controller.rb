class CommunityController < ApplicationController
  unloadable # fix crazy rails error

  layout 'base'
  helper :custom_fields
  include CustomFieldsHelper
  helper :queries
  include QueriesHelper
  include ProjectsHelper
  # before_filter :find_project
  before_filter :get_settings

  def join
    if params[:project_id].nil?
      flash[:error_msg] = "Please go to a project's page and follow the links."
      redirect_to :action => 'error'
    else
      change_role(Project.find(params[:project_id]), Role.find(@settings['member_role_id']))
    end
  end

  def create
    if User.current.logged?
      @issue_custom_fields = IssueCustomField.find(:all, :order => "#{CustomField.table_name}.position")
      @trackers = Tracker.all
      @root_projects = Project.find(:all,
                                    :conditions => "parent_id IS NULL AND status = #{Project::STATUS_ACTIVE}",
                                    :order => 'name')
      @project = Project.new(params[:project])
      @project.identifier = Project.next_identifier if Setting.sequential_project_identifiers?
      @project.trackers = Tracker.all
      @project.is_public = Setting.default_projects_public?
      @project.enabled_module_names = Redmine::AccessControl.available_project_modules
    else
      # not logged in, display error
      flash[:error_msg] = "You are not logged in."
      redirect_to :action => 'error'
    end
  end

  def add
    if User.current.logged?
      @issue_custom_fields = IssueCustomField.find(:all, :order => "#{CustomField.table_name}.position")
      @trackers = Tracker.all
      @project = Project.new(params[:project])
      @project.enabled_module_names = params[:enabled_modules]
      if @project.save
        @project.set_parent!(params[:project]['parent_id']) if params[:project].has_key?('parent_id')
        # Add current user as a project member if he is not admin
        # unless User.current.admin?
          r = Role.givable.find_by_id(Setting.new_project_user_role_id.to_i) || Role.givable.first
          m = Member.new(:user => User.current, :roles => [r])
          @project.members << m
        # end
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'projects', :action => 'settings', :id => @project
      else
	flash[:error_msg] = "Sorry, an error occured while trying to create your project. Have you filled in all required fields and used a unique identifier for your project?"
	redirect_to :action => 'create'
      end
    else
      flash[:error_msg] = "You are not logged in."
      redirect_to :action => 'error'
    end
  end

  def error
    # does nothing -- error.erb is used for displaying errors
  end

  private

  def get_settings
    @settings = Setting.plugin_redmine_community
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def change_role(project, role)
    if User.current.logged?
      member = Member.find_by_user_id_and_project_id(User.current.id, project.id)
      if !member.nil?
         flash[:error_msg] = "Sorry, it seems like you are already a member of this project!"
         redirect_to :action => 'error' and return
      end
      member = Member.find_or_initialize_by_user_id_and_project_id(User.current.id, project.id)
      # member.role = role
      member.roles << role
      member.project = project
      if member.save
        # Successfully saved
        redirect_to :controller => 'projects', :action => 'show', :id => params[:project_id]
      else
        # Had an error saving. Should inform the user and recover.
        flash[:error_msg] = "Sorry, we are having temporary problems with our database and we couldn't add you as a member to this project. Please try again later. If the problem persists, contact an administrator."
        redirect_to :action => 'error'
      end
    else
        flash[:error_msg] = "You are not logged in."
        redirect_to :action => 'error'
    end
  end

end
