shared_examples "a proxy for WorkDays.work_day?" do
  context "#work_day?" do
    it "should respond_to work_day?" do
      should respond_to(:work_day?)
    end

    it "should call WorkDays.work_day? passing self" do
      WorkDays.should_receive(:work_day?).with(subject)

      subject.work_day?
    end
  end
end
