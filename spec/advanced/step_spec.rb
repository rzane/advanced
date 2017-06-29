require 'spec_helper'
require 'advanced/step'

RSpec.describe Advanced::Step do
  subject :step do
    described_class.new(:search_foo, keys)
  end

  describe 'key' do
    let(:keys) { [[:key, :a]] }

    it 'extracts' do
      expect(step.slice(a: 1)).to eq(a: 1)
    end

    it 'permits nil' do
      expect(step.slice(a: nil)).to eq(a: nil)
    end

    it 'is okay when key is missing' do
      expect(step.slice(b: 1)).to eq({})
    end
  end

  describe 'keyreq' do
    let(:keys) { [[:keyreq, :a]] }

    it 'extracts' do
      expect(step.slice(a: 1)).to eq(a: 1)
    end

    it 'permits nil' do
      expect(step.slice(a: nil)).to eq(a: nil)
    end

    it 'is invalid when key is missing' do
      expect(step.slice(b: 1)).to eq(:invalid)
    end
  end

  describe 'keyrest' do
    let(:keys) { [[:keyreq, :a], [:keyrest, :foo]] }

    specify do
      is_expected.to be_all
    end

    it 'extracts' do
      expect(step.slice(a: 1, b: 1)).to eq(a: 1, b: 1)
    end

    it 'permits nil' do
      expect(step.slice(a: 1, b: nil)).to eq(a: 1, b: nil)
    end

    it 'is invalid when a keyreq is missing' do
      expect(step.slice(b: nil)).to eq(:invalid)
    end
  end

  describe 'none' do
    let(:keys) { [] }

    specify do
      is_expected.to be_none
    end

    it 'slices :none' do
      expect(step.slice(a: 1)).to eq(:none)
    end
  end
end
