class ExercisesController < ApplicationController
  def exercise1
    # 注文されていないすべての料理を返す
    @foods = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil })
  end

  def exercise2
    # 注文されていない料理を取得
    food_ids = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil }).pluck(:id)
  
    # 注文されていない料理を提供しているお店を取得
    @shops = Shop.joins(:foods).where(foods: { id: food_ids }).distinct
  end

  def exercise3 
    # 配達先の一番多い住所を返す
    @address = Address.joins(:orders)
                      .group('addresses.id')
                      .order('COUNT(orders.id) DESC')
                      .limit(1)
                      .first

    # orders_countメソッドを追加
    @address.define_singleton_method(:orders_count) do
      orders.size
    end if @address.present?
  end

  def exercise4 
    # 一番お金を使っている顧客を返す
    @customer = Customer
                  .joins(orders: { order_foods: :food }) # ハッシュで関連を指定
                  .select('customers.*, SUM(foods.price) AS total_price')
                  .group('customers.id')
                  .order('total_price DESC')
                  .first
  
    # foods_price_sumメソッドを追加
    if @customer.present?
      @customer.define_singleton_method(:foods_price_sum) do
        orders.joins(order_foods: :food).sum('foods.price')
      end
    end
  end
end