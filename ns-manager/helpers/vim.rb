#
# TeNOR - NS Manager
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
# @see TnovaManager
module VimHelper

  def authentication_v2(pop_info, extrainfo)

        auth = { auth: { tenantName: extrainfo[:tenantname], passwordCredentials: { username: pop_info['adminid'], password: pop_info['password'] } } }
        begin
            response = RestClient.post extrainfo[:keystone] + '/tokens', auth.to_json, content_type: :json
        rescue Errno::ECONNREFUSED => e
            return 500, 'Connection refused'
        rescue RestClient::ExceptionWithResponse => e
            logger.error e
            logger.error e.response.body
            return e.response.code, e.response.body
        rescue => e
            logger.error e
            logger.error e.response.body
            return 400, errors if errors
        end
        return parse_json(response)
  end

  def authentication_v3(pop_info, extrainfo)

    auth = {
      auth: {
        identity: {
          methods: ['password'],
          password: {
            user:{
              name: pop_info['adminid'],
              domain: { "name": extrainfo[:tenantname] },
              password: pop_info['password']
            }
          }
        }
      }
    }
    begin
        response = RestClient.post extrainfo[:keystone] + '/auth/tokens', auth.to_json, content_type: :json
    rescue Errno::ECONNREFUSED => e
        return 500, 'Connection refused'
    rescue RestClient::ExceptionWithResponse => e
        logger.error e
        logger.error e.response.body
        return e.response.code, e.response.body
    rescue => e
        logger.error e
        logger.error e.response.body
        return 400, errors if errors
    end
    return parse_json(response)
  end

end
