require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: '#000000',
    skip_general: true do
    it 'renders the color' do
      expect(rendered).to include "background-color: #{value};"
      expect(rendered).to include "<span class=\"text-uppercase\">#{value}</span>"
    end
  end
end
