require_dependency Rails.root.join('app', 'helpers', 'embed_videos_helper').to_s

module Custom::EmbedVideosHelper

  def embedded_investment_video_code(recommendation = nil)
    if !recommendation.nil?
      link = recommendation
    else
      link = @investment.video_url
    end
    if link.match(/vimeo.*/)
      server = "Vimeo"
    elsif link.match(/youtu*.*/)
      server = "YouTube"
    end

    if server == "Vimeo"
      reg_exp = /vimeo.*(staffpicks\/|channels\/|videos\/|video\/|\/)([^#\&\?]*).*/
      src =  "https://player.vimeo.com/video/"
    elsif server == "YouTube"
      reg_exp = /youtu.*(be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
      src = "https://www.youtube.com/embed/"
    end

    if reg_exp
      match = link.match(reg_exp)
    end

    if match and match[2]
      '<iframe src="' + src + match[2] + '" frameborder="0" allowfullscreen></iframe>'
    else
      ''
    end
  end

end