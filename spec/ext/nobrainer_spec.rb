require 'spec_helper'

RSpec.describe "AwesomePrint/NoBrainer", skip: ->{ !ExtVerifier.has_nobrainer? }.call do

  if ExtVerifier.has_nobrainer?
    before :all do
      NoBrainer.configure
    end

    before :all do
      class SomeModel
        include NoBrainer::Document

        field :first_name, :type => String
        field :last_name,  :type => String
        field :some_field
      end
    end

    after :all do
      Object.instance_eval{ remove_const :SomeModel }
    end
  end

  before do
    stub_dotfile!
    @ap = AwesomePrint::Inspector.new :plain => true
  end

  it "should print class instance" do
    user = SomeModel.new :first_name => "Al", :last_name => "Capone"
    out = @ap.send :awesome, user

    object_id = user.id.inspect
    str = <<-EOS.strip
#<SomeModel id: #{object_id}> {
            :id => #{object_id},
    :first_name => "Al",
     :last_name => "Capone"
}
    EOS
    expect(out).to eq(str)
  end

  it "should print the class" do
    class_spec = <<-EOS.strip
class SomeModel < Object {
            :id => :string,
    :first_name => :string,
     :last_name => :string,
    :some_field => :object
}
                   EOS

    expect(@ap.send(:awesome, SomeModel)).to eq class_spec
  end
end
