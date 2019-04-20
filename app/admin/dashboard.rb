# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ 'Hotelzz Dashboard' } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span 'Welcome to Hotelzz Dashboard'
        br
        span 'This dashboard is meant just as an informative (not operative, '\
             'it is not configured for it) way to check status of current database records'
        br
        span 'Could be a solution for a possible Hotelzz App Customer Service'
      end
    end
  end
end
