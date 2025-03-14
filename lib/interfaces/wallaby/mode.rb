module Wallaby
  # This is the interface that all ORM modes should inherit from and implement.
  class Mode
    class << self
      # @see Wallaby::ModelDecorator
      # @return [Class] model decorator for the mode
      def model_decorator
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelFinder
      # @return [Class] model finder for the mode
      def model_finder
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelServiceProvider
      # @return [Class] service provider for the mode
      def model_service_provider
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelPaginationProvider
      # @return [Class] pagination provider for the mode
      # @since 5.2.0
      def model_pagination_provider
        check_and_constantize __callee__
      end

      # @see Wallaby::ModelPaginationProvider
      # @return [Class] pagination provider for the mode
      # @since 5.2.0
      def default_authorization_provider
        check_and_constantize __callee__
      end

      # Return a list of authorization providers for authorizer to detect which one to use.
      # @see Wallaby::ModelAuthorizationProvider
      # @return [ActiveSupport::HashWithIndifferentAccess<String, Class>] authorization provider hash
      # @since 5.2.0
      def model_authorization_providers(classes = ModelAuthorizationProvider.descendants)
        # NOTE: make sure default provider always comes last
        @model_authorization_providers ||=
          classes
          .select { |klass| klass.name.include? name }
          .sort_by { |klass| klass.provider_name == DEFAULT_PROVIDER ? 1 : 0 }
          .each_with_object(::ActiveSupport::HashWithIndifferentAccess.new) do |klass, hash|
            hash[klass.provider_name] = klass
          end
      end

      private

      # @return [Class] constantized class
      def check_and_constantize(method_id)
        method_class = method_id.to_s.classify
        class_name = "#{name}::#{method_class}"
        parent_class = "Wallaby::#{method_class}".constantize
        class_name.constantize.tap do |klass|
          next if klass < parent_class
          raise InvalidError, I18n.t('wallaby.mode.inherit_required', klass: klass, parent: parent_class)
        end
      rescue NameError => e
        Rails.logger.error e
        raise NotImplemented, class_name
      end
    end
  end
end
