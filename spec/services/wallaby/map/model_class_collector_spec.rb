require 'rails_helper'

describe Wallaby::Map::ModelClassCollector do
  describe '#collect' do
    let(:configuration) { Wallaby::Configuration.new }
    let(:all_models) { [AllPostgresType, AllMysqlType, AllSqliteType] }
    subject { described_class.new(configuration, all_models).collect }

    it 'returns all models' do
      expect(subject).to eq [AllPostgresType, AllMysqlType, AllSqliteType]
    end

    context 'there are excludes' do
      before do
        configuration.models.exclude AllPostgresType
      end

      it 'excludes AllPostgresType' do
        expect(subject).to eq [AllMysqlType, AllSqliteType]
      end

      context 'models are set' do
        before do
          configuration.models.set AllSqliteType
        end

        it 'returns the models being set' do
          expect(subject).to eq [AllSqliteType]
        end

        context 'some of the models being set are invalid' do
          before do
            configuration.models.set Wallaby, AllSqliteType
          end

          it 'raises error' do
            expect { subject }.to raise_error Wallaby::InvalidError
          end
        end
      end
    end

    context 'models are set' do
      before do
        configuration.models.set AllSqliteType
      end

      it 'returns the models being set' do
        expect(subject).to eq [AllSqliteType]
      end

      context 'some of the models being set are invalid' do
        before do
          configuration.models.set Wallaby, AllSqliteType
        end

        it 'raises error' do
          expect { subject }.to raise_error Wallaby::InvalidError
        end
      end

      context 'there are excludes' do
        before do
          configuration.models.exclude AllPostgresType
        end

        it 'still returns the models being set' do
          expect(subject).to eq [AllSqliteType]
        end
      end
    end
  end
end
