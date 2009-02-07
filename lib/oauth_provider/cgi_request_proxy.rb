require 'oauth/request_proxy/base'
require 'cgi'

module OAuth::RequestProxy
  class CGIRequest < OAuth::RequestProxy::Base
	 proxies CGI
	 
	 def method
		request.request_method
	 end
	 
	 def uri
		'http://' + request.server_name + (request.server_port == 80 ? '' : ':' + request.server_port.to_s) + request.script_name # http is bad assumption
	 end

	 def parameters
		if options[:clobber_request]
		  options[:parameters] || {}
		else
		  params = request_params.merge(query_params).merge(header_params)
		  params.merge(options[:parameters] || {})
		end
	 end
	 
	 protected

	 def query_params
		{} # Part of request_params
	 end

	 def header_params
		{} # CGI scripts don't get headers
	 end

	 def request_params
		p = {}
		request.params.each { |k,v|
			p[k] = v[0].to_s
		}
		p
	 end
  end
end
