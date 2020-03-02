require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @team = Team.new(name: 'Testers')
    @member = @team.members.new(
      name: 'justfortest',
      email: 'justfortest@gmail.com',
      role: 'visitor',
      password: 'justfortest',
      password_confirmation: 'justfortest',
    )
  end

  test "should be valid" do
    assert @member.valid?, "#{@member.errors.messages}"
  end
  
#================================== Test Name ==========================================#
  test "name should be present" do
    @member.name = "     "
    assert_not @member.valid?
  end
  
  test "name should not be too short" do
    @member.name = "a" * 1
    assert_not @member.valid?
  end
  
  test "name should not be too long" do
    @member.name = "a" * 51
    assert_not @member.valid?
  end
  
#================================= Test Email ============================================#
  test "email should be present" do
    @member.email = "     "
    assert_not @member.valid?
  end
  
  test "email should not be too short" do
    @member.email = "a" * 1 + "@a.fr"
    assert_not @member.valid?
  end
  
  test "email should not be too long" do
    @member.email = "a" * 250 + "@example.com"
    assert_not @member.valid?
  end
end
