module FileConcern
  extend ActiveSupport::Concern
  included do
    def preview_url
      if is_stp?
        arr = self.file_path.split '.'
        arr[-1] = 'stl'
        path = arr.join '.'
        Rails.application.config.qiniu_domain + '/' + path
      else
        download_url
      end
    end

    def download_url
      Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
    end

    def stp2_stl
       if is_stp?
        res = Step2Stl.new(file_name: self.file_path).step2_stl
        self.update_columns stl_code: res, last_stl_time: DateTime.now, stl_done: res == 200
      end
    end

    def is_stp?
      self.file_path.present? &&  ['stp', 'step'].include?(self.file_path.to_s.split('.')[-1])
    end

    def do_stp2_stl
      if self.file_path_changed?
        self.update_columns stl_done: false
        StlJob.perform_later self
      end
    end

  end
end