Gem::Specification.new do |s|
  s.name = 'bm25f'
  s.version = '0.2.1'
  s.summary = 'BM25F ranking function in Ruby.'
  s.description = 'A fast implementation of the BM25F ranking algorithm for information retrieval systems, written in Ruby.'
  s.author = 'catflip'
  s.files = Dir['lib/**/*', 'test/**/**']
  s.homepage = 'https://github.com/catflip/bm25f-ruby'
  s.license = 'AGPL-3.0'
  s.metadata = {
    'homepage_uri' => 'https://github.com/catflip/bm25f-ruby',
    'source_code_uri' => 'https://github.com/catflip/bm25f-ruby'
  }
  s.required_ruby_version = '>= 3.0.0'

  s.add_runtime_dependency 'treat', '>= 2.1'
  s.add_development_dependency 'rake', '>= 10.4.2'
end
