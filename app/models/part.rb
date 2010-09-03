class Part < ActiveRecord::Base
  db_magic :sharded => {
    :key => :code,
    :sharded_connection => :something
  }
end
