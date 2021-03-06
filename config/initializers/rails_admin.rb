RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_user)
  ## == Devise ==
  config.authenticate_with do
    # authenticate_admin_user!
    # warden.authenticate! scope: :user
    redirect_to main_app.root_path, alert: '无权限' unless current_user.present? && current_user.has_role?('super_admin')
  end
  config.main_app_name = ["龙胜", "图文"]
  config.included_models = ['User', 'Resource', 'Role', 'Category', 'InstanceCategory', 'Organization']

  config.model 'Category' do
    label_plural "产品类型"
    field :name do
      label '类型名'
    end
  end

  config.model 'InstanceCategory' do
    label_plural "物料属性"
    field :name do
      label '属性名'
    end
    field :desc do
      label '备注'
    end
  end

  config.model 'User' do
    label_plural "用户"
    field :login do
      label '账号'
    end
    field :email do
      label '邮箱'
    end
    field :password do
      label '密码'
    end
    field :phone do
      label '号码'
    end
    field :name do
      label '姓名'
    end
    field :organization do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '部门'
    end
    field :role do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label '角色'
    end

  end
  config.model 'Role' do
    label_plural "角色"
    field :name do
      label '角色名'
    end
    field :desc  do
      label '说明'
    end
    field :resources do
      associated_collection_cache_all true
      label '权限'
    end
  end

  config.model 'Resource' do
    label_plural "权限资源"
    field :name do
      label '说明'
    end
    field :action do
      label '操作'
    end
    field :target do
      label '模块'
    end
  end

  config.model 'Organization' do
    label '组织架构'
    label_plural "组织架构"
    field :name do
      label '组织名'
    end
    field :desc do
      label '备注'
    end
    nestable_tree({
                      live_update: :only
                  })

  end
  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    nestable

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
