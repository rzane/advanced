# Advanced

Advanced is a library for building complex searches with Active Record.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'advanced'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install advanced

## Usage

### Advanced::Search

Start by inheriting Advanced::Search.

```ruby
class StateSearch < Advanced::Search
  def search_name(name:, **)
    where('states.name like ?', "%#{name}%")
  end
end
```

`Advanced::Search` will look at the methods you've defined that start with `search_`. Above, we've declared the `search_name` method and listed the `name` parameter as a required key.

```ruby
StateSearch.call(State.all, name: 'New')
#=> SELECT * FROM states WHERE states.name like '%New%'

StateSearch.call(State.all, foo: 'bar')
#=> SELECT * FROM states

StateSearch.call(State.all, name: '')
#=> SELECT * FROM states
```

### Search composition

We can compose multiple search objects.

```ruby
class CitySearch < Advanced::Search
  def search_name(name:, **)
    where('cities.name like ?', "%#{name}%")
  end

  def search_state(state:, **)
    joins(:state).merge StateSearch.call(State.all, state)
  end
end
```

```ruby
CitySearch.call(City.all, name: 'New York')
#=> SELECT  "cities".* FROM "cities" WHERE (cities.name like '%New York%')

CitySearch.call(City.all, state: { name: 'New York' })
#=> SELECT  "cities".* FROM "cities"
#=> INNER JOIN "states" ON "states"."id" = "cities"."state_id"
#=> WHERE (states.name like '%New York%')
```

### Advanced::SearchForm

A common feature in Rails applications is building filters. `Advanced::SearchForm` can help you do that. It's basically just a hash that is compatible with Rails form builders.

```ruby
class StateSearch < Advanced::Search
  # ...

  class Form < Advanced::SearchForm
    search StateSearch
  end
end
```

It scans the keyword arguments in your search methods and defines accessors automatically:

```ruby
form = StateSearch::Form.new(name: 'Foo')
form.name #=> 'Foo'
form.name = 'Bar'
form.name #=> 'Bar'
form.to_h #=> { name: 'Foo' }
```

`Advanced::Search` treats this object like a hash, so you can just pass it along:

```ruby
StateSearch.call(State.all, form)
```

So, a controller action might look like this:

```ruby
def index
  @form   = StateSearch::Form.new(params[:q])
  @states = StateSearch.call(State.all, @form)
end
```

Your view might look something like this:

```
<%= form_for @form, method: :get, url: states_path, as: :q do |f| %>
  <p>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </p>

  <%= f.submit 'Search' %>
<% end %>

<table>
  <thead>
    <tr>
      <th>Name</th>
    </tr>
  </thead>

  <tbody>
    <% @states.each do |state| %>
      <tr>
        <td><%= state.name %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

### Composing forms

You can compose forms just like your compose your searches.

```ruby
class CitySearch < Advanced::Search
  # ...
  class Form < Advanced::SearchForm
    search CitySearch
    nested :state, StateSearch::Form
  end
end
```

```ruby
form = CitySearch::Form.new(name: 'New York', state: { name: 'New York' })
form.name #=> 'New York'
form.state.name #=> 'New York'
form.to_h #=> { name: 'New York', state: { name: 'New York' }}
```

# Other goodies

You can extend your models with a search method to keep it brief.

```ruby
class State < ApplicationRecord
  extend StateSearch.scope
end
```

Now, you have a shorthand:

```ruby
State.search(name: 'New York')
```

If you'd prefer to call your search method something other than `search`, that's cool too:

```ruby
extend StateSearch.scope(:custom_search)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ray Zane/advanced.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

