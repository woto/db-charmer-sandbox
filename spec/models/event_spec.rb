require 'spec/spec_helper'

describe Event, "sharded model" do
  fixtures :event_shards_info, :event_shards_map

  it "should respond to shard_for method" do
    Event.should respond_to(:shard_for)
  end

  it "should correctly switch shards" do
    # Cleanup sharded tables
    Event.on_each_shard { |event| event.delete_all }

    # Check that they are empty
    Event.shard_for(2).all.should be_empty
    Event.shard_for(12).all.should be_empty

    # Create some data (one record in each shard
    Event.shard_for(2).create!(
      :from_uid => 1,
      :to_uid => 2,
      :original_created_at => Time.now,
      :event_type => 1,
      :event_data => 'foo'
    )
    Event.shard_for(12).create!(
      :from_uid => 1,
      :to_uid => 12,
      :original_created_at => Time.now,
      :event_type => 1,
      :event_data => 'bar'
    )

    # Check sharded tables to make sure they have the data
    Event.shard_for(2).find_all_by_from_uid(1).map(&:event_data).should == [ 'foo' ]
    Event.shard_for(12).find_all_by_from_uid(1).map(&:event_data).should == [ 'bar' ]
  end

  it "should allocate new blocks when needed" do
    # Cleanup sharded tables
    Event.on_each_shard { |event| event.delete_all }

    # Check new block, it should be empty
    Event.shard_for(100).count.should be_zero

    # Create an object
    Event.shard_for(100).create!(
      :from_uid => 1,
      :to_uid => 100,
      :original_created_at => Time.now,
      :event_type => 1,
      :event_data => 'blah'
    )

    # Check the new block
    Event.shard_for(100).count.should == 1
  end
end
