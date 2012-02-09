ActiveAdmin.register Order do
  actions :index, :show, :edit, :update

  filter :total_price
  filter :number
  filter :articul, :as => :string, :label => I18n.t('active_admin.filters.order.articul')
  #filter :checked_out_at

  scope :all_orders
  scope :new_orders, :default => true
  scope :in_progress
  scope :complete
  scope :canceled

  index do
    column(:number) { |order| 
      content_tag :nobr do 
        link_to "##{order.number} ", admin_order_path(order) 
      end
    }
    
    column(:state) { |order| 
      status_tag(I18n.t("active_admin.scopes.#{order.state}"))
    }

    column(:created_at, :sortable => false)
    column(:delivery_at, :sortable => false)
    column(:checked_out_at, :sortable => false)
    column(:customer, :sortable => false)
    column(:total_price) { |order| 
      number_to_currency order.total_price 
    }
    column { |order|
      link_to I18n.t('active_admin.actions.order.destroy'), admin_order_path(order), :method => :delete, :confirm => t('are_you_shure')

    }
  end

  form do |f|
    f.inputs :process do
      f.input :delivery_at, :as => :datepicker, :format => "%d.%m.%Y"
      f.input :checked_out_at, :as => :datepicker, :format => "%d.%m.%Y"
      f.input :state, :as => :select, 
              :collection => Hash[Order::STATES.map { |name| 
                [I18n.t("active_admin.scopes.#{name}"), name] }
              ]
    end

    f.inputs :info do
      f.input :delivery_type, :as => :select, 
        :collection => {
          I18n.t('active_admin.status_tags.order.delivery') => 'delivery', 
          I18n.t('active_admin.status_tags.order.manual') =>'manual'
        }
      f.input :address
      f.input :discount
      f.input :comment
    end

    f.inputs :control do
      f.input :canceled
    end

    f.buttons
  end

  member_action :add_good, :method => :post do
    @order = Order.find(params[:id])
    @good = Good.visible.find_by_articul(params[:good_articul])
    
    if @good.nil? || params[:good_articul].blank?
      flash[:error] = I18n.t('active_admin.flashes.order.good_not_found')
    else
      if @order.goods.include? @good  
        flash[:error] = I18n.t('active_admin.flashes.order.good_already_present')
      else
        @order.goods = (@order.goods << @good)
        @order.recalculate_price!
        flash[:notice] = I18n.t('active_admin.flashes.order.good_add_success')
      end
    end
    redirect_to admin_order_path(@order)
  end

  show :title => lambda{ |order| I18n.t('active_admin.titles.order.show', :number => order.number) } do
    panel I18n.t('active_admin.titles.order.invoice') do
      table_for(order.order_goods, :i18n => OrderGood) do |t|
        t.column(:articul) { |item| item.good.articul }
        t.column(:product) { |item|
          link_to item.good, edit_admin_category_good_path(
              item.good.category, item.good)
        }
        t.column(:variant) { |item|
          raw item.variant.map{ |variant_type, variant|
            content_tag :nobr, "#{t("good.variants.#{variant_type}")}: #{variant}"
          }.join(", ")
        }
        t.column :count
        t.column(:price) { |item| number_to_currency(item.price*item.count) }
        
        if order.discount > 0
          tr :class => "odd" do
            td I18n.t('active_admin.titles.order.discount'), :colspan => 4, :style => "text-align: right;"
            td number_to_percentage(order.discount, :precision => 0)
          end
        end

        tr :class => "odd" do
          td I18n.t('active_admin.titles.order.total_price'), :colspan => 4, :style => "text-align: right;"
          td number_to_currency(order.total_price_with_discount)
        end
      end

      form_tag add_good_admin_order_path(order) do
        text_field_tag(:good_articul) + 
        submit_tag(I18n.t('activerecord.actions.order.add_good'))
      end
    end

    panel I18n.t('active_admin.titles.order.info') do
      attributes_table_for order do
        row :created_at
        row :delivery_at
        row :checked_out_at
        row(:state) { 
          if order.state.blank?
            I18n.t("active_admin.scopes.unknown_order_state")
          else
            I18n.t("active_admin.scopes.#{order.state}") 
          end
        }
        row(:delivery_type) { I18n.t("active_admin.status_tags.order.#{order.delivery_type}") }
        row :address
        row :comment
      end
    end

    active_admin_comments
  end

  sidebar I18n.t('active_admin.titles.order.customer_information'), :only => :show do
    attributes_table_for order.customer do
      row(:name) { link_to order.customer.name, 
                           admin_customer_path(order.customer) }
      row :company
      row :phone
      row(:email) { link_to order.customer.email,
                            admin_customer_path(order.customer) }
      row :created_at
      row :first_order
    end
  end  
end
