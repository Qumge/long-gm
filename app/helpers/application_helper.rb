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
        },
        matters: {
            index: 'Bom单列表',
            show: 'Bom单详情'
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

  def products_tree products
    data = []
    products.each do |product|
      data << {
          "id": "product_#{product.id}",
          "model_id": product.id,
          "name": product.name,
          "no": product.product_no,
          "model_type": Product.get_model_name,
          "norms": product.norms.to_s,
          "user_name": product.user&.name,
          "parentId": 0,
          "expandAll": false,
          "icon": "glyphicon glyphicon-thumbs-up"
      }
      product.instances.each do |instance|
        data << {
            "id": "instance_#{product.id}_#{instance.id}",
            "model_id": instance.id,
            "name": instance.name,
            "no": instance.instance_no,
            "model_type": Instance.get_model_name,
            "norms": instance.norms.to_s,
            "user_name": instance.user&.name,
            "parentId": "product_#{product.id}",
            "icon": "glyphicon glyphicon-thumbs-up"
        }
      end
    end
    data.to_json
  end

  def instances_tree instances, level, data=[]
    instances.each do |instance|
      hash = {
          "id": "instance_#{level}_#{instance.id}",
          "model_id": instance.id,
          "name": instance.name,
          "no": instance.instance_no,
          "model_type": Instance.get_model_name,
          "norms": instance.norms.to_s,
          "user_name": instance.user&.name,
          "expandAll": false,
          "icon": "glyphicon glyphicon-thumbs-up"
      }
      hash['parentId'] = "instance_#{level-1}_#{instance.parent&.id}" if level > 0
      data << hash
      if instance.children.present?
        instances_tree instance.children, level+1, data
      end
    end
    data.to_json
  end

  def technologies_tree technologies
    data = []
    technologies.each do |technology|
      data << {
          "id": "technology_#{technology.id}",
          "model_id": technology.id,
          "name": technology.name,
          "no": technology.no,
          "model_type": Technology.get_model_name,
          "user_name": technology.user&.name,
          "parentId": 0,
          "expandAll": false,
          "icon": "glyphicon glyphicon-thumbs-up"
      }
      technology.instances.each do |instance|
        data << {
            "id": "instance_#{technology.id}_#{instance.id}",
            "model_id": instance.id,
            "name": instance.name,
            "no": instance.instance_no,
            "model_type": Instance.get_model_name,
            "user_name": instance.user&.name,
            "parentId": "technology_#{technology.id}",
            "icon": "glyphicon glyphicon-thumbs-up"
        }
      end
      technology.products.each do |product|
        data << {
            "id": "product_#{technology.id}_#{product.id}",
            "model_id": product.id,
            "name": product.name,
            "no": product.product_no,
            "model_type": Product.get_model_name,
            "user_name": product.user&.name,
            "parentId": "technology_#{technology.id}",
            "icon": "glyphicon glyphicon-thumbs-up"
        }
      end
    end
    data.to_json
  end
end
