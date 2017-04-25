module MessengerBot::Support::Logging

   extend ActiveSupport::Concern

   def log(string_or_hash)
     self.class.log(string_or_hash)
   end

   class_methods do

     def log(string_or_hash)
       sentence =
         string_or_hash.is_a?(Hash) ? string_or_hash.map{ |color, text| Pastel.new.send(color, text.to_s) }.join(" ") :
         string_or_hash.is_a?(String) ? string_or_hash :
         string_or_hash.inspect
       puts "#{Pastel.new.yellow("[#{Time.now.strftime("%T")}]")} #{sentence}" unless Rails.env.production?
       nil
     end

   end

end