class QiniuUploader
  class << self
    # key 上传后保存的文件名
    # filePath 要上传文件的本地路径
    # bucket : 仓库名
    def upload bucket, filePath, key
      # 构建上传策略，上传策略的更多参数请参照 http://developer.qiniu.com/article/developer/security/put-policy.html
      put_policy = Qiniu::Auth::PutPolicy.new(
          bucket, # 存储空间
          key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
          3600    # token 过期时间，默认为 3600 秒，即 1 小时
      )
      # 生成上传 Token
      uptoken = Qiniu::Auth.generate_uptoken(put_policy)

      code, result, response_headers = Qiniu::Storage.upload_with_token_2(
          uptoken,
          filePath,
          key,
          nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
          bucket: bucket
      )
      #code 200 上传成功
      logger.info({code: code, result: result, response_headers: response_headers})
      code
    end

    def logger
      Logger.new 'log/step2_stl.log'
    end
  end
end