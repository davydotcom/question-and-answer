ThinkingSphinx::Index.define :question, :with => :active_record do
  indexes subject, content
  indexes tags.name, :as => :tag_names
end
