require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.theme_name' do
    it 'returns nil' do
      expect(described_class.theme_name).to be_nil
    end

    context 'subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(Wallaby::ResourcesController) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }

      it 'inherits the configuration' do
        expect(subclass1.theme_name).to be_nil
        subclass1.theme_name = 'apple_theme'
        expect(subclass1.theme_name).to eq 'apple_theme'
        expect(subclass2.theme_name).to eq 'apple_theme'
      end
    end
  end

  describe '#current_theme_name' do
    it 'returns theme name' do
      expect(controller.current_theme_name).to be_nil
    end

    context 'when theme name is set' do
      it 'returns theme name' do
        controller.class.theme_name = 'something'
        expect(controller.current_theme_name).to eq 'something'
        controller.class.theme_name = nil
      end
    end
  end
end
