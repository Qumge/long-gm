require 'zip'
require 'qiniu/upload'
class ZipFile
  attr_accessor :zip_name, :zip_path, :bucket

  #
  #
  def initialize args={}
    @zip_name = args[:zip_name]
    @zip_path = "public/zip/#{@zip_name}"
    @input_dir = "public/unzip/"
    @bucket = args[:bucket]
  end


  def unzip
    unzip_files = {}
    Zip::File.open(@zip_path) do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        #获取文件名
        file_name = entry.name.split('/').last
        # 空文件名标识为 文件夹  .开头标识隐藏文件
        next if entry.name.last == '/' || file_name.first == '.'
        begin
          logger.info "Extracting #{entry.name}"
          file_path = File.join @input_dir, file_name
          entry.extract file_path
          logger.info "upload #{file_name}"
          key = "#{SecureRandom.uuid}.#{file_name.split('.').last}"
          res = QiniuUploader.upload @bucket, file_path, key
          if res == 200
            #删除文件
            File.delete file_path
          end
          unzip_files[key] = file_name
        rescue => e
          logger.info e.message
        end

        # Read into memory
        #content = entry.get_input_stream.read
      end
      # Find specific entry
      #entry = zip_file.glob('*.csv').first
      #puts entry.get_input_stream.read
    end
    unzip_files
  end

  def logger
    Logger.new 'log/unzip.log'
  end


end