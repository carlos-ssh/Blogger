class Article < ActiveRecord::Base
  has_many :content
  has_many :summary
  has_many :title
  has_many :tag_list
  has_many :tags

  has_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  validates_associated :tag_list
  before_save :save_tags

  def tag_list
    caller[0][/`([^']*)'/, 1] == 'block in validate' ? @tag_list : tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    @tag_list = names.split(",").map do |n|
      #self.tags.find_or_initialize_by_name(name: n.strip) #uncomment this if you want invalid tags to show in tag list
      Tag.find_or_initialize_by_name(name: n.strip)
    end
  end

  private

  def save_tags
    self.tags = Tag.transaction do
      @tag_list.each(&:save)
    end
  end
end
