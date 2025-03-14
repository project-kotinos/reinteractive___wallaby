require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: IPAddr.new('192.168.2.0/24'),
    skip_general: true do
    it 'renders the cidr' do
      expect(rendered).to include "<code>#{value}</code>"
      expect(rendered).to include "http://ip-api.com/##{value}"
    end
  end
end
