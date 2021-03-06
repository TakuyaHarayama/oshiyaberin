class ThreadsController < ApplicationController
  def index
  end

  # 非同期で初期リストをUIDから取得する処理
  def ajax_list
    session[:uid] = ''
    if !params[:uid]
      render :json => ''
      return
    end
    session[:uid] = params[:uid]

    messages = Message.where(:uid => session[:uid])
    render :json => messages
  end

  # 非同期メッセージ人工知能API送受信処理
  def ajax_post
    if !params[:inputText] || !session[:uid] ||
      params[:inputText].empty? || session[:uid].empty?
      render :json => ''
      return
    end

    # APIコール
    result = get_ai_response(Settings.BOT_API_URL, Settings.BOT_API_KEY, params[:inputText])
    if result["status"].nil? || result["status"] == 'error'
        render :json => [I18n.t('errors.messages.bot_api')], status: :unprocessable_entity
        return
    end

    message = Message.new()
    message[:input_text] = params[:inputText]
    message[:res_text] = result["result"]
    message[:res_status] = result["status"]
    message[:uid] = session[:uid]

    ActiveRecord::Base.transaction do
      if !message.save
        render :json => message.errors.full_messages, status: :unprocessable_entity
        raise ActiveRecord::Rollback
        return
      else
        render :json => message
      end
    end

  end

  private

  # 人工知能APIコール
  # @param [String] uri APIのURL
  # @param [String] key APIキー
  # @param [String] message APIに渡すメッセージ
  # @return [Hash] json hash
  def get_ai_response(uri, key, message)
    api_response = HTTParty.get(uri, :query => {:key => key, :message => message})
    json_hash = api_response.parsed_response
    return json_hash
  end

end
