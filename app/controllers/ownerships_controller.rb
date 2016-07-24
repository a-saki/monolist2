class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:item_code] # DBにない場合はitem_codeが送られてくる。まだ登録されていないのでitem_idがない 
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
    else # すでにDBに保存されている場合はitem_idを送信（APIから送信するよりDBから直接探せるものはそっちの方が処理が早い） 
      @item = Item.find(params[:item_id])
    end


    # itemsテーブルに存在しない場合は楽天のデータを登録する。
    if @item.new_record?
      # TODO 商品情報の取得 RakutenWebService::Ichiba::Item.search を用いてください
      items = RakutenWebService::Ichiba::Item.search(itemCode: params[:item_code])

      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.item_code       = item['itemCode']
      @item.save!
    end
    
    
     

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
    
    if params[:type] == "Want"
      current_user.want(@item)
    else
      current_user.have(@item)
    end
    

  end

  def destroy
    @item = Item.find(params[:item_id])
    if params[:type] == "Want"
      current_user.unwant(@item)
    else
      current_user.unhave(@item)
    end
    
    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。

  end
end
