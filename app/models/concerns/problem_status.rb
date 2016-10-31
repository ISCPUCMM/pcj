module ProblemStatus
  extend ActiveSupport::Concern

  included do
    enum status: { no_status: 0, pending: 1, accepted: 2, wa: 3, tle: 4, error: 5 }
  end
end
