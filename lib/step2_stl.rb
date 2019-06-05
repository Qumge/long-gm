require 'qiniu'
require 'rest-client'
require 'qiniu/upload'
class Step2Stl
  # file_name 云服务器上file名
  # target_name 解析后文件名
  # current_path 下载文件路径
  # target_path 解析文件路径
  attr_accessor :file_name, :target_name, :current_path, :target_path, :bucket

  def initialize args={}
    @file_name = args[:file_name]
    arr = @file_name.split '.'
    arr[-1] = 'stl'
    @target_name = arr.join '.'
    @current_path = "public/stp/#{@file_name}"
    @target_path = "public/stl/#{@target_name}"
    @bucket = args[:bucket]
  end

  #转换文件
  def convert
    command = Settings.step2stl
    res =  `#{command} --convert #{@current_path} #{@target_path} 0.1`
    logger.info res
  end

  #下载文件
  def download_file
    File.open(@current_path, 'w:ASCII-8BIT:utf-8') {|f|
      block = proc { |response|
        response.read_body do |chunk|
          f.write chunk
        end
      }
      RestClient::Request.execute(method: :get,
                                  url: (Rails.application.config.qiniu_domain + '/' + @file_name ),
                                  block_response: block)
    }
  end


  # 上传文件
  def upload
    QiniuUploader.upload @bucket, @target_path, @target_name
    # 构建上传策略，上传策略的更多参数请参照 http://developer.qiniu.com/article/developer/security/put-policy.html
    # put_policy = Qiniu::Auth::PutPolicy.new(
    #     bucket, # 存储空间
    #     key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
    #     3600    # token 过期时间，默认为 3600 秒，即 1 小时
    # )
    # # 生成上传 Token
    # uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    # # 要上传文件的本地路径
    # code, result, response_headers = Qiniu::Storage.upload_with_token_2(
    #     uptoken,
    #     filePath,
    #     key,
    #     nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
    #     bucket: bucket
    # )
    # #code 200 上传成功
    # logger.info({code: code, result: result, response_headers: response_headers})
    # code
  end


  def step2_stl
    logger.info 'start download file'
    download_file
    logger.info 'end download file'
    logger.info 'start convert file'
    convert
    logger.info 'end convert file'
    logger.info 'start upload file'
    res = upload
    if res == 200
      logger.info "delete current_file #{@current_path}"
      File.delete( @current_path )
      logger.info "delete target_file #{@target_path}"
      File.delete( @target_path )
    end
    logger.info 'end upload file'
    res
  end

  def logger
    Logger.new 'log/step2_stl.log'
  end



end