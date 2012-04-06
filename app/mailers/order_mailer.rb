class OrderMailer < ActionMailer::Base
  default from: "Zafran <notifier@zafran.ru>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.customer_email.subject
  #
  def customer_email(customer, order)
    @order = order

    mail :to => customer.email,
         :subject => I18n.t('customer_email.order_subject')
  end
  
  def admin_email(order)
    @order = order
    
    mail :to => "vladislav.izoria@gmail.com",
         :subject => I18n.t('admin_email.order_subject')
  end
end
