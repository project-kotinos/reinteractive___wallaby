module Wallaby
  # Utils
  module Utils
    # A helper method to check if subject responds to given method otherwise return default value from calling the block
    # @param subject [Object]
    # @param method_id [String, Symbol]
    # @param args [Array] a list of arguments
    # @yield [subject] a block to be executed if subject doesn't respond to the given method_id
    # @return [Object] result from executing given method on subject
    # @return [nil] if subject doesn't respond to given method
    def self.try_to(subject, method_id, *args)
      return if method_id.blank?
      subject.respond_to?(method_id) && subject.public_send(method_id, *args) || block_given? && yield(subject) || nil
    end

    # Check whether a class is anonymous or not
    # @param klass [Class]
    # @return [Boolean] true if a class is anonymous, false otherwise
    def self.anonymous_class?(klass)
      klass.name.blank? || klass.to_s.start_with?('#<Class')
    end

    def self.deprecate(key, caller:, options: {})
      warn I18n.t(key, options.merge(from: caller[0]))
    end

    # Help to translate a message for a class
    # @param object [Object]
    # @param key [String, Symbol]
    # @param options [Hash]
    # @return [String] a message for this class
    def self.translate_class(object, key, options = {})
      klass = object.is_a?(Class) ? object : object.class
      key = [klass.name, key].join(SLASH).underscore.gsub(SLASH, DOT)
      I18n.t key, options
    end

    # Find filter name in the following precedences:
    # - filter name argument
    # - filters that has been marked as default
    # - `:all`
    # @param filter_name [String, Symbol] filter name
    # @param filters [Hash] filter metadata
    # @return [String, Symbol]
    def self.find_filter_name(filter_name, filters)
      filter_name || # from params
        filters.find { |_k, v| v[:default] }.try(:first) || # from default value
        :all # last resort
    end

    # @todo maybe delegate this label thing to the mode?
    # @param field_name [String, Symbol] field name
    # @return [String] field label
    def self.to_field_label(field_name, metadata)
      field_name = field_name.to_s if field_name.is_a? Symbol
      metadata[:label] || field_name.humanize
    end

    # Return `form` for `new/create/edit/update`
    # @param action_name [String]
    # @return [String] action name
    def self.to_partial_name(action_name)
      FORM_ACTIONS[action_name] || action_name
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end

    # Preload files
    def self.preload_all
      ::Wallaby::ApplicationController.to_s
      preload 'app/models/**/*.rb'
      preload 'app/decorators/**/*.rb'
      preload 'app/controllers/**/*.rb'
      preload 'app/servicers/**/*.rb'
      preload 'app/**/*.rb'
    end

    # Preload files
    def self.preload(file_pattern)
      Dir[file_pattern].each do |file_path|
        begin # rubocop:disable Style/RedundantBegin
          name = file_path[%r{app/[^/]+/(.+)\.rb}, 1].gsub('concerns/', '')
          class_name = name.classify
          class_name.constantize unless Module.const_defined? class_name
        rescue NameError, LoadError => e
          Rails.logger.debug "  [WALLABY] Preload warning: #{e.message}"
          Rails.logger.debug e.backtrace.slice(0, 5)
        end
      end
    end
  end
end
