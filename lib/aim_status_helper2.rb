# Extend Hash to parse options to html
class Hash
  def to_html_params
    o = ''
    self.each do |key,val|
      o += %Q[ #{key}="#{val}"]
    end
    o
  end
end

module AimStatusHelper2

  def aim_query(aim_name)
    xml = Net::HTTP.get URI.parse("http://api.oscar.aol.com/SOA/key=ma139BMQR7QIGQ7o/resource-lists/users/*anonymous*/presence/~~/resource-lists/list%5Bname=%22users%22%5D/entry%5B%40uri=%22user:#{aim_name}%22%5D")    
    xml.each_line do |l|
      if l.include? "<ep:activity>"
        @status = l
      elsif l.include? "<p:basic>"
        @status = l
      end
      @status = "wtf, the codes are borken" unless @status
    end
  end

  def aim_status(aim_name)
    case aim_query(aim_name)
    when /open/
      @status = "online"
    when /closed/
      @status = "offline"
    when /away/
      @status = "away"
    when /idle/
      @status = "idle"
    end
  end

  def aim_status_icon(aim_name, options = {})
    "<img src='status_#{aim_status(aim_name)}.png'#{options.to_html_params}/>"
  end

  def aim_to(object, aim_name, options = {})
    "<a href='aim:goim?screenname=#{aim_name}'#{options.to_html_params}>#{object}</a>"
  end

end