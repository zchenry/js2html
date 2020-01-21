module ConverterHelper
  def url2html(url, get)
    require 'selenium-webdriver'

    if Rails.env.production?
      Selenium::WebDriver::Chrome.path = ENV['GOOGLE_CHROME_SHIM']
    end
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--no-sandbox')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get url

    if ['likes', 'retweets'].include? get
      sub_css = { 'likes' => 'favorited', 'retweets' => 'retweeted' }[get]
      css = "a.request-#{sub_css}-popup>strong"
      html = driver.find_element(:css, css).text
    else
      html = driver.page_source
    end
    driver.quit

    return html
  end
end
