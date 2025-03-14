require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: '010111',
    model_class: AllMysqlType,
    skip_general: true do
    it 'renders the longblob' do
      expect(rendered).to include view.muted('longblob')
    end
  end
end
