class CategoriesController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(name: category_params.dig(:name))

    if category_params.dig(:thumbnail)
      file = category_params.dig(:thumbnail)
      folder_path = "#{Rails.env}/categories/#{Time.now.to_i}-#{file.original_filename}"
      image_url = upload_to_s3(file, folder_path)
      @category.thumbnail_url = image_url
    end

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    if category_params.dig(:thumbnail)
      file = category_params.dig(:thumbnail)
      folder_path = "#{Rails.env}/categories/#{Time.now.to_i}-#{file.original_filename}"
      image_url = upload_to_s3(file, folder_path)
      params[:category][:thumbnail_url] = image_url
      params[:category].delete(:thumbnail)
    end

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :thumbnail_url, :thumbnail)
    end

    def authenticate_admin
      unless current_user.admin?
        redirect_to root_path, notice: 'You are not authorized to perform this action'
      end
    end
end
