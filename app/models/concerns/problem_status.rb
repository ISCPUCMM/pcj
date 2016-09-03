module ProblemStatus
  extend ActiveSupport::Concern

  included do
    enum status: { pending: 0, accepted: 1, wa: 2, tle: 3, error: 4 }
  end
end
