require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: true,
    model_class: AllMysqlType do
    context 'false' do
      let(:value) { false }
      it 'renders the boolean' do
        expect(rendered).to eq 'false'
      end
    end
  end
end
