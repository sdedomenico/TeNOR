#
# TeNOR - NS Provisioning
#
# Copyright 2014-2016 i2CAT Foundation, Portugal Telecom Inovação
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @see OrchestratorNsProvisioner
class OrchestratorNsProvisioner < Sinatra::Application

  def getPopList()

    begin
      response = RestClient.get "#{settings.gatekeeper}/admin/dc/", 'X-Auth-Token' => settings.token, :content_type => :json
    rescue => e
      logger.error e
      if (defined?(e.response)).nil?
        error = {:info => "The PoP is not registered in Gatekeeper"}
        #marketplace URL here´
        #generateMarketplaceResponse()
        halt 503, "The PoP is not registered in Gatekeeper"
      end
    end
    popList, errors = parse_json(response.body)
    return 400, errors if errors

    return popList['dclist']
  end

  def getPopInfo(popId)
    popList = getPopList()
    popId = popList.index(popId)

    begin
      popInfo = RestClient.get "#{settings.gatekeeper}/admin/dc/#{pop_id}", 'X-Auth-Token' => settings.token, :content_type => :json
    rescue => e
      logger.error e
      if (defined?(e.response)).nil?
        error = {:info => "The PoP is not registered in Gatekeeper"}
        #marketplace URL here´
        #generateMarketplaceResponse()
        halt 503, "The PoP is not registered in Gatekeeper"
      end
    end
    halt e.response.code, e.response.body
  end

  def getPopUrls(extraInfo)
    urls = extraInfo.split(" ")

    popUrls = {}

    for item in urls
      key = item.split('=')[0]
      if key == 'keystone-endpoint'
        popUrls[:keystone] = item.split('=')[1]
      elsif key == 'neutron-endpoint'
        popUrls[:neutron] = item.split('=')[1]
      elsif key == 'compute-endpoint'
        popUrls[:compute] = item.split('=')[1]
      elsif key == 'orch-endpoint'
        popUrls[:orch] = item.split('=')[1]
      end
    end

    return popUrls

  end

end