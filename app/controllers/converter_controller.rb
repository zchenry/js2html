# coding: utf-8
class ConverterController < ApplicationController
  def convert
    url = params[:url]

    if url.nil?
      @urls = Record.pluck(:url).uniq
      render :convert
    else
      html = helpers.url2html url, params[:get]
      suppress(Exception) { Record.create url: url }
      render html: html.html_safe
    end
  end
end
