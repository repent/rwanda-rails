# Rwanda::Rails

Access information about geographic divisions in Rwanda from within the Rails framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rwanda-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rwanda-rails

## Usage

In the view:

```erb
<%= form_for(@person) %>
  <%# "force_edit: @force_edit" is necessary in order to be able to edit previously filled-in fields %>
  <%= f.rwanda_location(loc, { force_edit: @force_edit, autosubmit: true }) %>
<%= f.submit 'Update Location' %>
```

In the controller:

```ruby
# Can be in its own action instead of edit if you prefer
def edit
  @force_edit = params[:force_edit]
end
```

The model to which you're adding a Rwandan location needs attributes `district`, `sector`, `cell` and `village`.

```
rails generate migration add_location_to_person district:string sector:string cell:string village:string
```

## Contributing

1. Fork it ( https://github.com/repent/rwanda-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
