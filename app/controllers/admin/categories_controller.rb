class Admin::CategoriesController < ApplicationController
  include UploadToS3
  before_action :authenticate_admin!
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

    respond_to do |format|
      if @category.save
        upload_and_set_attr(category_params.dig(:thumbnail))

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
      folder_path = "#{Rails.env}/categories/#{@category.id}/#{Time.now.to_i}-#{file.original_filename}"
      upload_object = upload_to_s3(file, folder_path)
      params[:category][:thumbnail_url] = upload_object.public_url
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
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :thumbnail_url, :thumbnail)
    end

    def upload_and_set_attr(file)
      if file
        folder_path = "#{Rails.env}/categories/#{@category.id}/#{Time.now.to_i}-#{file.original_filename}"
        upload_object = upload_to_s3(file, folder_path)
        @category.update(thumbnail_url: upload_object.public_url) if upload_object
      end
    end
end
