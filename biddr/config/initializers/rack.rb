require 'rack/utils'

Rack::Utils.module_eval do
  def self.set_cookie_header!(header, key, value)
    case value
    when Hash
      domain  = "; domain="  + value[:domain] if value[:domain]
      path    = "; path="    + value[:path]   if value[:path]
      max_age = "; max-age=" + value[:max_age] if value[:max_age]
      expires = "; expires=" +
        rfc2822(value[:expires].clone.gmtime) if value[:expires]
      secure = "; secure"  if value[:secure]
      httponly = "; HttpOnly" if value[:httponly]
      same_site = '; SameSite=None'
       
      value = value[:value]
    end
    value = [value] unless Array === value
    cookie = escape(key) + "=" +
      value.map { |v| escape v }.join("&") +
      "#{domain}#{path}#{max_age}#{expires}#{secure}#{httponly}#{same_site}"

    case header["Set-Cookie"]
    when nil, ''
      header["Set-Cookie"] = cookie
    when String
      header["Set-Cookie"] = [header["Set-Cookie"], cookie].join("\n")
    when Array
      header["Set-Cookie"] = (header["Set-Cookie"] + [cookie]).join("\n")
    end

    nil
  end
end