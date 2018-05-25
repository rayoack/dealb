# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin!

  def index
    @users = User.all

    @users_paginated = @users.page(params[:page])
  end

  def block
    user = User.find(params[:user_id])
    user.status = User::BLOCKED
    user.save!

    redirect_to users_path, notice: 'Successfully blocked'
  end

  def unblock
    user = User.find(params[:user_id])
    user.status = User::ACTIVE
    user.save!

    redirect_to users_path, notice: 'Successfully unblocked'
  end

  def become_user
    user = User.find(params[:user_id])
    user.role = User::USER
    user.save!

    redirect_to users_path, notice: 'Success'
  end

  def become_admin
    user = User.find(params[:user_id])
    user.role = User::ADMIN
    user.save!

    redirect_to users_path, notice: 'Success'
  end

  def become_moderator
    user = User.find(params[:user_id])
    user.role = User::MODERATOR
    user.save!

    redirect_to users_path, notice: 'Success'
  end

  private

  def only_admin!
    if current_user&.role != User::ADMIN
      flash[:error] = 'Unauthorized'
      redirect_to root_path
    end
  end
end
