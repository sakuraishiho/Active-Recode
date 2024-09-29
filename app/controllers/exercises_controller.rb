class ExercisesController < ApplicationController
  def exercise1
    # 注文されていないすべての料理を返す
    @foods = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil })
  end

  def exercise2
    # 注文されていない料理を提供しているすべてのお店を返す
    # まず、注文されていない料理を取得
    food_ids = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil }).pluck(:id)
    
    # 次に、それらの料理を提供しているお店を取得
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
                    .joins(orders: :order_foods)
                    .select('customers.*, SUM(order_foods.price) AS total_price')
                    .group('customers.id')
                    .order('total_price DESC')
                    .limit(1)
                    .first

    # foods_price_sumメソッドを追加
    @customer.define_singleton_method(:foods_price_sum) do
      orders.includes(:order_foods).sum('order_foods.price')
    end if @customer.present?
  end
end