module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    initializer 'wallaby.assets.precompile' do |_|
      config.assets.precompile +=
        %w(
          codemirror* codemirror/**/*
          wallaby/bad_request.png
          wallaby/forbidden.png
          wallaby/internal_server_error.png
          wallaby/not_found.png
          wallaby/not_implemented.png
          wallaby/unauthorized.png
          wallaby/unprocessable_entity.png
          turbolinks
        )
    end

    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          Rails.logger.debug '  [WALLABY] Reloading...'
          ::Wallaby::Map.clear
          ::Wallaby::PreloadUtils.require_all
        end
      end
    end

    initializer 'wallaby.autoload_paths', before: :set_load_path do |_|
      # NOTE: this needs to be run before `set_load_path`
      # so that files under `app/views` can be eager loaded
      # and therefore, Wallaby's renderer can function properly
      [config, Rails.configuration].each do |conf|
        next if conf.paths['app/views'].eager_load?
        conf.paths.add 'app/views', eager_load: true
      end
    end

    config.before_eager_load do
      # NOTE: We need to ensure that the core models are loaded before anything else
      Rails.logger.debug '  [WALLABY] Preload all model files.'
      ::Wallaby::PreloadUtils.require_one 'app/models'
    end

    # Preload the rest files
    config.after_initialize do
      unless Rails.env.development? || Rails.configuration.eager_load
        Rails.logger.debug '  [WALLABY] Preload files after initialize.'
        ::Wallaby::PreloadUtils.require_all
      end
    end
  end
end
