# frozen_string_literal: true
require 'cpf_cnpj'

class CpfController < ApplicationController

  def index
    if params[:query].present?
      if valid_cpf?(params[:query])
        @cpfs = Cpf.search_by_cpf(params[:query])
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace('_top', partial: 'cpf_list') }
          format.html
        end
      else
        flash[:notice] = 'InvalidCpfException'
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace('_top', partial: 'cpf_list') }
          format.html
        end
      end
    else
      flash[:notice] = 'NotFoundCpfException'
      @cpfs = Cpf.distinct
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('_top', partial: 'cpf_list') }
        format.html
      end
    end
  end

  def show
    @cpf = Cpf.find(params[:id])
  end

  def new
    @cpf = Cpf.new
  end

  def create
    @cpf = Cpf.new(cpf_params)
    respond_to do |format|
      if @cpf.save
        index
      else
        @cpf.cpf = ''
        format.turbo_stream { render turbo_stream: turbo_stream.replace('create_cpf', partial: 'cpf'  ) }
      end

    end
  end

  def delete
  end

  private
  def valid_cpf?(cpf)
    CPF.valid?(cpf)
  end

  def cpf_params
    params.require(:cpf).permit(:cpf)
  end
end