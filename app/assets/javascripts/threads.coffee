# サーバーから受信したエラーメセージを取得する
#
# @param [String] 配列形式のエラーメッセージjson文字列
# @return [String] エラーメッセージ
getErrMessage = (responseText) ->
  if !responseText?
    return ''

  messages = JSON.parse(responseText)
  message = ''
  for val, i in messages
    message += val

  return message

# サーバーサイドから人工知能ボットAPIに
# リクエストを送信して結果取得する
#
send = ->
  inputText = $('#js-input-text').val()
  if !inputText? || inputText == ''
    return

  $('#js-input-text').attr('disabled', true)

  $.ajax '/threads/ajax_post',
    type: 'POST'
    data : { inputText: inputText }
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      if jqXHR.responseText?
        alert getErrMessage(jqXHR.responseText)
      else
        alert '予期せぬエラーが発生しました'

      $('#js-input-text').attr('disabled', false)
      $('#js-input-text').focus()
    success: (data, textStatus, jqXHR) ->
      $('#js-input-text').val('')
      displayResponse data
      $('#js-input-text').attr('disabled', false)
      # debug
      console.log data

# UID生成
#
# @param [Integer] UID生成文字数
# @return [String] UID生成文字列
#
generateId = (len) ->
   result = ''
   for i in [1..len]
     chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
     result += chars.substr Math.floor(Math.random() * chars.length), 1

    return result

# Railsのtime型を YYYY-mm-dd hh:mi:ss にフォーマット
#
# @param [String] Rails time型 文字列
# @return [String] フォーマット文字列 (YYYY-mm-dd hh:mi:ss)
#
getDatetimeStr = (dateStr) ->
  dateStr = dateStr.replace('T', ' ')
  return dateStr.substr(0, 19)

# メッセージ行表示
#
# @param [Array] メッセージ行データ
# @param [Boolean] 最終行: true, 最終行以外: false
# @param [Boolean] 追加行: true, 追加行以外: false
#
displayResponse = (record) ->
  $('#first').css 'background-image', "url('/assets/chara_01.png')"
  $('.admin').css 'display', 'block'
  $('.user').css 'display', 'none'

  # ここで文字を<span></span>で囲む
  $('.tgt').text(record.res_text)
  $('.tgt').children().andSelf().contents().each ->
    if @nodeType == 3
      $(this).replaceWith $(this).text().replace(/(\S)/g, '<span>$1</span>')
    return
  # 一文字ずつフェードインさせる
  $('.tgt').css 'opacity': 1
  i = 0
  while i <= $('.tgt').children().size()
    $('.tgt').children('span:eq(' + i + ')').delay(50 * i).animate { 'opacity': 1 }, 50
    i++
  $('.tgt').append('<img class="sankaku" src="/assets/sankaku.png" />')
  addLogData record

addLogData = (record) ->
  if !record?
    return

  html = ''
  html += '<p>'
  html += '<span>[あなた]</span>'
  html += record.input_text
  html += '</p>'
  html += '<p>'
  html += '<span>[鷲中宮　駅子]</span>'
  html += record.res_text
  html += '</p>'
  html += '<hr>'

  $('#js-log-text').append(html)

# メッセージリスト表示
#
# @param [Array] メッセージリストデータ
#
setLogData = (results) ->
  $('#js-log-text').html('')
  if !results?
    return

  html = ''
  for i in [0..results.length - 1]
    html += '<p>'
    html += '<span>[あなた]</span>'
    html += results[i].input_text
    html += '</p>'
    html += '<p>'
    html += '<span>[鷲中宮　駅子]</span>'
    html += results[i].res_text
    html += '</p>'
    html += '<hr>'

  $('#js-log-text').append(html)

$ ->
  # クッキーからUID取得(なければ生成)
  uid = $.cookie('uid')
  if !uid?
    uid = generateId(20)
    $.cookie('uid', uid, { expires: 30 });

  # 初期メッセージリスト非同期取得表示
  $.ajax '/threads/ajax_list',
    type: 'GET'
    data : { uid: uid }
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      alert "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      if !data?
        return

      # ログに書き込む処理
      setLogData data

  # メッセージ入力テキストでEnterキー送信
  $('#js-input-submit').on 'click', (event) ->
    send()
    return false
