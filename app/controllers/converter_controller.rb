# coding: utf-8
class ConverterController < ApplicationController
  def convert
    tmp_dir = Rails.root.join('tmp').to_s
    @caches = Dir["#{tmp_dir}/*.html"].map{ |f| File.basename f }
    url = params[:url]

    if url.nil?
      render :convert
    else
      file_name = "#{Rack::Utils.escape(url)}.html"
      file_path = Rails.root.join('tmp', file_name).to_s
      if not @caches.include? file_name
        require 'selenium-webdriver'

        if Rails.env.production?
          Selenium::WebDriver::Chrome.path = ENV["GOOGLE_CHROME_SHIM"]
        end
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('headless')
        options.add_argument('disable-gpu')
        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--no-sandbox")
        driver = Selenium::WebDriver.for :chrome, options: options

        driver.get url
        File.write(file_path, driver.page_source)
        driver.quit
      end
      render html: File.read(file_path).html_safe
    end
  end
end
