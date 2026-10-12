# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  # @deprecated Use {ChartMogul::EntityNote} instead. /v1/customer_notes is superseded by /v1/notes.
  class Note < APIResource
    set_resource_name 'CustomerNote'
    set_resource_path '/v1/customer_notes'

    readonly_attr :uuid

    writeable_attr :customer_uuid
    writeable_attr :type
    writeable_attr :text
    writeable_attr :author
    writeable_attr :text
    writeable_attr :call_duration
    writeable_attr :created_at
    writeable_attr :updated_at

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    # @deprecated Use {ChartMogul::EntityNote.all} instead.
    def self.all(options = {})
      Notes.all(options)
    end

    # @deprecated Use {ChartMogul::EntityNote.create!} instead.
    def self.create!(attributes = {})
      warn 'DEPRECATION WARNING: the method ChartMogul::Note.create! is deprecated. Use ChartMogul::EntityNote.create! instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote.retrieve} instead.
    def self.retrieve(uuid, options = {})
      warn 'DEPRECATION WARNING: the method ChartMogul::Note.retrieve is deprecated. Use ChartMogul::EntityNote.retrieve instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote.update!} instead.
    def self.update!(uuid, attributes = {})
      warn 'DEPRECATION WARNING: the method ChartMogul::Note.update! is deprecated. Use ChartMogul::EntityNote.update! instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote.destroy!} instead.
    def self.destroy!(options = {})
      warn 'DEPRECATION WARNING: the method ChartMogul::Note.destroy! is deprecated. Use ChartMogul::EntityNote.destroy! instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote#create!} instead.
    def create!
      warn 'DEPRECATION WARNING: the method ChartMogul::Note#create! is deprecated. Use ChartMogul::EntityNote#create! instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote#update!} instead.
    def update!
      warn 'DEPRECATION WARNING: the method ChartMogul::Note#update! is deprecated. Use ChartMogul::EntityNote#update! instead.'
      super
    end

    # @deprecated Use {ChartMogul::EntityNote#destroy!} instead.
    def destroy!
      warn 'DEPRECATION WARNING: the method ChartMogul::Note#destroy! is deprecated. Use ChartMogul::EntityNote#destroy! instead.'
      super
    end
  end

  # @deprecated Use {ChartMogul::EntityNotes} instead.
  class Notes < APIResource
    set_resource_name 'CustomerNotes'
    set_resource_path '/v1/customer_notes'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Note

    # @deprecated Use {ChartMogul::EntityNotes.all} instead.
    def self.all(options = {})
      warn 'DEPRECATION WARNING: the method ChartMogul::Notes.all is deprecated. Use ChartMogul::EntityNotes.all instead.'
      super
    end
  end
end
