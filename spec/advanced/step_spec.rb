require 'spec_helper'
require 'advanced/step'

RSpec.describe Advanced::Step do
  def search_id(id:, something: nil)
  end

  let :step do
    described_class.from_method(method(:search_id))
  end

  it 'has a name' do
    expect(step.name).to eq(:search_id)
  end

  it 'has requires' do
    expect(step.requires).to eq([:id])
  end

  it 'has permits' do
    expect(step.permits).to eq([:something])
  end

  it 'has parameter_names' do
    expect(step.parameter_names).to match_array([:id, :something])
  end

  describe '#slice' do
    it 'omits undeclared' do
      result = step.slice(
        a: 1,
        b: 2,
        id: 1,
        something: 'foo'
      )

      expect(result).to eq(id: 1, something: 'foo')
    end

    it 'omits blank permits' do
      pending 'broken spec'
      expect(step.slice(id: 1, something: nil)).to eq(id: 1)
      expect(step.slice(id: 1, something: ' ')).to eq(id: 1)
      expect(step.slice(id: 1, something: [])).to eq(id: 1)
    end

    it 'is nil for undeclared required key' do
      pending 'broken spec'
      expect(step.slice(something: 1)).to be_nil
    end

    it 'is nil for blank required key' do
      pending 'broken spec'
      expect(step.slice(id: nil)).to be_nil
      expect(step.slice(id: '  ')).to be_nil
      expect(step.slice(id: [])).to be_nil
    end
  end
end
