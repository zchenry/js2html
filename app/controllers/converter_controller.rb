class ConverterController < ApplicationController
  def convert
    tmp_dir = Rails.root.join('tmp').to_s
    @caches = Dir["#{tmp_dir}/*.html"]

    url = params[:url]
    if url.nil?
      render :convert
    else
      file_name = "#{Rack::Utils.escape(url)}.html"
      if @caches.include? file_name
        render html: File.read(Rails.root.join('tmp', file_name).to_s).html_safe
      else
        render :nil
      end
    end
  end
end
