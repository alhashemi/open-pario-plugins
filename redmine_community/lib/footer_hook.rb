class FooterHook < Redmine::Hook::ViewListener
  def view_layouts_base_body_bottom(context = {})
    return "<div align=\"center\" style=\"background-color:#eee; font-family:'Lucida Grande', verdana, arial, helvetica, sans-serif; border: 0px; color: #aaa; font-size: smaller;\">Sponsored by NSF under projects <a href=\"http://www.nsf.gov/awardsearch/showAward.do?AwardNumber=0742677\">CMMI 0742677</a> &amp; <a href=\"http://www.nsf.gov/awardsearch/showAward.do?AwardNumber=0742698\">CBET 0742698</a><br/><a href=\"http://www.nsf.gov/\"><img src=\"/images/nsf1.gif\" style=\"margin: 3px;\"/></a><a href=\"http://www.orst.edu/\"><img src=\"/images/Oregon_State_University_logo.png\" style=\"margin: 3px;\"/></a></div>"
  end
end