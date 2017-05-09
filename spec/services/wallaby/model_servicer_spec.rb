require 'rails_helper'

describe Wallaby::ModelServicer, clear: :object_space do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end

      describe 'subclasses' do
        it 'returns a default model class' do
          stub_const 'JacketServicer', Class.new(Wallaby::ModelServicer)
          stub_const 'Jacket', Class.new
          expect(JacketServicer.model_class).to eq Jacket
        end

        context 'when model class is not found' do
          it 'raises not found' do
            stub_const 'NotFoundServicer', Class.new(Wallaby::ModelServicer)
            expect { NotFoundServicer.model_class }.to raise_error \
              Wallaby::ModelNotFound, 'NotFound from NotFoundServicer'
          end
        end
      end
    end
  end

  describe 'instance methods' do
    subject { described_class.new AllPostgresType }
    let(:handler) { subject.instance_variable_get '@handler' }
    let(:params) { parameters }
    let(:ability) { Ability.new nil }
    let(:resource) { AllPostgresType.new }

    it 'has model_class and model_decorator' do
      expect(subject.instance_variable_get('@model_class')).to \
        eq AllPostgresType
    end

    describe '#collection' do
      it 'returns collection' do
        record = AllPostgresType.create
        expect(subject.collection(params, ability)).to contain_exactly record
      end

      it 'deletgates collection method to handler' do
        expect(handler).to receive(:collection).with params, ability
        subject.collection params, ability
      end
    end

    describe '#new' do
      it 'returns new object' do
        new_record = subject.new(params)
        expect(new_record).to be_a AllPostgresType
        expect(new_record.persisted?).to be_falsy
      end

      it 'deletgates new method to handler' do
        expect(handler).to receive(:new).with params
        subject.new params
      end
    end

    describe '#find' do
      it 'returns the target' do
        record = AllPostgresType.create
        expect(subject.find(record.id, params)).to eq record
      end

      it 'deletgates find method to handler' do
        expect(handler).to receive(:find).with 1, params
        subject.find 1, params
      end
    end

    describe '#create' do
      it 'creates a record' do
        params[:all_postgres_type] = { string: 'today' }
        record, success = subject.create params, ability
        expect(success).to be_truthy
        expect(record).to be_a AllPostgresType
        expect(record.string).to eq 'today'
      end

      it 'deletgates create method to handler' do
        expect(handler).to receive(:create).with params, ability
        subject.create params, ability
      end
    end

    describe '#update' do
      it 'updates a record' do
        params[:all_postgres_type] = { string: 'tomorrow' }
        record = AllPostgresType.create string: 'today'
        _, success = subject.update record, params, ability
        expect(success).to be_truthy
        expect(record.reload.string).to eq 'tomorrow'
      end

      it 'deletgates update method to handler' do
        expect(handler).to receive(:update).with resource, params, ability
        subject.update resource, params, ability
      end
    end

    describe '#destroy' do
      it 'removes record' do
        record = AllPostgresType.create
        expect { subject.destroy record, params }.to change { AllPostgresType.count }.from(1).to(0)
      end

      it 'deletgates destroy method to handler' do
        expect(handler).to receive(:destroy).with resource, params
        subject.destroy resource, params
      end
    end
  end
end
