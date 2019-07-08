# Helper Commands

### Get dependencies
```
mix deps.get
```

### Run server
```
mix phoenix.server
```

### Create migration
```
mix ecto.gen.migration migration-name
```

### Run migration
```
mix ecto.migrate
```

### Binding.pry
https://til.hashrocket.com/posts/3ab413d696-pry-in-elixir-phoenix
```
require IEx; IEx.pry

iex -S mix phoenix.server
```

### Run Console
```
iex -S mix
```