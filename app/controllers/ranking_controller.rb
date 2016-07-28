class RankingController < ApplicationController
    def have
        # @haves = Have.limit(10).group('item_id').order('count_item_id desc').count('item_id').keys
        # @items = Item.find(@haves)
        # @item
        item_counts = Have.group(:item_id).order('count_id desc').limit(10).count(:id)
        @ranking = item_counts.transform_keys!{ |key| Item.find(key) }
    end
    
    def want
        # @wants = Want.limit(10).group('item_id').order('count_item_id desc').count('item_id').keys
        # @items = Item.find(@wants)
        # @item
        item_counts = Want.group(:item_id).order('count_id desc').limit(10).count(:id)
        @ranking = item_counts.transform_keys!{ |key| Item.find(key) }
    end
end
