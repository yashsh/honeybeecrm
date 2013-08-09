class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "234575867970068564141"

  require 'omniauth'

  before_filter :setsession

  private

  def setsession
    if session[:userid].nil?
      if current_user.nil?
        authenticate_user!
      else
        session[:userid] = current_user.id
      end
    end
  end

end

