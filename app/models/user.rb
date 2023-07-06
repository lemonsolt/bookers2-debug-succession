class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # ここからフォローフォロワー関係
  has_many :relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :followers, through: :relationships, source: :followed

  has_many :reverse_of_relationships, class_name: 'Relationship',foreign_key: :followed_id
  has_many :followeds, through: :reverse_of_relationships, source: :follower
  # ここまで
  # ここからDM関連
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms,through: :user_rooms
  # ここまで
  has_many :view_counts, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length:{ minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum:50}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end


  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

  # def follow(other_user)
  #   active_relationships.build(followed_id: other_user.id)
  # end

  # def unfollow(other_user)
  #   active_relationships.find_by(followed_id: other_user.id).destroy
  # end

  def following?(other_user)
    followeds.include?(other_user)
  end
end
