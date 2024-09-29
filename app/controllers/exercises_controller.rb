class ExercisesController < ApplicationController
  def exercise1
    # 注文されていないすべての料理を返す
    @foods = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil })
  end

  def exercise2
    # 注文されていない料理を提供しているすべてのお店を返す
    # まず、注文されていない料理を取得
    foods = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil })
    
    # 次に、それらの料理を提供しているお店を取得
    @shops = Shop.left_outer_joins(:foods).where(foods: { id: foods.pluck(:id) })
  end

  def exercise3 
    # 配達先の一番多い住所を返す
    @address = Address.joins(:orders)
                      .group('addresses.id')
                      .order('COUNT(orders.id) DESC')
                      .limit(1)
                      .first
  end

  def exercise4 
    # 一番お金を使っている顧客を返す
    @customer = Customer.joins(:orders)
                        .select('customers.*, SUM(order_foods.price) AS total_price')
                        .joins(orders: :order_foods)
                        .group('customers.id')
                        .order('total_price DESC')
                        .limit(1)
                        .first
  end
end