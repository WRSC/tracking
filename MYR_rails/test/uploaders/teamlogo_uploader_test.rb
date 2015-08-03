=begin
require 'carrierwave/test/matchers'

test TeamlogoUploader do
  include CarrierWave::Test::Matchers

  before do
    MyUploader.enable_processing = true
    @uploader = MyUploader.new(@team, :logo)

    File.open(path_to_file) do |f|
      @uploader.store!(f)
    end
  end

  after do
    MyUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the small version' do
    it "should scale down a landscape image to be exactly 50 by 50 pixels" do
      @uploader.small.should have_dimensions(50, 50)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 200 by 200 pixels" do
      @uploader.small.should be_no_larger_than(200, 200)
    end
  end

  it "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0600)
  end
end
=end
