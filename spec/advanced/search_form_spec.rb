require 'spec_helper'
require 'advanced/search'
require 'advanced/search_form'

class DummySearch < Advanced::Search
  def search_id(id:)
  end
end

class DummySearchForm < Advanced::SearchForm
  include DummySearch.form
end

RSpec.describe Advanced::SearchForm do
  describe '.parameter_names' do
    it 'adds the parameter names' do
      expect(DummySearchForm.parameter_names).to match_array([:id])
    end
  end

  describe '#to_h' do
    it 'builds a hash' do
      form = DummySearchForm.new
      form.id = 1
      expect(form.to_h).to eq(id: 1)
    end
  end

  it 'defines the parameters' do
    form = DummySearchForm.new
    form.id = 1
    expect(form.id).to eq(1)
  end
end
