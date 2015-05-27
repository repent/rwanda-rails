#class Rwanda
class Location
  def to_html
    to_h.inject([]) { |r, (k,v)| r << "<b>#{v}</b> #{k.to_s.capitalize}" if v }.join(', ').html_safe
  end
end
#end
