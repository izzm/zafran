class SiteController < ApplicationController
  def index
    @page = StaticPage.find_by_link('index') || StaticPage.root
    set_meta(@page)
  end

  def static_page
    @page = StaticPage.find(params[:page_id])
    if @page.redirect_url.blank?
      set_meta(@page)
      
      template = @page.link
      begin
        logger.info "Try #{template} template ..."
        render :action => template
      rescue ActionView::MissingTemplate => e1
        logger.info "Use default StaticPage template"
      end
    else
      redirect_to @page.redirect_url
    end
  end

  def feedback
    data = params[:feedback]
    if data[:email].blank?
      flash[:error] = I18n.t('customer_email.not_email_present')
    else
      begin
        FeedbackMailer.customer_email(data).deliver
        FeedbackMailer.admin_email(data).deliver
  
        flash[:notice] = I18n.t("customer_email.delivery_success.#{data[:callback] ? 'callback' : 'email'}")
      rescue Exception => e
        flash[:error] = I18n.t('customer_email.delivery_error')

      end
    end

    redirect_to request.referrer
  end

end
