class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :users_books, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :books, through: :users_books
  has_many :active_relationships, class_name:  Relationship.name,
                                  foreign_key: :follower_id,
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  Relationship.name,
                                   foreign_key: :followed_id,
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  enum role: [:user, :admin]
  mount_uploader :image, UserImageUploader
  validates :image, file_size: {less_than: 3.megabytes},
    file_content_type: {allow: ["image/jpeg", "image/png"]}

  def follow other_user
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include?(other_user)
  end
end
