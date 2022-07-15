class Message < ApplicationRecord
    validates :body, presence: true

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  
    #index_name Rails.application.class.parent_name.underscore
    #document_type self.name.downcase

    es_index_settings = {
        'analysis': {
          'filter': {
            'trigrams_filter': {
              'type':'ngram',
              'min_gram': 3,
              'max_gram': 3
            }
          },
          'analyzer': {
            'trigrams': {
              'type': 'custom',
              'tokenizer': 'standard',
              'filter': [
                'lowercase',
                'trigrams_filter'
              ]
            }
          }
        }
    }
    
    settings es_index_settings do
        mapping do
            indexes :body, type: 'text', analyzer: 'trigrams'
        end
    end
end