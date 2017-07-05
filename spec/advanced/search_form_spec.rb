require 'spec_helper'
require 'advanced/search'
require 'advanced/search_form'

class DummySearch < Advanced::Search
  def search_id(id:)
  end

  class Form < Advanced::SearchForm
    search DummySearch
  end
end

class NestedDummySearch < Advanced::Search
  def search_dummy(dummy:)
  end

  class Form < Advanced::SearchForm
    search NestedDummySearch
    nested :dummy, DummySearch::Form
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

  describe 'nesting' do
    it 'has a reader' do
      form = NestedDummySearch::Form.new
      expect(form.dummy).to be_a(DummySearch::Form)
    end

    it 'has a writer' do
      form = NestedDummySearch::Form.new
      form.dummy = { id: 1 }
      expect(form.dummy.id).to eq(1)
    end

    it 'writes on initialize' do
      form = NestedDummySearch::Form.new(
        dummy: { id: 1 }
      )

      expect(form.dummy.id).to eq(1)
    end

    it 'deeply converts the whole form to_h' do
      form = NestedDummySearch::Form.new(
        'dummy' => { 'id' => 1 }
      )

      expect(form.to_h).to eq(dummy: { id: 1 })
    end
  end
end
