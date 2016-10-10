require 'rails_helper'

feature 'weixin view' do

  before do
    Capybara.register_driver :rack_test do |app|
      Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'MicroMessenger' })
    end
  end

  scenario 'home page' do
    switch_to_subdomain('weixin')
    visit weixin_root_path
    within 'h1' do
      expect(page).to have_content '示例站点服务'
    end
    expect(page).to have_css("li.nm_btn.active", text: "示例站点服务")
  end

  scenario 'footer link', js: true do
    switch_to_subdomain('weixin')
    visit weixin_root_path
    Capybara.current_driver = Capybara.javascript_driver
    find("li:nth-child(2)").click
    expect(page).to have_content "查找"
    save_and_open_page
  end
end
