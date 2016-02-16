require "rails_helper"

RSpec.describe SampleMailer, :type => :mailer do

	before do
    @post = FactoryGirl.create(:post)
  end
	
	it 'should enqueue and delay the mailer job' do
		SampleMailer.delay.send_email(@post.id) # Enqueuing the mailer
		expect(Sidekiq::Extensions::DelayedMailer.jobs.size == 1).to be true
		expect(SampleMailer.instance_method :send_email).to be_delayed(@post.id)
	end

	it 'should delay the mailer job for specified time' do
		SampleMailer.delay_for(1.minute).send_email(@post.id) # Enqueuing the mailer
		expect(SampleMailer.instance_method :send_email).to be_delayed(@post.id).for 1.minute
	end
end