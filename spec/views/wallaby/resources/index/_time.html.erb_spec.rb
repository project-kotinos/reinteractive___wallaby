require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/time.html.erb' }
  let(:value)     { Time.new(2014, 2, 11, 23, 59, 59, '+00:00') }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the time' do
    expect(rendered).to eq "  23:59:59\n"
  end

  context 'when value is a string' do
    let(:value) { "Tue, 11 Feb 2014 23:59:59 +0000" }

    it 'renders the time' do
      expect(rendered).to eq "  23:59:59\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
