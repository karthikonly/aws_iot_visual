namespace :clean do
  desc "Clean the activations in the system"
  task activations: :environment do
    Activation.delete_all
  end

end
