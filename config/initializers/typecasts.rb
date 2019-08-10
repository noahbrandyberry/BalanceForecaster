module Typecasting
    module Date
      def cast_value v
        ::Date.strptime v, "%m/%d/%Y" rescue super
      end  
    end  
  
    ::ActiveRecord::Type::Date.prepend Date
  end