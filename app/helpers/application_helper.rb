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
    file.file_name.size > 10 ? "#{default_name}_#{simple_time file.created_at}" : file.file_name
  end
end
