require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)
	should have_many(:pending_user_friendships)
	should have_many(:pending_friends)
	should have_many(:requested_user_friendships)
	should have_many(:requested_friends)
	should have_many(:blocked_user_friendships)
	should have_many(:blocked_friends)
	should have_many(:activities)

	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:george).profile_name

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do
		#user = User.new
		#user.profile_name = "My Profile With Spaces"
		user = User.new(first_name: 'George', last_name: 'Petrov', email: 'jokopetrov@gmail.com')
		user.password = user.password_confirmation = 'jokojoko123'

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?('Must be formatted correctly.')

	end

	test "a user can have a correctly formated profile name" do
		user = User.new(first_name: 'George', last_name: 'Petrov', email: 'jokopetrov@gmail.com')
		user.password = user.password_confirmation = 'jokojoko123'


		user.profile_name = "Test123_-"
		assert user.invalid?
	end

	test "that no error is raised when trying to access a friend list" do
		assert_nothing_raised do
			users(:george).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:george).pending_friends << users(:emilly)
		users(:george).pending_friends.reload
		assert users(:george).pending_friends.include?(users(:emilly))
	end

	test "that calling to_param on a user returns the profile_name" do
		assert_equal "georgepetrov", users(:george).to_param
	end

  context "#has_blocked?" do
    should "return true if a user has blocked another user" do
      assert users(:george).has_blocked?(users(:blocked_friend))
    end

    should "return false if a user has not blocked another user" do
      assert !users(:george).has_blocked?(users(:ivelina))
    end
  end

  context "#create_activity" do
  	should "increase the Activity count" do
  		assert_difference 'Activity.count' do
	  		users(:george).create_activity(statuses(:one), 'created')
	  	end
  	end

  	should "set the targetable instance to the item passed in" do
  		activity = users(:george).create_activity(statuses(:one), 'created')
  		assert_equal statuses(:one), activity.targetable
  	end

  	should "increase the Activity count with an album" do
  		assert_difference 'Activity.count' do
	  		users(:george).create_activity(albums(:vacation), 'created')
	  	end
  	end

  	should "set the targetable instance to the item passed in with an album" do
  		activity = users(:george).create_activity(albums(:vacation), 'created')
  		assert_equal albums(:vacation), activity.targetable
  	end

  end
  
end









