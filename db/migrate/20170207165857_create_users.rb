class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :fb_uid
      t.string :fb_gender
      t.string :fb_timezone
      t.string :fb_locale
      t.string :fb_profile_pic
      t.string :fb_last_name
      t.string :fb_first_name
      t.datetime :last_answer_at

      t.timestamps
    end
  end
end
