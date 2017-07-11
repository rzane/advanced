require 'spec_helper'

class SearchOne < Advanced::Search
  def search_add(add:, **)
    map { |v| v + add }
  end
end

class SearchTwo < Advanced::Search
  use SearchOne

  def then_double(**)
    map { |v| v * 2 }
  end
end

RSpec.describe Advanced::Search do
  let :data do
    [1, 2, 3]
  end

  let :one do
    SearchOne.new(data)
  end

  let :two do
    SearchTwo.new(data)
  end

  it 'runs based on matching params' do
    expect(one.call(add: 1)).to eq([2, 3, 4])
  end

  it 'does nothing if params dont match' do
    expect(one.call(bogus: 2)).to eq([1, 2, 3])
  end

  it 'does not change the original scope' do
    one.call(add: 1)
    expect(one.scope).to eq(one.scope)
  end

  it 'is composable' do
    expect(two.call(add: 1)).to eq([3, 5, 7])
  end
end
