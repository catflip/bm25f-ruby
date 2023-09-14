require 'minitest/autorun'
require 'bm25f'

class BM25FTest < Minitest::Test
  def setup
    @bm25f = BM25F.new
    @documents = [
      { url: 'https://wikimedia.org', title: 'Wikimedia',
        content: 'Wikimedia. Wikimedia is a global movement whose mission is to bring free educational content to the world. Through various projects, chapters and the support structure of the ...' },
      { url: 'https://twitter.com/Wikipedia', title: 'Wikipedia (@Wikipedia) · Twitter', content: nil },
      { url: 'https://play.google.com/store/apps/details', title: 'Wikipedia - Apps on Google Play',
        content: 'The best Wikipedia experience on your Mobile device. Ad-free and free of charge, forever. With the official Wikipedia app, you can search and explore 40+ ...' },
      { url: 'https://www.wikipedia.org', title: 'Wikipedia',
        content: 'Wikipedia is a free online encyclopedia, created and edited by volunteers around the world and hosted by the Wikimedia Foundation.' }
    ]
  end

  def test_score
    @bm25f.fit @documents
    scores = @bm25f.score 'wikipedia'

    puts scores.inspect
  end
end
