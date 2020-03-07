module ShopHelper
  def product_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '详情编辑', edit_shop_product_path(product)
        li link_to '图片管理', shop_product_images_path(product)
        li link_to '商品组合管理', shop_product_variants_path(product)
      end
    end
  end
end