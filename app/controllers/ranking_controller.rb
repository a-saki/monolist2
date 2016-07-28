class RankingController < ApplicationController
    def have
        @haves = Have.limit(10).group('item_id').order('count_item_id desc').count('item_id').keys
        @items = Item.find(@haves)
        @item
    end
    
    def want
        @wants = Want.limit(10).group('item_id').order('count_item_id desc').count('item_id').keys
        @items = Item.find(@wants)
        @item
    end
end
