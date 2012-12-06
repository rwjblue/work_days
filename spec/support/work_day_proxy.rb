shared_examples "a proxy for BusinessDays.work_day?" do
  context "#work_day?" do
    it "should respond_to work_day?" do
      should respond_to(:work_day?)
    end

    it "should call BusinessDays.work_day? passing self" do
      BusinessDays.should_receive(:work_day?).with(subject)

      subject.work_day?
    end
  end
end
