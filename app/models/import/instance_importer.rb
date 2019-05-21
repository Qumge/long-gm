class Import::InstanceImporter < ActiveImporter::Base
  imports Product
  imports Instance
  imports InstanceCategory
  transactional

  on :import_started do
    @row_count = 2
    @models = {}
    logger.info "开始导入物料信息...."
  end
  column '层级'
  column '物料代码'
  column '物料名称'
  column '规格型号'
  column '物料属性'



  fetch_model do
    raise "第#{row_count}行 物料代码不存在。" unless row['物料代码'].present?
    instance = Instance.find_or_initialize_by instance_no: row['物料代码']
    instance
  end

  on :row_processing do
    instance = model
    instance.user = params[:user]
    raise "第#{row_count}行 层级不存在。" unless row['层级'].present?
    depth = row['层级'].to_s.gsub('.', '').to_i
    if depth == 1
      instance.parent = nil
    else
      parent = @models[(depth - 1).to_s]
      if parent.present?
        instance.parent = parent
      else
        raise "第#{row_count}行 找不到上一层级。"
      end
    end

    raise "第#{row_count}行 物料名称不存在。" unless row['物料名称'].present?
    instance.name = row['物料名称']

    instance.norms = row['规格型号']

    if row['物料属性'].present?
      instance_category = InstanceCategory.find_by name: row['物料属性']
      if instance_category.present?
        instance.instance_category = instance_category
      else
        raise "第#{row_count}行 物料属性不存在。"
      end
    end

    instance.save
    @models[depth.to_s] = instance
    p @models
  end

  on :row_processed do
    @row_count += 1
  end

  on :row_error do |e|
    logger.error e.message
  end

  on :import_failed do |exception|
    logger.error exception.message
  end

  on :import_finished do
    logger.info "#{@row_count} lines Data imported successfully!"
  end

  private

  def logger
    Logger.new "log/instance_import.log"
  end
end
