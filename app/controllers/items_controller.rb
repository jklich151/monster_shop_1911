class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.where(active?: true)
    end
    @topfive = Item.topfive.where(active?: true)
    @bottomfive = Item.bottomfive.where(active?: true)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    params[:item].delete_if {|attr, value| value.blank? }
    @item = @merchant.items.create(item_params)
    if @item.save
      flash[:notice] = "#{@item.name} is saved and ready for sale!"
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    params[:item].delete_if {|attr, value| value.blank? }
    @item.update(item_params)
    if @item.save
      flash[:notice] = "#{@item.name} has been edited!"
      redirect_to "/items/#{@item.id}"
    else
      # flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end


end
