require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: '<b>1234567890123</b>',
    max_length: 20,
    max_value: "<b>this's a text for more than 20 characters</b>",
    max_title: true
end
