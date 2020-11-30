require 'pocket-ruby'
require 'mongoid'

module FanaOs
  class PocketUtils
    def initialize
      FanaOs.configure_mongo
      FanaOs.configure_pocket

      @client = Pocket.client(access_token: ENV.fetch('POCKET_ACCESS_TOKEN'))
    end

    def retrieve
      pocket_articles = @client.retrieve(
        images: 1,
        videos: 1,
        tags: 1,
        rediscovery: 1,
        annotations: 1,
        authors: 1,
        itemOptics: 1,
        meta: 1,
        posts: 1,
        total: 1,
        forceaccount: 1,
        state: 'all',
        sort: 'newest',
        detailType: 'complete'
      )['list'].values

      pocket_articles.each { |article| process_article(article) }

      pocket_articles
    end

    def process_article(attributes)
      article = FanaOs::PocketArticle.find_or_create_by(
        pocket_id: attributes['item_id'],
        title: attributes['resolved_title'],
        url: attributes['resolved_url'],
        added_at: Time.at(attributes['time_added'].to_i)
      )
      
      # 0 = unread / 1 = read. We don't want to add highlights multiple times.
      if attributes['status'].to_i == 1
        time_read = Time.at(attributes['time_read'].to_i)
        
        notes_path = "#{ENV.fetch('OBSIDIAN_ROOT')}/research/Daily/#{time_read.strftime('%Y-%m-%d')}.md"

        annotations = []

        highlights = attributes['annotations'].to_a.map do |a| 
          annotation = FanaOs::PocketAnnotation.find_or_create_by(
            annotation_id: a['annotation_id'],
            quote: a['quote'],
            patch: a['patch'],
            pocket_article_id: a['item_id'],
            annotated_at: Date.parse(a['created_at'])
          )

          annotations << annotation

          "- #{a['quote']}" 
        end

        content_to_append = [
          "**[#{attributes['resolved_title']}](#{attributes['resolved_url']})**",
          "*By #{attributes['authors'].to_h.values.map { |author| author['name'] }.join(', ')}*",
          "Tags: #{attributes['tags'].to_h.keys.map { |key| "[[#{key}]]" }.join(', ')}",
          highlights,
          "\n",
          "\n"
        ].flatten.join("\n")

        # Making sure we don't add notes twice
        if !File.exist?(notes_path) || File.readlines(notes_path).any?{ |l| l.include? attributes['resolved_title'] }
          File.write(notes_path, content_to_append, mode: 'a')
        end

        article.update(
          read_at: time_read,
          word_count: attributes['word_count'],
          annotations_added_at: Date.current,
          tags: attributes['tags'].to_h.keys
        )
      end
    end
  end

  class PocketArticle
    include Mongoid::Document

    field :pocket_id, type: String
    field :title, type: String
    field :url, type: String
    field :added_at, type: Date
    field :read_at, type: Date
    field :word_count, type: Integer
    field :annotations_added_at, type: Date
    field :tags, type: Array, default: []

    has_many :pocket_annotations
  end

  class PocketAnnotation
    include Mongoid::Document

    field :annotation_id, type: String
    field :pocket_article_id, type: String
    field :quote, type: String
    field :patch, type: String
    field :annotated_at, type: Date

    belongs_to :pocket_article
  end
end