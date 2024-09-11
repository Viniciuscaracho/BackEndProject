# frozen_string_literal: true
require 'cpf_cnpj'
include PgSearch::Model

class Cpf < ApplicationRecord
  before_validation :format_cpf
  validates :cpf, uniqueness: true, presence: true
  validate :validate_cpf
  validate :cpf_exists
  pg_search_scope :search_by_cpf,
                  against: [:cpf],
                  using: {
                    tsearch: { threshold: 0.3 }
                  }

  private

  def cpf_exists
    if Cpf.where(cpf: cpf).exists?
      errors.add(:cpf, "ExistsCpfException")
    end
  end

  def validate_cpf
    errors.add(:cpf, 'InvalidCpfException') unless valid_cpf?(cpf)
  end

  def valid_cpf?(cpf)
    CPF.valid?(cpf)
  end

  def format_cpf
    self.cpf = cpf_formatted if cpf.present?
  end

  def cpf_formatted
    cpf.gsub(/\D/, '') if cpf
  end
  def self.search_by_cpf(query)
    where(cpf: query.gsub(/\D/, ''))
  end
end