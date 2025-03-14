require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: Date.new(2014, 2, 11)..Date.new(2014, 2, 12),
    skip_general: true do
    it 'renders the daterange' do
      expect(rendered).to include '<span class="from">Feb 11</span>'
      expect(rendered).to include '<span class="to">Feb 12</span>'
      expect(rendered).to include 'title="2014-02-11 ... 2014-02-12"'
    end
  end
end
