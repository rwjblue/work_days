shared_examples "a work schedule" do
  context "included modules" do
    it "includes WorkDays::HolidayMethods" do
      described_class.ancestors.should include(WorkDays::HolidayMethods)
    end

    it "includes WorkDays::CalculationMethods" do
      described_class.ancestors.should include(WorkDays::CalculationMethods)
    end
  end

  context "#observed_holidays" do
    it {should respond_to(:observed_holidays)}

    it "returns an enumerable of holiday methods" do
      subject.observed_holidays.each do |sym|
        subject.should respond_to(sym)
      end
    end
  end
end
