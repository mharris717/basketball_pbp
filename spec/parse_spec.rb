require 'rspec'

describe 'parse' do
  it 'smoke' do
    2.should == 2
  end
  let(:parser) do
    PbpFullParser.new
  end
  let(:raw_parsed_result) do
    parser.parse(raw_play.downcase)
  end
  let(:play) do
    BasketballPbp::Play.new(:line => raw_play)
  end
  let(:first_event) { play.events.first }
  let(:addl_event) { play.events[1] }
  describe "made free throw" do
    let(:raw_play) { "20111225BOSNYK  5 00:47:10  [BOS 1-0] Rondo Free Throw 1 of 2 (1 PTS)" }
    it 'should parse' do
      raw_parsed_result.should be
    end
    it 'has 1 event' do
      play.events.size.should == 1
    end
    it 'event has player' do
      play.events.first.player.should == 'rondo'
    end
    it 'has event type' do
      first_event.event_type.should == 'free throw'
    end
    it 'team' do
      first_event.team.should == 'bos'
    end
    it 'game' do
      first_event.game.should == '20111225BOSNYK'.downcase
    end
  end
  describe "missed free throw" do
    let(:raw_play) { "20111225BOSNYK  5 00:47:10  [BOS 1-0] Rondo Free Throw 2 of 2 Missed" }
    it 'should parse' do
      raw_parsed_result.should be
    end
    it 'made' do
      first_event.made.should == false
    end
  end
  describe "made 3" do
    let(:raw_play) { "20111225BOSNYK  26  00:45:07  [NYK 9-5] Fields 3pt Shot: Made (3 PTS) Assist: Anthony (1 AST)" }
    it 'should parse' do
      raw_parsed_result.should be
    end
    describe 'first event' do
      it 'player' do
        first_event.player.should == 'fields'
      end
      it 'event type' do
        first_event.event_type.should == '3pt shot'
      end
      it 'made' do
        first_event.made.should == true
      end
    end
    describe 'addl event' do
      it 'exists' do
        raw_parsed_result.ae.should be
      end
      it 'player' do
        addl_event.player.should == 'anthony'
      end
      it 'event type' do
        addl_event.event_type.should == 'assist'
      end
    end
  end
  describe 'steal' do
    let(:raw_play) { "20111225BOSNYK  30  00:44:14  [BOS] Allen Turnover : Bad Pass (2 TO) Steal:Stoudemire (1 ST)" }
    describe 'first event' do
      it 'should be turnover' do
        first_event.event_type.should == 'turnover'
      end
      it('player') { first_event.player.should == 'allen' }
      it('team') { first_event.team.should == 'bos' }
    end
    describe 'addl event' do
      it 'should be turnover' do
        addl_event.event_type.should == 'steal'
      end
      it('player') { addl_event.player.should == 'stoudemire' }
      it('team') { addl_event.team.should == 'nyk' }
    end
  end
  describe 'personal block' do
    let(:raw_play) { "20111225CHILAL  86  00:38:14  [LAL] Blake Foul: Personal Block (1 PF)" }
    describe 'first event' do
      it 'should be foul' do
        first_event.event_type.should == 'foul'
      end
    end
  end

  describe "test file parsing" do
    it 'parse' do
      lines = File.read("spec/test_pbp.txt").split("\n").map { |x| x.strip }[1...100]
      lines.reject { |line| parse_play(line) }[0...10].should == []
    end
  end


end