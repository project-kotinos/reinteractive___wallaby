require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/has_one.html.erb' }
  let(:value)     { Product.new id: 1, name: 'Hiking shoes' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the has_one' do
    expect(rendered).to eq "<a href=\"/admin/products/1\">Hiking shoes</a>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
