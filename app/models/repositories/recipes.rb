# frozen_string_literal: true

module CodePraise
  module Repository
    # Repository for Recipes
    class Recipes
      def self.find_id(myId)
        rebuild_entity Database::RecipeOrm.first(id: myId)
      end

      def self.find_title(myTitle)
        rebuild_entity Database::RecipeOrm.title(title: myTitle)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Recipe.new(
          id: db_record.id,
          title: db_record.title,
          ingredients: db_record.ingredients
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_recipe|
          Recipes.rebuild_entity(db_recipe)
        end
      end

      def self.db_find_or_create(entity)
        Database::Recipes.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
