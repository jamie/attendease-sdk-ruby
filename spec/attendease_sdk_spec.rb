$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'attendease_sdk'

describe AttendeaseSDK::Presenter do

  let!(:presenter){AttendeaseSDK::Presenter.new(first_name: "first_name", last_name: "last_name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Presenter.stub(:new).and_return(AttendeaseSDK::Presenter.new(first_name: "first_name", last_name: "last_name"))
      presenter.stub(:parsed_response).and_return(presenter)
    end

    context 'with existing presenters' do

      before do
        HTTParty.stub(:get).and_return(presenter)
        presenter.stub(:code).and_return(200)
      end

      it 'returns a presenter object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Presenter.retrieve("presenter_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(presenter.parsed_response)
        presenter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.retrieve("presenter_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(presenter.parsed_response)
        presenter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.retrieve("presenter_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      HTTParty.stub(:get).and_return(presenter)
      presenter.stub(:parsed_response).and_return(presenter)
      presenter.stub(:code).and_return(200)
    end

    context 'when .list is called' do
      it 'returns all presenters by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Presenter.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(presenter)
        presenter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(presenter)
        presenter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before :each do
      HTTParty.stub(:post).and_return(presenter)
      AttendeaseSDK::Presenter.stub(:new).and_return(presenter)
      presenter.stub(:parsed_response).and_return(presenter)
    end

    context 'when .create is called'  do
      before do
        presenter.stub(:code).and_return(201)
      end

      it 'creates a presenter and returns a presenter object' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        AttendeaseSDK::Presenter.create("presenter_hash")
      end
    end

    context 'when it fails due to a connection error' do
      before do
        presenter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        expect { AttendeaseSDK::Presenter.create("presenter_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do
      before do
        presenter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        expect { AttendeaseSDK::Presenter.create("presenter_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      HTTParty.stub(:put).and_return(presenter)
      AttendeaseSDK::Presenter.stub(:new).and_return(presenter)
      presenter.stub(:parsed_response).and_return(presenter)
    end

    context 'when .update is called' do
      before do
        presenter.stub(:code).and_return(204)
      end

      it 'updates presenters by hash of presenter attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        AttendeaseSDK::Presenter.update("presenter_hash")
      end
    end

    context 'when it fails due to a connection error' do
      before do
        presenter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        expect { AttendeaseSDK::Presenter.update("presenter_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do
      before do
        presenter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/.json", :headers => AttendeaseSDK.admin_headers, :body => "presenter_hash".to_json)
        expect { AttendeaseSDK::Presenter.update("presenter_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      HTTParty.stub(:delete).and_return(presenter)
      presenter.stub(:parsed_response).and_return(presenter)
    end

    context 'destroys a presenter' do
      before do
        presenter.stub(:code).and_return(204)
      end

      it 'destroys a presenter by presenter id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Presenter.destroy("presenter_id")
      end
    end

    context 'when it fails due to a connection error' do
      before do
        presenter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.destroy("presenter_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do
      before do
        presenter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/presenters/presenter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Presenter.destroy("presenter_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end
end

describe AttendeaseSDK::SponsorLevel do

  let!(:sponsor_level){AttendeaseSDK::SponsorLevel.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::SponsorLevel.stub(:new).and_return(AttendeaseSDK::SponsorLevel.new(name: "sponsor_name"))
      sponsor_level.stub(:parsed_response).and_return(sponsor_level)
    end

    context 'with existing sponsors' do

      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(200)
      end

      it 'returns a sponsor level object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::SponsorLevel.retrieve("sponsor_level_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.retrieve("sponsor_level_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor_level.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.retrieve("sponsor_level_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::SponsorLevel.stub(:new).and_return(AttendeaseSDK::SponsorLevel.new(name: "sponsor_name"))
      sponsor_level.stub(:parsed_response).and_return(sponsor_level)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(200)
      end

      it 'returns all sponsor_levels by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::SponsorLevel.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor_level.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end


  end

  describe '.create' do

    before do
      AttendeaseSDK::SponsorLevel.stub(:new).and_return(AttendeaseSDK::SponsorLevel.new(name: "sponsor_name"))
      sponsor_level.stub(:parsed_response).and_return(sponsor_level)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(sponsor_level)
        AttendeaseSDK::Presenter.stub(:new).and_return(sponsor_level)
        sponsor_level.stub(:parsed_response).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(201)
      end

      it 'creates a sponsor level and returns a sponsor level hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        result = AttendeaseSDK::SponsorLevel.create("sponsor_level_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        expect { AttendeaseSDK::SponsorLevel.create("sponsor_level_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor_level.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        expect { AttendeaseSDK::SponsorLevel.create("sponsor_level_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::SponsorLevel.stub(:new).and_return(AttendeaseSDK::SponsorLevel.new(name: "sponsor_name"))
      sponsor_level.stub(:parsed_response).and_return(sponsor_level)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(sponsor_level)
        AttendeaseSDK::Presenter.stub(:new).and_return(sponsor_level)
        sponsor_level.stub(:parsed_response).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(204)
      end

      it 'updates sponsor_levels by hash of sponsor level attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        AttendeaseSDK::SponsorLevel.update("sponsor_level_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        expect { AttendeaseSDK::SponsorLevel.update("sponsor_level_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor_level.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_level_hash".to_json)
        expect { AttendeaseSDK::SponsorLevel.update("sponsor_level_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::SponsorLevel.stub(:new).and_return(AttendeaseSDK::SponsorLevel.new(name: "sponsor_name"))
      sponsor_level.stub(:parsed_response).and_return(sponsor_level)
    end

    context 'destroys a sponsor' do
      before do
        HTTParty.stub(:delete).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(204)
      end

      it 'destroys a sponsor by sponsor id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::SponsorLevel.destroy("sponsor_level_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.destroy("sponsor_level_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(sponsor_level)
        sponsor_level.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor_level.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsor_levels/sponsor_level_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::SponsorLevel.destroy("sponsor_level_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

end

describe AttendeaseSDK::Sponsor do

  let!(:sponsor){AttendeaseSDK::Sponsor.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Sponsor.stub(:new).and_return(AttendeaseSDK::Sponsor.new(name: "sponsor_name"))
      sponsor.stub(:parsed_response).and_return(sponsor)
    end

    context 'with existing sponsors' do
      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(200)
      end

      it 'returns a sponsor object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Sponsor.retrieve("sponsor_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.retrieve("sponsor_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.retrieve("sponsor_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.list' do

    before do
      AttendeaseSDK::Sponsor.stub(:new).and_return(AttendeaseSDK::Sponsor.new(name: "sponsor_name"))
      sponsor.stub(:parsed_response).and_return(sponsor)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(200)
      end

      it 'returns all sponsors by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Sponsor.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(sponsor)
        sponsor.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Sponsor.stub(:new).and_return(AttendeaseSDK::Sponsor.new(name: "sponsor_name"))
      sponsor.stub(:parsed_response).and_return(sponsor)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(sponsor)
        sponsor.stub(:code).and_return(201)
      end

      it 'creates a sponsor and returns a sponsor hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        AttendeaseSDK::Sponsor.create("sponsor_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(sponsor)
        sponsor.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        expect { AttendeaseSDK::Sponsor.create("sponsor_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(sponsor)
        sponsor.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        expect { AttendeaseSDK::Sponsor.create("sponsor_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Sponsor.stub(:new).and_return(AttendeaseSDK::Sponsor.new(name: "sponsor_name"))
      sponsor.stub(:parsed_response).and_return(sponsor)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(sponsor)
        sponsor.stub(:code).and_return(204)
      end

      it 'updates sponsors by hash of sponsor attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        result = AttendeaseSDK::Sponsor.update("sponsor_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(sponsor)
        sponsor.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        expect { AttendeaseSDK::Sponsor.update("sponsor_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(sponsor)
        sponsor.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/.json", :headers => AttendeaseSDK.admin_headers, :body => "sponsor_hash".to_json)
        expect { AttendeaseSDK::Sponsor.update("sponsor_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Sponsor.stub(:new).and_return(AttendeaseSDK::Sponsor.new(name: "sponsor_name"))
      sponsor.stub(:parsed_response).and_return(sponsor)
    end

    context 'destroys a sponsor' do

      before do
        HTTParty.stub(:delete).and_return(sponsor)
        sponsor.stub(:code).and_return(204)
      end

      it 'destroys a sponsor by sponsor id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Sponsor.destroy("sponsor_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(sponsor)
        sponsor.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.destroy("sponsor_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(sponsor)
        sponsor.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        sponsor.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sponsors/sponsor_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Sponsor.destroy("sponsor_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end

# describe AttendeaseSDK::Session do
#
#   let!(:session){AttendeaseSDK::Session.new(name: "name")}
# #
#   before :each do
#     AttendeaseSDK.user_token = "my_token"
#     AttendeaseSDK.event_id = "my_event_id"
#     AttendeaseSDK.environment = "development"
#     AttendeaseSDK.event_subdomain = "subdomaintest"
#   end
#
#   describe '.retrieve', focus: true do
#
#     before do
#       AttendeaseSDK::Session.stub(:new).and_return(session)
#       session.stub(:parsed_response).and_return(session)
#     end
#
#     context 'with existing sessions' do
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(200)
#       end
#
#       it 'returns a session object' do
#         HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         result = AttendeaseSDK::Session.retrieve("session_id")
#       end
#     end
#
#     context 'when it fails due to a connection error' do
#
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(404)
#         AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
#       end
#
#       it 'raises an error' do
#         response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.retrieve("session_id") }.to raise_error(AttendeaseSDK::ConnectionError)
#       end
#     end
#
#     context 'when it fails due to a domain error' do
#
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(422)
#         AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
#         presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
#       end
#
#       it 'raises an error' do
#         response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.retrieve("session_id") }.to raise_error(AttendeaseSDK::DomainError)
#       end
#     end
#   end
#
#   describe '.list' do
#
#     before do
#       AttendeaseSDK::Session.stub(:new).and_return(AttendeaseSDK::Session.new(name: "session_name"))
#       session.stub(:parsed_response).and_return(session)
#     end
#
#     context 'when .list is called' do
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(200)
#       end
#
#       it 'returns all sessions by event id' do
#         HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers)
#         AttendeaseSDK::Session.list
#       end
#     end
#
#     context 'when it fails due to a connection error' do
#
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(404)
          # AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
#       end
#
#       it 'raises an error' do
#         response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.list }.to raise_error(AttendeaseSDK::ConnectionError)
#       end
#     end
#
#     context 'when it fails due to a domain error' do
#
#       before do
#         HTTParty.stub(:get).and_return(session)
#         session.stub(:code).and_return(422)
          # AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
          # presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
#       end
#
#       it 'raises an error' do
#         response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.list }.to raise_error(AttendeaseSDK::DomainError)
#       end
#     end
#
#   end
#
#   describe '.create' do
#
#     before do
#       AttendeaseSDK::Session.stub(:new).and_return(AttendeaseSDK::Session.new(name: "session_name"))
#       session.stub(:parsed_response).and_return(session)
#     end
#
#     context 'when .create is called' do
#       before do
#         HTTParty.stub(:post).and_return(session)
#         session.stub(:code).and_return(201)
#       end
#
#       it 'creates a session and returns a session hash' do
#         HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         AttendeaseSDK::Session.create("session_hash")
#       end
#     end
#
#     context 'when it fails due to a connection error' do
#
#       before do
#         HTTParty.stub(:post).and_return(session)
#         session.stub(:code).and_return(404)
          # AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         expect { AttendeaseSDK::Session.create("session_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
#       end
#     end
#
#     context 'when it fails due to a domain error' do
#
#       before do
#         HTTParty.stub(:post).and_return(session)
#         session.stub(:code).and_return(422)
          # AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
          # presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         expect { AttendeaseSDK::Session.create("session_hash") }.to raise_error(AttendeaseSDK::DomainError)
#       end
#     end
#   end
#
#   describe '.update' do
#
#     before do
#       # AttendeaseSDK::Session.new(name: "session_name")
#       AttendeaseSDK::Session.stub(:new).and_return(session)
#       session.stub(:parsed_response).and_return(session)
#     end
#
#     context 'when .update is called' do
#       before do
#         HTTParty.stub(:put).and_return(session)
#         session.stub(:code).and_return(204)
#       end
#
#       it 'updates sessions by hash of session attributes' do
#         HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         result = AttendeaseSDK::Session.update("session_hash")
#       end
#     end
#
#     context 'when it fails due to a connection error' do
#
#       before do
#         HTTParty.stub(:put).and_return(session)
#         session.stub(:code).and_return(404)
# AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         expect { AttendeaseSDK::Session.update("session_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
#       end
#     end
#
#     context 'when it fails due to a domain error' do
#
#       before do
#         HTTParty.stub(:put).and_return(session)
#         session.stub(:code).and_return(422)
# AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
# presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/.json", :headers => AttendeaseSDK.admin_headers, :body => "session_hash".to_json)
#         expect { AttendeaseSDK::Session.update("session_hash") }.to raise_error(AttendeaseSDK::DomainError)
#       end
#     end
#   end
#
#   describe '.destroy' do
#
#     before do
#       AttendeaseSDK::Session.stub(:new).and_return(AttendeaseSDK::Session.new(name: "session_name"))
#       session.stub(:parsed_response).and_return(session)
#     end
#
#     context 'destroys a session' do
#
#       before do
#         HTTParty.stub(:delete).and_return(session)
#         session.stub(:code).and_return(204)
#       end
#
#       it 'destroys a session by session id' do
#         HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         result = AttendeaseSDK::Session.destroy("session_id")
#       end
#     end
#
#     context 'when it fails due to a connection error' do
#
#       before do
#         HTTParty.stub(:delete).and_return(session)
#         session.stub(:code).and_return(404)
# AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.destroy("session_id") }.to raise_error(AttendeaseSDK::ConnectionError)
#       end
#     end
#
#     context 'when it fails due to a domain error' do
#
#       before do
#         HTTParty.stub(:delete).and_return(session)
#         session.stub(:code).and_return(422)
# AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
# presenter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
#       end
#
#       it 'raises an error' do
#         HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id.json", :headers => AttendeaseSDK.admin_headers)
#         expect { AttendeaseSDK::Session.destroy("session_id") }.to raise_error(AttendeaseSDK::DomainError)
#       end
#     end
#   end
# end

describe AttendeaseSDK::Attendee do

  let!(:attendee){AttendeaseSDK::Attendee.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Attendee.stub(:new).and_return(AttendeaseSDK::Attendee.new(name: "attendee_name"))
      attendee.stub(:parsed_response).and_return(attendee)
    end

    context 'with existing attendees' do
      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(200)
      end

      it 'returns a attendee object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Attendee.retrieve("attendee_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.retrieve("attendee_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        attendee.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.retrieve("attendee_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.list' do

    before do
      AttendeaseSDK::Attendee.stub(:new).and_return(AttendeaseSDK::Attendee.new(name: "attendee_name"))
      attendee.stub(:parsed_response).and_return(attendee)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(200)
      end

      it 'returns all attendees by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Attendee.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(attendee)
        attendee.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        attendee.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK.stub(:event_subdomain).and_return("subdomaintest")
      AttendeaseSDK::Attendee.stub(:new).and_return(AttendeaseSDK::Attendee.new(name: "attendee_name"))
      attendee.stub(:parsed_response).and_return(attendee)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(201)
      end

      it 'creates a attendee and returns a attendee hash' do
        HTTParty.should_receive(:post).with("https://subdomaintest.localhost.attendease.com/api/attendees.json", :headers => AttendeaseSDK.event_headers, :body => "attendee_hash".to_json)
        AttendeaseSDK::Attendee.create("attendee_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://subdomaintest.localhost.attendease.com/api/attendees.json", :headers => AttendeaseSDK.event_headers, :body => "attendee_hash".to_json)
        expect { AttendeaseSDK::Attendee.create("attendee_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        attendee.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://subdomaintest.localhost.attendease.com/api/attendees.json", :headers => AttendeaseSDK.event_headers, :body => "attendee_hash".to_json)
        expect { AttendeaseSDK::Attendee.create("attendee_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Attendee.stub(:new).and_return(AttendeaseSDK::Attendee.new(name: "attendee_name"))
      attendee.stub(:parsed_response).and_return(attendee)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(attendee)
        attendee.stub(:code).and_return(204)
      end

      it 'updates attendees by hash of attendee attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/.json", :headers => AttendeaseSDK.admin_headers, :body => "attendee_hash".to_json)
        result = AttendeaseSDK::Attendee.update("attendee_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(attendee)
        attendee.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/.json", :headers => AttendeaseSDK.admin_headers, :body => "attendee_hash".to_json)
        expect { AttendeaseSDK::Attendee.update("attendee_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(attendee)
        attendee.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        attendee.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/.json", :headers => AttendeaseSDK.admin_headers, :body => "attendee_hash".to_json)
        expect { AttendeaseSDK::Attendee.update("attendee_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Attendee.stub(:new).and_return(AttendeaseSDK::Attendee.new(name: "attendee_name"))
      attendee.stub(:parsed_response).and_return(attendee)
    end

    context 'destroys a attendee' do

      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(204)
      end

      it 'destroys a attendee by attendee id' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id/cancel.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Attendee.destroy("attendee_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id/cancel.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.destroy("attendee_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(attendee)
        attendee.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        attendee.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/attendees/attendee_id/cancel.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Attendee.destroy("attendee_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end

describe AttendeaseSDK::Instance do

  let!(:instance){AttendeaseSDK::Instance.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Instance.stub(:new).and_return(instance)
      instance.stub(:parsed_response).and_return(instance)
    end

    context 'with existing instances' do
      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(200)
      end

      it 'returns a session object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/instance_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Instance.retrieve("session_id", "instance_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/instance_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.retrieve("session_id", "instance_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        instance.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/instance_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.retrieve("session_id", "instance_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.list' do

    before do
      AttendeaseSDK::Instance.stub(:new).and_return(AttendeaseSDK::Instance.new(name: "instance_name"))
      instance.stub(:parsed_response).and_return(instance)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(200)
      end

      it 'returns all instances by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Instance.list("session_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.list("session_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(instance)
        instance.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        instance.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.list("session_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Instance.stub(:new).and_return(AttendeaseSDK::Instance.new(name: "instance_name"))
      instance.stub(:parsed_response).and_return(instance)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(instance)
        instance.stub(:code).and_return(201)
      end

      it 'creates a instance and returns a instance hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        AttendeaseSDK::Instance.create("session_id", "instance_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(instance)
        instance.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        expect { AttendeaseSDK::Instance.create("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(instance)
        instance.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        instance.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        expect { AttendeaseSDK::Instance.create("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Instance.stub(:new).and_return(AttendeaseSDK::Instance.new(name: "instance_name"))
      instance.stub(:parsed_response).and_return(instance)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(instance)
        instance.stub(:code).and_return(204)
      end

      it 'updates sessions by hash of instance attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        result = AttendeaseSDK::Instance.update("session_id", "instance_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(instance)
        instance.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        expect { AttendeaseSDK::Instance.update("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(instance)
        instance.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        instance.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers, :body => "instance_hash".to_json)
        expect { AttendeaseSDK::Instance.update("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Instance.stub(:new).and_return(AttendeaseSDK::Instance.new(name: "instance_name"))
      instance.stub(:parsed_response).and_return(instance)
    end

    context 'destroys a instance' do

      before do
        HTTParty.stub(:delete).and_return(instance)
        instance.stub(:code).and_return(204)
      end

      it 'destroys a instance by instance id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Instance.destroy("session_id", "instance_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(instance)
        instance.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.destroy("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(instance)
        instance.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        instance.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/sessions/session_id/instances/.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Instance.destroy("session_id", "instance_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end

describe AttendeaseSDK::Venue do

  let!(:venue){AttendeaseSDK::Venue.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Venue.stub(:new).and_return(AttendeaseSDK::Venue.new(name: "venue_name"))
      venue.stub(:parsed_response).and_return(venue)
    end

    context 'with existing venues' do
      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(200)
      end

      it 'returns a venue object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Venue.retrieve("venue_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.retrieve("venue_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        venue.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.retrieve("venue_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::Venue.stub(:new).and_return(AttendeaseSDK::Venue.new(name: "venue_name"))
      venue.stub(:parsed_response).and_return(venue)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(200)
      end

      it 'returns all venues by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Venue.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(venue)
        venue.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        venue.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Venue.stub(:new).and_return(AttendeaseSDK::Venue.new(name: "venue_name"))
      venue.stub(:parsed_response).and_return(venue)
    end

    context 'when .create is called' do

      before do
        HTTParty.stub(:post).and_return(venue)
        venue.stub(:code).and_return(201)
      end

      it 'creates a venue and returns a venue hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        AttendeaseSDK::Venue.create("venue_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(venue)
        venue.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        expect { AttendeaseSDK::Venue.create("venue_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(venue)
        venue.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        venue.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        expect { AttendeaseSDK::Venue.create("venue_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Venue.stub(:new).and_return(AttendeaseSDK::Venue.new(name: "venue_name"))
      venue.stub(:parsed_response).and_return(venue)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(venue)
        venue.stub(:code).and_return(204)
      end

      it 'updates venues by hash of venue attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        result = AttendeaseSDK::Venue.update("venue_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(venue)
        venue.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        expect { AttendeaseSDK::Venue.update("venue_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(venue)
        venue.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        venue.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/.json", :headers => AttendeaseSDK.admin_headers, :body => "venue_hash".to_json)
        expect { AttendeaseSDK::Venue.update("venue_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Venue.stub(:new).and_return(AttendeaseSDK::Venue.new(name: "venue_name"))
      venue.stub(:parsed_response).and_return(venue)
    end

    before do
      HTTParty.stub(:delete).and_return(venue)
      venue.stub(:code).and_return(204)
    end

    context 'destroys a venue' do
      it 'destroys a venue by venue id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Venue.destroy("venue_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(venue)
        venue.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.destroy("venue_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(venue)
        venue.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        venue.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/venues/venue_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Venue.destroy("venue_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end

describe AttendeaseSDK::Room do

  let!(:room){AttendeaseSDK::Room.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Room.stub(:new).and_return(AttendeaseSDK::Room.new(name: "room_name"))
      room.stub(:parsed_response).and_return(room)
    end

    context 'with existing rooms' do
      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(200)
      end

      it 'returns a room object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Room.retrieve("room_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.retrieve("room_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        room.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.retrieve("room_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::Room.stub(:new).and_return(AttendeaseSDK::Room.new(name: "room_name"))
      room.stub(:parsed_response).and_return(room)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(200)
      end

      it 'returns all rooms by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Room.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.list}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(room)
        room.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        room.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.list}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Room.stub(:new).and_return(AttendeaseSDK::Room.new(name: "room_name"))
      room.stub(:parsed_response).and_return(room)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(room)
        room.stub(:code).and_return(201)
      end

      it 'creates a room and returns a room hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        result = AttendeaseSDK::Room.create("room_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(room)
        room.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        expect { AttendeaseSDK::Room.create("room_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(room)
        room.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        room.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        expect { AttendeaseSDK::Room.create("room_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end


  end

  describe '.update' do

    before do
      AttendeaseSDK::Room.stub(:new).and_return(AttendeaseSDK::Room.new(name: "room_name"))
      room.stub(:parsed_response).and_return(room)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(room)
        room.stub(:code).and_return(204)
      end

      it 'updates rooms by hash of room attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        AttendeaseSDK::Room.update("room_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(room)
        room.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        expect { AttendeaseSDK::Room.update("room_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(room)
        room.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        room.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/.json", :headers => AttendeaseSDK.admin_headers, :body => "room_hash".to_json)
        expect { AttendeaseSDK::Room.update("room_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Room.stub(:new).and_return(AttendeaseSDK::Room.new(name: "room_name"))
      room.stub(:parsed_response).and_return(room)
    end

    context 'destroys a room' do
      before do
        HTTParty.stub(:delete).and_return(room)
        room.stub(:code).and_return(204)
      end

      it 'destroys a room by room id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Room.destroy("room_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(room)
        room.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.destroy("room_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(room)
        room.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        room.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/rooms/room_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Room.destroy("room_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end
end

describe AttendeaseSDK::Filter do

  let!(:filter){AttendeaseSDK::Filter.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Filter.stub(:new).and_return(AttendeaseSDK::Filter.new(name: "filter_name"))
      filter.stub(:parsed_response).and_return(filter)
    end

    context 'with existing filters' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(200)
      end

      it 'returns a filter object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Filter.retrieve("filter_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.retrieve("filter_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.retrieve("filter_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::Filter.stub(:new).and_return(AttendeaseSDK::Filter.new(name: "filter_name"))
      filter.stub(:parsed_response).and_return(filter)
    end

    context 'when .list is called' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(200)
      end

      it 'returns all filters by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Filter.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.list}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(filter)
        filter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.list}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Filter.stub(:new).and_return(AttendeaseSDK::Filter.new(name: "filter_name"))
      filter.stub(:parsed_response).and_return(filter)
    end

    context 'when .create is called' do

      before do
        HTTParty.stub(:post).and_return(filter)
        filter.stub(:code).and_return(201)
      end

      it 'creates a filter and returns a filter hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        AttendeaseSDK::Filter.create("filter_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(filter)
        filter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        expect { AttendeaseSDK::Filter.create("filter_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(filter)
        filter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        expect { AttendeaseSDK::Filter.create("filter_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.update' do

    before do
      AttendeaseSDK::Filter.stub(:new).and_return(AttendeaseSDK::Filter.new(name: "filter_name"))
      filter.stub(:parsed_response).and_return(filter)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(filter)
        filter.stub(:code).and_return(204)
      end

      it 'updates filters by hash of filter attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        result = AttendeaseSDK::Filter.update("filter_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(filter)
        filter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        expect { AttendeaseSDK::Filter.update("filter_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(filter)
        filter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_hash".to_json)
        expect { AttendeaseSDK::Filter.update("filter_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Filter.stub(:new).and_return(AttendeaseSDK::Filter.new(name: "filter_name"))
      filter.stub(:parsed_response).and_return(filter)
    end

    context 'destroys a filter' do
      before do
        HTTParty.stub(:delete).and_return(filter)
        filter.stub(:code).and_return(204)
      end

      it 'destroys a filter by filter id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Filter.destroy("filter_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(filter)
        filter.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.destroy("filter_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(filter)
        filter.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Filter.destroy("filter_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end

describe AttendeaseSDK::FilterItem do

  let!(:filter_item){AttendeaseSDK::FilterItem.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::FilterItem.stub(:new).and_return(AttendeaseSDK::FilterItem.new(name: "filter_item_name"))
      filter_item.stub(:parsed_response).and_return(filter_item)
    end

    context 'with existing filter_items' do

      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(200)
      end

      it 'returns a filter_item object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::FilterItem.retrieve("filter_id", "filter_item_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.retrieve("filter_id", "filter_item_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter_item.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.retrieve("filter_id", "filter_item_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::FilterItem.stub(:new).and_return(AttendeaseSDK::FilterItem.new(name: "filter_item_name"))
      filter_item.stub(:parsed_response).and_return(filter_item)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(200)
      end

      it 'returns all filter_items by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::FilterItem.list("filter_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.list("filter_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(filter_item)
        filter_item.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter_item.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.list("filter_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::FilterItem.stub(:new).and_return(AttendeaseSDK::FilterItem.new(name: "filter_item_name"))
      filter_item.stub(:parsed_response).and_return(filter_item)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(filter_item)
        filter_item.stub(:code).and_return(201)
      end

      it 'creates a filter_item and returns a filter_item hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        result = AttendeaseSDK::FilterItem.create("filter_id","filter_item_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(filter_item)
        filter_item.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        expect { AttendeaseSDK::FilterItem.create("filter_id","filter_item_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(filter_item)
        filter_item.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter_item.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        expect { AttendeaseSDK::FilterItem.create("filter_id","filter_item_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::FilterItem.stub(:new).and_return(AttendeaseSDK::FilterItem.new(name: "filter_item_name"))
      filter_item.stub(:parsed_response).and_return(filter_item)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(filter_item)
        filter_item.stub(:code).and_return(204)
      end

      it 'updates filter_items by hash of filter_item attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        result = AttendeaseSDK::FilterItem.update("filter_id","filter_item_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(filter_item)
        filter_item.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        expect { AttendeaseSDK::FilterItem.update("filter_id","filter_item_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(filter_item)
        filter_item.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter_item.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/.json", :headers => AttendeaseSDK.admin_headers, :body => "filter_item_hash".to_json)
        expect { AttendeaseSDK::FilterItem.update("filter_id","filter_item_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::FilterItem.stub(:new).and_return(AttendeaseSDK::FilterItem.new(name: "filter_item_name"))
      filter_item.stub(:parsed_response).and_return(filter_item)
    end

    context 'destroys a filter_item' do

      before do
        HTTParty.stub(:delete).and_return(filter_item)
        filter_item.stub(:code).and_return(204)
      end

      it 'destroys a filter_item by filter_item id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::FilterItem.destroy("filter_id","filter_item_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(filter_item)
        filter_item.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.destroy("filter_id","filter_item_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(filter_item)
        filter_item.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        filter_item.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/filters/filter_id/filter_items/filter_item_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::FilterItem.destroy("filter_id","filter_item_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end
end

describe AttendeaseSDK::Day do

  let!(:day){AttendeaseSDK::Day.new(date: "01/02/17")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Day.stub(:new).and_return(day)
      day.stub(:parsed_response).and_return(day)
    end

    context 'with existing days' do
      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(200)
      end

      it 'returns a day object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Day.retrieve("day_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.retrieve("day_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        day.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.retrieve("day_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.list' do

    before do
      AttendeaseSDK::Day.stub(:new).and_return(day)
      day.stub(:parsed_response).and_return(day)
    end

    context 'when .list is called' do

      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(200)
      end

      it 'returns all days by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Day.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.list}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(day)
        day.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        day.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.list}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Day.stub(:new).and_return(day)
      day.stub(:parsed_response).and_return(day)
    end

    context 'when .create is called' do

      before do
        HTTParty.stub(:post).and_return(day)
        day.stub(:code).and_return(201)
      end

      it 'creates a day and returns a day hash' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        result = AttendeaseSDK::Day.create("day_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(day)
        day.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        expect { AttendeaseSDK::Day.create("day_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(day)
        day.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        day.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        expect { AttendeaseSDK::Day.create("day_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Day.stub(:new).and_return(day)
      day.stub(:parsed_response).and_return(day)
    end

    context 'when .update is called' do

      before do
        HTTParty.stub(:put).and_return(day)
        day.stub(:code).and_return(204)
      end

      it 'updates days by hash of day attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        result = AttendeaseSDK::Day.update("day_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(day)
        day.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        expect { AttendeaseSDK::Day.update("day_hash")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(day)
        day.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        day.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/.json", :headers => AttendeaseSDK.admin_headers, :body => "day_hash".to_json)
        expect { AttendeaseSDK::Day.update("day_hash")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Day.stub(:new).and_return(day)
      day.stub(:parsed_response).and_return(day)
    end

    context 'destroys a day' do

      before do
        HTTParty.stub(:delete).and_return(day)
        day.stub(:code).and_return(204)
      end

      it 'destroys a day by day id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Day.destroy("day_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(day)
        day.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.destroy("day_id")}.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(day)
        day.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        day.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id/days/day_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Day.destroy("day_id")}.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end
end

describe AttendeaseSDK::Event do

  let!(:event){AttendeaseSDK::Event.new(name: "name")}

  before do
    AttendeaseSDK.user_token = "my_token"
    AttendeaseSDK.event_id = "my_event_id"
    AttendeaseSDK.environment = "development"
    AttendeaseSDK.event_subdomain = "subdomaintest"
  end

  describe '.retrieve' do

    before do
      AttendeaseSDK::Event.stub(:new).and_return(AttendeaseSDK::Event.new(name: "event_name"))
      event.stub(:parsed_response).and_return(event)
    end

    context 'with existing events' do
      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(200)
      end

      it 'returns a event object' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Event.retrieve
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.retrieve }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        event.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.retrieve }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.list' do

    before do
      AttendeaseSDK::Event.stub(:new).and_return(AttendeaseSDK::Event.new(name: "event_name"))
      event.stub(:parsed_response).and_return(event)
    end

    context 'when .list is called' do
      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(200)
      end

      it 'returns all events by event id' do
        HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        AttendeaseSDK::Event.list
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.list }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:get).and_return(event)
        event.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        event.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        response = HTTParty.should_receive(:get).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.list }.to raise_error(AttendeaseSDK::DomainError)
      end
    end

  end

  describe '.create' do

    before do
      AttendeaseSDK::Event.stub(:new).and_return(AttendeaseSDK::Event.new(name: "event_name"))
      event.stub(:parsed_response).and_return(event)
    end

    context 'when .create is called' do
      before do
        HTTParty.stub(:post).and_return(event)
        event.stub(:code).and_return(201)
      end

      it 'creates a event and returns a event object' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        AttendeaseSDK::Event.create("event_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:post).and_return(event)
        event.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        expect { AttendeaseSDK::Event.create("event_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:post).and_return(event)
        event.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        event.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:post).with("https://dashboard.localhost.attendease.com/api/events.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        expect { AttendeaseSDK::Event.create("event_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.update' do

    before do
      AttendeaseSDK::Event.stub(:new).and_return(AttendeaseSDK::Event.new(name: "event_name"))
      event.stub(:parsed_response).and_return(event)
    end

    context 'when .update is called' do
      before do
        HTTParty.stub(:put).and_return(event)
        event.stub(:code).and_return(204)
      end

      it 'updates events by hash of event attributes' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        result = AttendeaseSDK::Event.update("event_hash")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:put).and_return(event)
        event.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        expect { AttendeaseSDK::Event.update("event_hash") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:put).and_return(event)
        event.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        event.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:put).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers, :body => "event_hash".to_json)
        expect { AttendeaseSDK::Event.update("event_hash") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end

  describe '.destroy' do

    before do
      AttendeaseSDK::Event.stub(:new).and_return(AttendeaseSDK::Event.new(name: "event_name"))
      event.stub(:parsed_response).and_return(event)
    end

    context 'destroys a event' do

      before do
        HTTParty.stub(:delete).and_return(event)
        event.stub(:code).and_return(204)
      end

      it 'destroys a event by event id' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        result = AttendeaseSDK::Event.destroy("event_id")
      end
    end

    context 'when it fails due to a connection error' do

      before do
        HTTParty.stub(:delete).and_return(event)
        event.stub(:code).and_return(404)
        AttendeaseSDK::ConnectionError.stub(:new).and_raise(AttendeaseSDK::ConnectionError)
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.destroy("event_id") }.to raise_error(AttendeaseSDK::ConnectionError)
      end
    end

    context 'when it fails due to a domain error' do

      before do
        HTTParty.stub(:delete).and_return(event)
        event.stub(:code).and_return(422)
        AttendeaseSDK::DomainError.stub(:new).and_raise(AttendeaseSDK::DomainError)
        event.stub(:parsed_response).and_return({'errors' => {'errors' => ['error']}})
      end

      it 'raises an error' do
        HTTParty.should_receive(:delete).with("https://dashboard.localhost.attendease.com/api/events/my_event_id.json", :headers => AttendeaseSDK.admin_headers)
        expect { AttendeaseSDK::Event.destroy("event_id") }.to raise_error(AttendeaseSDK::DomainError)
      end
    end
  end
end
