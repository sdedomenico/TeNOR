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
require_relative 'spec_helper'

RSpec.describe NsProvisioning do
    def app
        Provisioner
    end

    before do
        begin
            DatabaseCleaner.start
        ensure
            DatabaseCleaner.clean
        end
    end

    describe 'GET /ns-instances' do
        let(:response) { get '/' }

        it 'responds with a 200' do
            expect(response.status).to eq 200
        end

        it 'responds with an Array' do
            expect(JSON.parse(response.body)).to be_an Array
        end

        it 'each array item should be a Hash (Interface description)' do
            expect(JSON.parse(response.body)).to all be_a Hash
        end
    end

    describe 'POST /ns-instances' do
        context 'given an invalid content type' do
            it 'responds with a 415' do
                post '/', {}.to_json, 'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
                expect(last_response.status).to eq 415
            end
        end
        context 'given a valid request' do
            it 'provisions a new VNF in the VIM' do
                response = post '/', File.read(File.expand_path('../fixtures/instantiation_info.json', __FILE__)), 'CONTENT_TYPE' => 'application/json'
                expect(last_response.status).to eq 201
            end
        end
    end

    describe 'GET /ns-instances' do
        context 'when there are no VNF instances' do
            let(:response) { get '/' }

            it 'returns an array' do
                expect(JSON.parse(response.body)).to be_an Array
            end

            it 'returned array should be empty' do
                expect(JSON.parse(response.body)).to be_empty
            end

            it 'responds with a 200' do
                expect(response.status).to eq 200
            end
        end

        context 'when there are one or more VNF instances' do
            before { create(:nsr) }
            let(:response) { get '/' }

            it 'does not return an empty body' do
                expect(JSON.parse(response.body)).to_not be_empty
            end

            it 'returns an array' do
                expect(JSON.parse(response.body)).to be_an Array
            end

            it 'each array item should be a Hash (VNF)' do
                expect(JSON.parse(response.body)).to all be_a Hash
            end

            it 'responds with a 200' do
                expect(response.status).to eq 200
            end
        end
    end

    describe 'GET /ns-instances' do
        let(:nsr) { create :nsr }

        context 'when the nsr is not found' do
            let(:response_not_found) { get '/' + (nsr._id.to_i + 1).to_s }

            it 'responds with an empty body' do
                expect(response_not_found.body).to be_empty
            end

            it 'responds with 404' do
                expect(response_not_found.status).to eq 404
            end
        end

        context 'when the VNF is found' do
            let(:response_found) { get '/' + nsr._id.to_s }

            it 'response body should not be empty' do
                expect(JSON(response_found.body)).to_not be_empty
            end

            it 'response body should contain a Hash (VNF)' do
                expect(JSON.parse(response_found.body)).to be_a Hash
            end

            it 'responds with a 200' do
                expect(response_found.status).to eq 200
            end
        end
    end

    describe 'POST /ns-instances' do
        context 'given an invalid content type' do
            it 'responds with a 415' do
                post '/', {}.to_json, 'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
                expect(last_response.status).to eq 415
            end
        end
        context 'given a valid request' do
            it 'provisions a new VNF in the VIM' do
                response = post '/', File.read(File.expand_path('../fixtures/instantiation_info.json', __FILE__)), 'CONTENT_TYPE' => 'application/json'
                expect(last_response.status).to eq 201
            end
        end
    end

    describe 'DELETE /ns-instances' do
		let(:nsr) { create :nsr }

		context 'when the VNF instance is not found' do
            let(:response_not_found) { put '/' + (nsr._id.to_i + 1).to_s + '/terminate', {}.to_json, 'CONTENT_TYPE' => 'application/json'}

			it 'responds with an empty body' do
				expect(response_not_found.body).to be_empty
			end

			it 'responds with a 404' do
				expect(response_not_found.status).to eq 404
			end
		end

		context 'when the nsr is found' do
            let(:response_found) { put '/' + nsr._id.to_s + '/terminate', File.read(File.expand_path('../fixtures/destroy_info.json', __FILE__)), 'CONTENT_TYPE' => 'application/json'}

			it 'responds with an empty body' do
				expect(response_found.body).to be_empty
			end

			it 'responds with a 200' do
				expect(response_found.status).to eq 200
			end
		end

	end
end
