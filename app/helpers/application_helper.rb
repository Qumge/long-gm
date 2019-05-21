module ApplicationHelper
  def uptoken

    put_policy = Qiniu::Auth::PutPolicy.new(
        "longsheng_gm",                    # 存储空间
        nil,                           # 最终资源名，可省略，即缺省为“创建”语义
        1800,                          # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
        (Time.now + 30.minutes).to_i  # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试，这里表示半小时
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy) #生成凭证

  end

  def simple_time datetime
    datetime.strftime('%Y-%m-%d')if datetime.present?
  end

  def simple_time_mini datetime
    datetime.strftime('%Y-%m-%d %H:%M:%S')if datetime.present?
  end


  def get_title params
    title_config[params[:controller].to_sym].present? ? title_config[params[:controller].to_sym][params[:action].to_sym] : ''
  end

  def title_config
    {

        products: {
            index: '产品列表',
            new: '添加产品',
            create: '添加产品',
            edit: '修改产品',
            update: '修改产品',
            show: '产品详情'
        },
        instances: {
            index: '零件列表',
            new: '添加零件',
            create: '添加零件',
            edit: '修改零件',
            update: '修改零件',
            show: '零件详情'
        },
        technologies: {
            index: '工艺文件列表',
            new: '添加工艺文件',
            create: '添加工艺文件',
            edit: '修改工艺文件',
            update: '修改工艺文件',
            show: '工艺文件详情'
        },
        home: {
            index: '我的文件',
            files_search: '内容搜索'
        }

    }
  end

  def active_class params, controller, action=nil
    if action.present?
      params[:controller] == controller && params[:action] == action ? 'active' : ''
    else
      params[:controller] == controller ? 'active' : ''
    end
  end

  def show_file_name default_name, file
    file.file_name.size > 10 ? "#{default_name}_#{file.file_name[0..10]}" : file.file_name
  end

  def associated_models
    Product.all + Instance.all + Technology.all + Matter.all
  end

  def model_url model
    send "#{model.model_type.downcase}_path", model.model_id
  end
end
