class Todo < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  validates_presence_of :name

  def name_only?
    description.blank?
  end

  def display_text
    name + tag_text
  end

  def save_with_tags
    if save
      create_location_tags
      true
    else
      false
    end
  end

  def self.search_by_name(search_term)
    return [] if search_term.blank?
    where("name LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  private

  def create_location_tags
    location_string = name.slice(/.*\bAT\b(.*)/, 1).try(:strip)
      if location_string
        locations = location_string.split(/\,|and/).map(&:strip)
        locations.each do |location|
          tags.create(tag: "location:#{location}")
        end
      end
  end

  def tag_text
    if tags.any?
    " (#{tags.one? ? 'tag:' : 'tags:'} #{tags.map(&:tag).first(4).join(", ")}#{', more...' if tags.count > 4})"
    else
      ""
    end
  end
  
end