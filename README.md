# rails_db_localize

Gem for managing translations of database objects without any pain

# Why I've made this gem?

In some translations project we used the globalize3 gem, but I wasn't really happy with it.
The most annoying part is globalize3 create a table for each object you want to translate.

I've made this gem with theses rules in head:

### 1/ Translation just in time.

You don't need to think about translation in your project until you begin the translation process.
`rails_db_localize` doesn't modify your database schematic but instead just add a layer on it.

### 2/ One table to bring them all.

`rails_db_localize` add only one table to your project. All your translations are stored inside this table.
This allow you to make without any pain a tool to manage a team of traductors for example. 

Since everything is in the same table, one controller is enough to manage the translation process!
About performance, `rails_db_localize` use some optimizations for fetching the rows (caching and hashing system).

### 3/ Only one query for all your translations

Thanks to the caching system, `rails_db_localize` need only one query to retrieve all the translations of your current view (see below)

# Installation

```Gemfile
gem 'rails_db_localize'
```

You need to create a migration also, and put this inside:

```ruby
  def change
    create_rails_db_localize_translations
  end
```

Note: the migration process is reversible

# Use of the gem

Then just declare the stuff you want to translate:

```ruby
  #in your model.rb
  has_translations :name, :comment #and everything you want...
```

Your code is still working the same way, but your model have now theses methods:

```ruby
  model.name_translated
  model.comment_translated
```

By default, `rails_db_localize` will use the I18n.locale to find the current locale. You can force to show a special locale:

```ruby
  model.name_translated(:fr)
```

To create a new translation, you can use the setter with it:

```ruby
  model.name_translated = "Name in current 'I18n.locale'"
```

or:

```ruby
  model.name_translated = "Name in french", :fr
```

# SQL Optimization

To avoid N+1 requests, please use the preloader on every array of models you want to use:

```ruby
    @translatables = Translatable.all
    @categories = Category.all
    #Only one request per preload_translations_for call
    preload_translations_for(@translatables, @categories)

    #If you have only one set of data, you can use the model method:
    @categories.preload_translations
```

# Other features

Each model having at least a translated field can use `missing_translation` and `having_translation`

Theses methods allow you to filters your models if they are translated or not.

### Blog case:

You have a blog with articles in two languages but you don't translate all articles.
To show articles from the current langage selected on your blog, you can use:

```ruby
  def index
    @articles = Articles.having_translation(I18n.locale).all
  end
```

### Other case:

You have a team of translators:
- One can translate from english to french
- Another one can translate from french to spanish

You just have to filters the articles in your translation tool like this:
```ruby
  Articles.having_translation(translator.from_language).missing_translation(translator.to_language)
```
Create two users with role translator with from/to_language "en/fr" and "fr/es". Et voilà!

# Changelog

## 0.3

* Fix issues inside the gem.

* Add the rake task rails_db_localize:delete_orphans

This task allow you to delete the old translations which not belongs to any model and/or belongs to a field/model which isn't existing anymore.

## 0.2

Add methods `having_translation`, `missing_translation` and `preload_translation`

## 0.1

First commit

# Licensing

Apache 2. Use it, fork it, have fun!

Happy coding!

