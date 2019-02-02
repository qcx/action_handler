# ActionHandler
[![CodeFactor](https://www.codefactor.io/repository/github/pedroseda/action_handler/badge)](https://www.codefactor.io/repository/github/pedroseda/action_handler)
[![Build Status](https://travis-ci.org/PedroSeda/action_handler.svg?branch=master)](https://travis-ci.org/PedroSeda/action_handler)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_handler', git: 'git://github.com/PedroSeda/action_handler.git', tag: 'v0.1.0'
```

And then execute:

    $ bundle

## Usage

```yml
# serverless.yml

functions:
  listItems:
    handler: app/handlers/items_handler.ItemsHandler.index
    events:
      - http:
          method: get
          path: items
  showItems:
    handler: app/handlers/items_handler.ItemsHandler.show
    events:
      - http:
          method: get
          path: items/{id}
  updateItems:
    handler: app/handlers/items_handler.ItemsHandler.update
    events:
      - http:
          method: put
          path: items/{id}
```

```ruby
# app/handlers/items_handler.rb

class ItemsHandler < ActionHandler::Base
  def index
    render json: Item.all
  end

  def show
    render json: Item.find(params[:id])
  end

  def update
    Item.find(params[:id]).update(params)
    render status: 204
  end
end
```

### Params
Parsed from the received `event`

#### Supports
- Http
- Lambda (InvokeFunction)
- SQS

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PedroSeda/action_handler. This project is intended to be a safe, welcoming space for collaboration.

## Roadmap

### Modules to parse different event inputs

```ruby
class ItemsHandler
  include ActionHandler::Params::HTTP # Maybe included as default
  include ActionHandler::Params::SQS

  def create
    Item.create(params)
  end
end
```

### Map status codes
```ruby
render status: :ok
render status: :no_content
```

### Use different Renderers for each content type
```ruby
render json: Item.all # should use Renderers::Json.new(args).render
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
