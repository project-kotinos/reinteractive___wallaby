require 'rails_helper'

describe 'routing', type: :request do
  let(:mocked_response) { double 'Response', call: [ 200, {}, ["Coming soon"] ] }
  let(:script_name) { '/admin' }

  it 'routes to the general resourceful routes' do
    controller  = Wallaby::ResourcesController
    resources   = 'products'

    expect(controller).to receive(:action).with('index') { mocked_response }
    get "#{ script_name }/#{ resources }"

    expect(controller).to receive(:action).with('create') { mocked_response }
    post "#{ script_name }/#{ resources }"

    expect(controller).to receive(:action).with('new') { mocked_response }
    get "#{ script_name }/#{ resources }/new"

    expect(controller).to receive(:action).with('edit') { mocked_response }
    get "#{ script_name }/#{ resources }/1/edit"

    expect(controller).to receive(:action).with('show') { mocked_response }
    get "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('show') { mocked_response }
    get "#{ script_name }/#{ resources }/1-d"

    expect(controller).to receive(:action).with('update') { mocked_response }
    put "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('update') { mocked_response }
    patch "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('destroy') { mocked_response }
    delete "#{ script_name }/#{ resources }/1"

    expect(controller).to receive(:action).with('history') { mocked_response }
    get "#{ script_name }/#{ resources }/1/history"
  end

  context 'when target resources controller exists' do
    it 'routes to the general resourceful routes' do
      class Alien; end
      class AliensController < Wallaby::ResourcesController; def history; end; end
      controller  = AliensController
      resources   = 'aliens'

      expect(controller).to receive(:action).with('index') { mocked_response }
      get "#{ script_name }/#{ resources }"

      expect(controller).to receive(:action).with('create') { mocked_response }
      post "#{ script_name }/#{ resources }"

      expect(controller).to receive(:action).with('new') { mocked_response }
      get "#{ script_name }/#{ resources }/new"

      expect(controller).to receive(:action).with('edit') { mocked_response }
      get "#{ script_name }/#{ resources }/1/edit"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('show') { mocked_response }
      get "#{ script_name }/#{ resources }/1-d"

      expect(controller).to receive(:action).with('update') { mocked_response }
      put "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('update') { mocked_response }
      patch "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('destroy') { mocked_response }
      delete "#{ script_name }/#{ resources }/1"

      expect(controller).to receive(:action).with('history') { mocked_response }
      get "#{ script_name }/#{ resources }/1/history"

      expect(controller).to receive(:action).with('history') { mocked_response }
      get "#{ script_name }/#{ resources }/history"
    end
  end

  describe 'general routes' do
    it 'routes for general routes' do
      controller = Wallaby::CoreController

      expect(controller).to receive(:action).with('home') { mocked_response }
      get "#{ script_name }"

      expect(controller).to receive(:action).with('status') { mocked_response }
      get "#{ script_name }/status"
    end
  end

  describe 'resource route helper' do
    it 'has the following helpers' do
      %w( resources new_resource edit_resource resource member collection ).map do |route_name|
        "#{ route_name }_path"
      end.each do |path|
        expect(wallaby_engine).to respond_to path
      end
    end
  end
end
