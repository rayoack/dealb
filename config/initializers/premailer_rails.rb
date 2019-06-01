Premailer::Rails.config.merge!(preserve_styles: true,
                               remove_ids: true,
                               strategies: [:filesystem, :asset_pipeline, :network])
