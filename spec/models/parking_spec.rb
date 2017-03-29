require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do
    # it "is invalid without amount" do
    #   parking = Parking.new(:parking_type => "guest",
    #                         :start_at => Time.now - 6.hours,
    #                         :end_at => Time.now)
    #   expect(parking).to_not be_valid
    # end

    it "is invalid without end_at" do
      parking = Parking.new(:parking_type => "guest",
                            :start_at => Time.new - 6.hours,
                            :amount => 999)
      expect(parking).to_not be_valid
    end
  end

  describe ".save" do
    before do
      @time = Time.new(2017, 3, 27, 8, 0, 0)
    end

    context "guest" do
      before do
        @parking = Parking.new(:parking_type => "guest",
                               :user => @user,
                               :start_at => @time)
      end

      it "30 mins should be 2 RMB" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be 2 RMB" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be 3 RMB" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end

      it "90 mins should be 3 RMB" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end

      it "120 mins should be 4 RMB" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(400)
      end
    end

    context "short-term" do
      before do
        @user = User.create(:email => "test@example.com",
                            :password => "12345678")
        @parking = Parking.new(:parking_type => "short-term",
                               :user => @user,
                               :start_at => @time)
      end

      it "30 mins should be 2 RMB" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be 2 RMB" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be 2.5 RMB" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end

      it "90 mins should be 2.5 RMB" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end

      it "120 mins should be 3 RMB" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end
    end

    context "long-term" do
      before do
        @user = User.create(:email => "test@example.com",
                            :password => "12345678")
        @parking = Parking.new(:parking_type => "long-term",
                               :user => @user,
                               :start_at => @time)
      end

      it "1 hour should be 12 RMB" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "6 hours should be 12 RMB" do
        @parking.end_at = @time + 360.minutes
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "361 mins should be 16 RMB" do
        @parking.end_at = @time + 361.minutes
        @parking.save
        expect(@parking.amount).to eq(1600)
      end

      it "24 hours should be 16 RMB" do
        @parking.end_at = @time + 1440.minutes
        @parking.save
        expect(@parking.amount).to eq(1600)
      end
    end
  end
end
