require File.expand_path("../../../spec_helper", __FILE__)
require "magi/git/initializer"

describe Build do
  let(:build) do
    FactoryGirl.create(:build, properties: { "revision" => "1" })
  end

  describe "#revision" do
    it "is registered as property" do
      build.reload.revision.should == "1"
    end
  end
end

describe Job do
  let(:job) do
    FactoryGirl.create(:job, properties: { "repository_url" => "repository_url" })
  end

  let(:repository) do
    Magi::Git::Repository.any_instance
  end

  describe "#repository_url" do
    it "is registered as property" do
      job.repository_url.should == "repository_url"
    end
  end

  describe "#enqueue" do
    before do
      job.stub(enqueue_without_before_enqueues: true)
    end

    it "executes Magi::Git::Repository#before_enqueue" do
      repository.should_receive(:before_enqueue)
      job.enqueue
    end
  end

  describe "#execute" do
    before do
      job.stub(execute_without_before_executes: true)
    end

    it "executes Magi::Git::Repository#\{before,after}_execute" do
      repository.should_receive(:before_execute)
      repository.should_receive(:after_execute)
      job.execute
    end
  end
end
