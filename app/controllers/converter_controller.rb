# coding: utf-8
class ConverterController < ApplicationController
  def convert
    url = params[:url]

    if url.nil?
      @records = Record.all
      render :convert
    else
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
      html_contents = driver.page_source
      driver.quit

      suppress(Exception) { Record.create url: url }
      render html: html_contents.html_safe
    end
  end
end
