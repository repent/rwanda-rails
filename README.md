# Rwanda::Rails

Add information about geographic location within Rwanda to models in the Rails framework, and update them through a web interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rwanda-rails'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rwanda-rails

## Usage

In the view (e.g. in `_form.html.erb` if you generated your model using `rails generate scaffold`):

```erb
<%= form_for(@person) %>
  <% loc = Location.new(@company.district, @company.sector, @company.cell, @company.village) %>
  <%# "force_edit: @force_edit" is necessary in order to be able to edit previously filled-in fields %>
  <%= f.rwanda_location(loc, { force_edit: @force_edit, autosubmit: true }) %>
<%= f.submit 'Update Location' %>
```

In the controller:

```ruby
# Can be in its own action instead of edit if you prefer
# However, you would then have to pass the action in to rwanda_location in the options hash
def edit
  @force_edit = params[:force_edit]
end

def update
  respond_to do |format|
    if @person.update(person_params)
      # by rendering edit instead of show, it is possible to quickly enter all levels
      # one after the other
      format.html { render :edit, notice: 'Person was successfully updated.' }
      format.json { render :edit, status: :ok, location: @person }
    else
      format.html { render :edit }
      format.json { render json: @person.errors, status: :unprocessable_entity }
    end
  end
end
```

The model to which you're adding a Rwandan location needs attributes `district`, `sector`, `cell` and `village`.

```
rails generate migration add_location_to_person district:string sector:string cell:string village:string
rake db:migrate
```

## Edit location in `edit` view, or create a separate view and action?

Entering a full Rwandan location (district, sector, cell and village) requires a page load at each step (CSV data covering all of Rwanda is around 0.75 MB -- a significant download, so instead only that which is needed is provided by the server).  To make this less clunky, `autosubmit: true` can be passed to speed up the process by submitting the form as soon as a district, sector, etc is chosen, reducing the number of clicks.  However, this requires that submission of the `_form` return the user to the `edit` view rather than, as is more traditional, a `show` view.  For these reasons, it might be preferable to use an "Edit Location" link in your edit view to go to a separate edit_location action and view.  Then the original `edit` action can behave as expected, i.e. when submitted it will update the record and forward the user to a `show`.  However, either way works.

## Example application

Take a look at a [minimal Rails application that uses this gem](https://github.com/repent/example-rwanda-rails).

## Status

[![Gem Version](https://badge.fury.io/rb/rwanda-rails.svg)](http://badge.fury.io/rb/rwanda-rails)

## Contributing

1. Fork it ( https://github.com/repent/rwanda-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
