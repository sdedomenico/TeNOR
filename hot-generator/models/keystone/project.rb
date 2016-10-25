#
# TeNOR - HOT Generator
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
class Project < Resource

  # Initializes a Project object
  #
  # @param [String] resource_name the Project resource name
  # @param [String] name the name of the project
  # @param [String] domain the domian
  def initialize(resource_name, name, domain = nil)
    type = 'OS::Keystone::Project'
    domain.nil?  ? properties = {'name' => name, 'enabled' => true} : properties = {'name' => name, 'domain' => domain, 'enabled' => true}
    super(resource_name, type, properties)
  end
end
