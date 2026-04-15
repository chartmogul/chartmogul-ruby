# ChartMogul Ruby SDK

Ruby SDK wrapping the ChartMogul API. Requires Ruby >= 3.2. Uses Faraday for HTTP with automatic retry and exponential backoff.

## Commands

```bash
bundle install                                       # install dependencies
bundle exec rspec                                    # run full test suite
bundle exec rspec spec/chartmogul/customer_spec.rb   # run single spec file
gem build chartmogul-ruby.gemspec                    # build gem
```

Version is in `lib/chartmogul/version.rb`.

## Architecture

### Class hierarchy

```
ChartMogul::Object               # base: attribute DSL, serialization
  └── ChartMogul::APIResource    # adds HTTP, error handling, connection pooling
        └── Concrete resources   # Customer, Plan, Invoice, etc.
```

### Attribute DSL

Defined at the top of each class:

- `readonly_attr :uuid` — getter only, set via `new_from_json`
- `writeable_attr :name` — getter + setter, included in `serialize_for_write`
- Type hints: `readonly_attr :created_at, type: :time` (also `:date`)

### Resource class macros

- `set_resource_name 'Customer'` — human-readable name for errors
- `set_resource_path '/v1/customers'` — API endpoint (supports `:param_name` placeholders)
- `set_resource_root_key :entries` — JSON key wrapping collection results
- `set_entry_class Customer` — links plural class to singular
- `set_immutable_keys %i[attributes custom]` — keys excluded from snake_case conversion

### Singular / plural pattern

Every API resource uses two classes:

- **Singular** (e.g., `Customer`) — individual CRUD, custom actions
- **Plural** (e.g., `Customers`) — collection retrieval with pagination via `Concerns::Entries`

### Action modules (`lib/chartmogul/api/actions/`)

Include to compose CRUD behavior:

- `API::Actions::Create` — `create!` (POST)
- `API::Actions::Retrieve` — `retrieve` (GET by UUID)
- `API::Actions::Update` — `update!` (PATCH)
- `API::Actions::Destroy` — `destroy!` (DELETE)
- `API::Actions::All` — `all` (GET collection)
- `API::Actions::Custom` — `custom!` (flexible method/path)

### Concern modules (`lib/chartmogul/concerns/`)

- `Concerns::Entries` — makes plural classes enumerable, auto-includes `All`
- `Concerns::PageableWithCursor` — cursor-based pagination (`has_more`, `cursor`, `next`)
- `Concerns::Pageable` — offset-based pagination (legacy)
- `Concerns::ExternalIdOperations` — CRUD by external_id + data_source_uuid
- `Concerns::ToggleDisabled` — `toggle_disabled!` PATCH endpoint
- `Concerns::Summary` / `SummaryAll` — metrics rollup attributes

### Configuration

```ruby
ChartMogul.api_key = 'key'         # thread-local (preferred)
ChartMogul.global_api_key = 'key'  # process-wide fallback
ChartMogul.max_retries = 20        # default; retries on 429 and 5xx
```

Thread-local config takes precedence over global. Clearing api_key resets the cached connection.

### Error mapping

All errors inherit `ChartMogulError` with `http_status` and `response` attributes:

| HTTP status | Error class |
|-------------|-------------|
| 400 | `SchemaInvalidError` |
| 401 | `UnauthorizedError` |
| 403 | `ForbiddenError` |
| 404 | `NotFoundError` |
| 422 | `ResourceInvalidError` |
| 5xx | `ServerError` |

### Path and query parameters

The `:param_name` in `resource_path` is extracted from method arguments. Remaining params become query string. Handled by `ResourcePath` in `lib/chartmogul/resource_path.rb`.

### Serialization

- `serialize_for_write` — returns writeable attributes, filtering out nils and empty arrays
- Custom hooks: define `serialize_#{attr_name}` to override serialization for specific attributes
- JSON responses are parsed with symbolized keys and converted to snake_case via `HashSnakeCaser`

## Testing

**Stack:** RSpec + VCR + WebMock

### Conventions

- VCR cassettes live in `spec/fixtures/vcr_cassettes/`, organized by describe block path
- Tag API tests with `vcr: true` and `uses_api: true` metadata
- Test both `#initialize` (attribute assignment) and `.new_from_json` (API response parsing)
- For retry/error tests: wrap in `VCR.turned_off` and use WebMock stubs directly
- Shared examples in `spec/support/` for common patterns (deprecated params, query param retrieval)
- Thread-local config is cleared in `before(:each)` — tests are isolated

### CI

GitHub Actions on push/PR to main. Matrix: Ruby 3.2, 3.3, 3.4, head. Runs `bundle exec rake` (default task is `:spec`).

## Code style

- `# frozen_string_literal: true` on every `.rb` file
- snake_case methods, CamelCase classes/modules, UPPER_CASE constants
- `!` suffix on methods that make HTTP requests and mutate state
- File layout: attributes → includes → class methods → instance methods → private
- Files registered via `require` in `lib/chartmogul.rb`
- Linting: rubocop, rubocop-rspec, rubocop-thread_safety (dev dependencies)
