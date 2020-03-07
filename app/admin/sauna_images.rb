ActiveAdmin.register AdminImage, as: 'SaunaImage' do
  config.filters = false
  belongs_to :sauna

  sidebar '侧边栏', only: [:index] do
    sauna_sidebar_generator(self)
  end

  config.clear_action_items!
  action_item :add, only: :index do
    link_to '新增图片', new_admin_sauna_sauna_image_path(sauna), remote: true
  end

  index do
    render 'admin/saunas/images/index', context: self
  end

  permit_params :image
  controller do
    before_action :set_sauna, only: [:new, :create]
    skip_before_action :verify_authenticity_token, only: [:create]

    def new
      @image = @sauna.sauna_images.build
      render 'admin/saunas/images/new'
    end

    def create
      @image = @sauna.sauna_images.build(permitted_params[:admin_image])
      flash[:notice] = '新建成功' if @image.save
      render 'admin/saunas/images/response'
    end

    def set_sauna
      @sauna = Sauna.find(params[:sauna_id])
    end
  end
end
