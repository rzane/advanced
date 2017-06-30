require 'spec_helper'
require 'advanced/search'
require 'advanced/search_form'

class DummySearch < Advanced::Search
  def search_id(id:)
  end

  class Form < Advanced::SearchForm
    include DummySearch.form
  end
end

RSpec.describe Advanced::SearchForm do
  describe '.attribute_names' do
    it 'adds the attribute names' do
      expect(DummySearch::Form.attribute_names).to match_array([:id])
    end
  end

  describe '#to_h' do
    it 'builds a hash' do
      form = DummySearch::Form.new
      form.id = 1
      expect(form.to_h).to eq(id: 1)
    end
  end

  it 'defines the attributes' do
    form = DummySearch::Form.new
    form.id = 1
    expect(form.id).to eq(1)
  end
end
