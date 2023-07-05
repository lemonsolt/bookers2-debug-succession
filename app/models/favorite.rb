class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  # そのユーザーidにおいて、そのブックidには一度しか押せないよの意
  # つまり１冊に対し一人１ふぁぼの制限を付ける分
  validates_uniqueness_of :book_id, scope: :user_id
end
