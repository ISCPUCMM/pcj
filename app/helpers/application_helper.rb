module ApplicationHelper
  def gravatar_url(email, size=64)
    gravatar = Digest::MD5::hexdigest(email).downcase
    "https://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=wavatar"
  end
end
