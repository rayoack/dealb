# frozen_string_literal: true

class MarketsController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin!

  def index
    @markets = Market.all

    @markets_paginated = @markets.page(params[:page])
  end

  def new
    @market = Market.new
  end

  def create
    @market = Market.new(resource_params)

    if @market.save
      redirect_to markets_path, notice: 'Successfully created'
    else
      render :new
    end
  end

  def edit
    @market = Market.find(params[:id])
  end

  def update
    @market = Market.find(params[:id])

    if @market.update(resource_params)
      redirect_to markets_path, notice: 'Successfully updated'
    else
      render :new
    end
  end

  private

  def resource_params
    params.require(:market).permit(:name)
  end

  def only_admin!
    return unless current_user&.role != User::ADMIN

    flash[:error] = 'Unauthorized'
    redirect_to root_path
  end
end
