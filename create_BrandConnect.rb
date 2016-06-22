require "json"
require "selenium-webdriver"
require "rspec"
require "yaml"
include RSpec::Expectations

describe "CreteBrandConnect" do

  before(:each) do
	@config = YAML.load_file("config_smiley.yml")
    @driver = Selenium::WebDriver.for :firefox
    @base_url = @config['admin']['base_url']
	@base_member_url = @config['member']['base_url']
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    #@driver.quit
    @verification_errors.should == []
  end
  
  it "test_crete_brand_connect" do
    @driver.get(@config['member']['base_url']	+ "/home")
	#login
    @driver.find_element(:id, "member_email").clear
    @driver.find_element(:id, "member_email").send_keys @config['admin']['email']
    @driver.find_element(:id, "member_password").clear
    @driver.find_element(:id, "member_password").send_keys @config['admin']['pass']
    @driver.find_element(:name, "commit").click
	sleep(5)
	@driver.manage.window.maximize
	sleep(2)
	
	#Create topic
    @driver.find_element(:link, "Brand Connect").click
    @driver.find_element(:link, "Create Topic").click
	sleep(2)
	@driver.execute_script('$(\'input[type="file"]\').attr("style", "");');
	sleep(1)
	@driver.find_element(:css, "input[type='file']").send_keys("C:\\Users\\Tripthi\\Pictures\\Brandconnect.jpe")
	sleep(5)
	
    @driver.find_element(:id, "topic_title").clear
    @driver.find_element(:id, "topic_title").send_keys "Title lengthy Title Title"
	sleep(2)
    @driver.find_element(:id, "topic_title").clear
    @driver.find_element(:id, "topic_title").send_keys "Title lengthy Title lengthy Title lengthy Title lengthy Title lengthyTitle lengthy Title lengthy Title lengthy Title lengthy Title lengthy Title lengthy"
    sleep(2)
	@driver.find_element(:name, "commit").click
	
	#Create discussion
    @driver.find_element(:link, "Start the Discussion").click
	sleep(2)
    @driver.find_element(:id, "discussion_title").clear
    @driver.find_element(:id, "discussion_title").send_keys "Discussion lengthy Discussion lengthyDiscussion lengthyDiscussion lengthy Discussion lengthyDiscussion lengthyDiscussion lengthyDiscussion lengthyDiscussion lengthy"
    sleep(2)
	@driver.find_element(:id, "discussion_first_comment_attributes_text").clear
    @driver.find_element(:id, "discussion_first_comment_attributes_text").send_keys "Message lengthy Message lengthyMessage lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy Message lengthy."
    sleep(2)
	@driver.find_element(:name, "commit").click
	
	#Comment as an admin
    @driver.find_element(:xpath, "//textarea").clear
    @driver.find_element(:xpath, "//textarea").send_keys "comment 1"
	sleep(2)
    @driver.find_element(:link, "Logout").click
    
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
