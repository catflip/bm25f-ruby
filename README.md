# bm25f-ruby

A fast implementation of the BM25F ranking algorithm for information retrieval systems, written in Ruby.

## Installation

If you use bundler, add this to your Gemfile:

```ruby
gem 'bm25f', '~> 0.2.0'
```

Otherwise, you can install it using `gem`:

```shell
$ gem install bm25f
```

## Usage

```ruby
require 'bm25f'

# Example data
data = [
  { url: 'https://example.site', title: 'Example Site', description: 'Lorem ipsum dolor sit amet.' },
  { url: 'https://test.website', title: 'Test Website', description: 'A site for testing stuff.' }
]

query = 'test site'

# Create a new BM25F model
bm25f = BM25F.new

# Load the document data in the model using custom weights
bm25f.fit data, { url: 0.5, title: 1, description: 0.8 }

# Calculate the score of the data
score = bm25f.score query

score.each do |k, v|
  # Print out the URL, the query and the score
  puts "#{data[k][:url]} is similar to '#{query}' by #{v}"
end
```
