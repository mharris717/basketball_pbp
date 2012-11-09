require 'rspec'

describe 'sub parse' do
  let(:parser) do
    PbpFullParser.new
  end
  let(:raw_parsed_result) do
    parser.parse(raw_play.downcase)
  end
  let(:play) do
    BasketballPbp::Play::Full.new(:line => raw_play)
  end
  let(:first_event) { play.events.first }
  let(:addl_event) { play.events[1] }
  
  if true
    describe "substitution" do
      let(:raw_play) { "20111225BOSNYK	68	00:40:35	[NYK] Fields Substitution replaced by Walker" }
      describe 'first event' do
        it 'should be sub_out' do
          first_event.event_type.should == 'sub_out'
        end
        it 'should be Fields' do
          first_event.player.should == 'fields'
        end
        it 'should be NYK' do
          first_event.team.should == 'NYK'
        end
      end
      describe 'addl event' do
        it 'should be sub_out' do
          addl_event.event_type.should == 'sub_in'
        end
        it 'should be Fields' do
          addl_event.player.should == 'walker'
        end
        it 'should be NYK' do
          addl_event.team.should == 'NYK'
        end
      end
    end
  end
  
  describe 'sub' do
    let(:raw_play) { "Fields Substitution replaced by Walker" }
    let(:parser) { SubstitutionParser.new }
    it 'parses' do
      raw_parsed_result.should be
    end
    describe 'first event' do
      it 'has player out' do
        raw_parsed_result.first_event.player.text_value.should == 'fields'
      end
      it 'has sub_out' do
        raw_parsed_result.first_event.event_type.text_value.should == 'sub_out'
      end
    end
    describe 'addl event' do
      it 'has player in' do
        raw_parsed_result.ae.player.text_value.should == 'walker'
      end
      it 'has sub_in' do
        raw_parsed_result.ae.event_type.text_value.should == 'sub_in'
      end
    end
  end
  
  describe 'sub2' do
    let(:raw_play) { "20111225BOSNYK	68	00:40:35	[NYK] Fields Substitution replaced by Walker" }
    it 'parses' do
      raw_parsed_result.should be
    end
    describe 'first event' do
      it 'has player out' do
        raw_parsed_result.first_event.player.text_value.should == 'fields'
      end
      it 'has sub_out' do
        raw_parsed_result.first_event.event_type.text_value.should == 'sub_out'
      end
    end
    describe 'addl event' do
      it 'has player in' do
        raw_parsed_result.ae.player.text_value.should == 'walker'
      end
      it 'has sub_in' do
        raw_parsed_result.ae.event_type.text_value.should == 'sub_in'
      end
    end
  end
  
end