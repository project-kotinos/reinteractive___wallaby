require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_servicer && .application_servicer' do
    it 'returns nil' do
      expect(described_class.model_servicer).to be_nil
      expect(described_class.application_servicer).to be_nil
    end

    context 'subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(Wallaby::ResourcesController) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_servicer) { stub_const 'ApplicationServicer', Class.new(Wallaby::ModelServicer) }
      let!(:another_servicer) { stub_const 'AnotherServicer', Class.new(Wallaby::ModelServicer) }
      let!(:apple_servicer) { stub_const 'AppleServicer', Class.new(application_servicer) }
      let!(:thing_servicer) { stub_const 'ThingServicer', Class.new(apple_servicer) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'is nil' do
        expect(subclass1.model_servicer).to be_nil
        expect(subclass1.application_servicer).to be_nil
        expect(subclass2.model_servicer).to be_nil
        expect(subclass2.application_servicer).to be_nil
      end

      it 'returns servicer classes' do
        subclass1.model_servicer = apple_servicer
        expect(subclass1.model_servicer).to eq apple_servicer
        expect(subclass2.model_servicer).to be_nil

        subclass1.application_servicer = application_servicer
        expect(subclass1.application_servicer).to eq application_servicer
        expect(subclass2.application_servicer).to eq application_servicer

        expect { subclass1.application_servicer = another_servicer }.to raise_error ArgumentError, 'AppleServicer does not inherit from AnotherServicer.'
      end
    end
  end

  describe '#current_servicer' do
    let!(:servicer) { stub_const 'AllPostgresTypeServicer', Class.new(Wallaby::ModelServicer) }

    it 'returns model servicer for existing resource servicer' do
      controller.params[:resources] = 'all_postgres_types'
      expect(controller.current_servicer).to be_a AllPostgresTypeServicer
    end

    it 'returns model servicer for non-existing resource servicer' do
      controller.params[:resources] = 'orders'
      expect(controller.current_servicer).to be_a Wallaby::ModelServicer
    end
  end
end
