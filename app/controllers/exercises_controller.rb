class ExercisesController < ApplicationController
  def exercise1
    # 注文されていないすべての料理を返す
    @foods = Food.left_outer_joins(:order_foods).where(order_foods: { id: nil })
  end

  describe "exercise2" do
    let(:food_ids) { Food.left_outer_joins(:order_foods).where(order_foods: { id: nil }).pluck(:id) }
    let(:shops) { Shop.joins(:foods).where(foods: { id: food_ids }).distinct }
  
    before do
      expect(Shop).to receive(:joins).and_call_original
      get :exercise2
    end
  
    it "注文されていない料理を提供しているすべてのお店が`@shops`に代入されていること" do
      expect(assigns(:shops)).to match_array shops
      expect(assigns(:shops).class.to_s).to eq "ActiveRecord::Relation"
    end
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
                  .first # limit(1)は不要
  
    # foods_price_sumメソッドを追加
    if @customer.present?
      @customer.define_singleton_method(:foods_price_sum) do
        orders.joins(:order_foods).sum('order_foods.price')
      end
    end
  end
end