class ItemsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]

  def new
    # q=検索ワード
    if params[:q]
      response = RakutenWebService::Ichiba::Item.search(
        keyword: params[:q],
        imageFlag: 1,
      )
      # APIから取得したデータを変数に格納
      @items = response.first(20)
    end
  end

  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
    item =  RakutenWebService::Ichiba::Item.search(itemCode: @item.item_code)
    @product = item.first
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
end
