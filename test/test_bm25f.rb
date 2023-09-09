require 'minitest/autorun'
require 'bm25f'

class BM25FTest < Minitest::Test
  def setup
    @bm25f = BM25F.new
    @documents = [
      { title: 'hello world', content: 'foo bar baz' },
      { title: 'foo bar', content: 'goodbye, world!' }
    ]
  end

  def test_score
    @bm25f.fit @documents
    scores = @bm25f.score 'hello world foo bar baz'

    # Sort
    scores = scores.to_a.sort_by { |_, v| v.to_i }

    # Checks if the most matching element is the first element
    assert scores.last[0].zero?
  end
end
