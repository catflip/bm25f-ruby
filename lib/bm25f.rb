require 'treat'

class BM25F
  include Treat::Core::DSL

  # Initializes a BM25F model.
  #
  # @param term_freq_weight [Float] Weight for term frequency.
  # @param doc_length_weight [Float] Weight for document length.
  def initialize(term_freq_weight: 1.33, doc_length_weight: 0.8)
    @term_freq_weight = term_freq_weight
    @doc_length_weight = doc_length_weight
  end

  # Fits the model to a set of documents.
  #
  # @param documents [Hash] The documents to fit the model to.
  # @param field_weights [Hash] A specified weight for each key the documents.
  def fit(documents, field_weights = {})
    documents = preprocess_documents(documents)

    # Set missing field_weights to 1
    unique_keys = documents.flat_map(&:keys).uniq

    unique_keys.each do |key|
      field_weights[key] = 1 unless field_weights.key?(key)
    end

    @field_weights = field_weights
    @documents = documents
    @avg_doc_length = calculate_average_document_length(documents)
    @doc_lengths = calculate_document_lengths(documents)
    @total_docs = documents.length
    @idf = calculate_idf
  end

  # Calculates the score of each document using the query.
  #
  # @param query [String] The query to score with.
  # @return [Hash] A hash containing document IDs and their scores.
  def score(query)
    query_terms = preprocess_query(query)
    scores = {}
    (0...@total_docs).each do |doc_id|
      scores[doc_id] = calculate_document_score(doc_id, query_terms)
    end
    scores
  end

  private

  # Preprocesses documents by tokenizing and stemming them.
  #
  # @param documents [Hash] The documents to preprocess.
  def preprocess_documents(documents)
    documents.each do |k, v|
      next unless v.instance_of? String

      documents[k] = sentence(v).map(&:stem).join(' ')
    end
    documents
  end

  # Calculates the average document length.
  #
  # @param documents [Hash] The documents.
  # @return [Float] The average document length.
  def calculate_average_document_length(documents)
    total_length = documents.sum { |doc| doc.values.map { |v| v.nil? ? 0 : v.length }.sum }
    total_length / documents.length.to_f
  end

  # Calculates the lengths of each field in a document.
  #
  # @param documents [Hash] The documents.
  # @return [Hash] A hash of document lengths.
  def calculate_document_lengths(documents)
    doc_lengths = {}
    documents.each_with_index do |doc, i|
      doc_lengths[i] = doc.transform_values { |v| v.nil? ? 0 : v.length }
    end
    doc_lengths
  end

  # Calculates the IDF for each field.
  #
  # @return [Hash] A hash of IDF values for each field.
  def calculate_idf
    idf = {}
    @field_weights.each_key do |field|
      field_doc_count = @documents.count { |doc| !doc[field].empty? }
      idf[field] = Math.log((@total_docs - field_doc_count + 0.5) / (field_doc_count + 0.5) + 1.0)
    end
    idf
  end

  # Preprocesses a query by tokenizing and stemming it.
  #
  # @param query [String] The query to preprocess.
  # @return [Array<String>] An array of preprocessed query terms.
  def preprocess_query(query)
    sentence(query).tokenize.map(&:stem)
  end

  # Calculates the score of a document using an array of query terms.
  #
  # @param doc_id [Integer] The document ID.
  # @param query_terms [Array<String>] The query terms.
  # @return [Float] The document score.
  def calculate_document_score(doc_id, query_terms)
    doc_score = 0
    @field_weights.each_key do |field|
      query_terms.each do |term|
        tf = field_term_frequency(field, term, doc_id)
        idf = @idf[field]
        field_length_norm = field_length_norm(field, doc_id)
        doc_score += @field_weights[field] * ((tf * (@term_freq_weight + 1)) / (tf + @term_freq_weight * field_length_norm) * idf)
      end
    end
    doc_score
  end

  # Calculates the term frequency in a field of a document.
  #
  # @param field [Symbol] The field name.
  # @param term [String] The term to calculate frequency for.
  # @param doc_id [Integer] The document ID.
  # @return [Integer] The term frequency.
  def field_term_frequency(field, term, doc_id)
    @documents[doc_id][field].scan(term).count
  end

  # Calculates the field length normalization factor of a document.
  #
  # @param field [Symbol] The field name.
  # @param doc_id [Integer] The document ID.
  # @return [Float] The field length normalization factor.
  def field_length_norm(field, doc_id)
    1.0 - @doc_length_weight + @doc_length_weight * (@doc_lengths[doc_id][field] / @avg_doc_length)
  end
end
