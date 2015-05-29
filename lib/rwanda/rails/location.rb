#class Rwanda
class Location
  def to_html
    if present?
      to_h.inject([]) { |r, (k,v)| r << "<b>#{v}</b> #{k.to_s.capitalize}" if v; r }.join(', ').html_safe
    else
      'Unknown'.html_safe
    end
  end
end
#end
