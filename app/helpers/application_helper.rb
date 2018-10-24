module ApplicationHelper
  def process_serial_numbers(activation)
    local_discovered = {}
    local_provisioned = {}
    Activation::TYPES.each do |type|
      next unless (activation.discovered[type] && activation.provisioned[type])
      local_discovered[type] ||= []
      local_provisioned[type] ||= []
      activation.discovered[type].each do |serial|
        local_discovered[type] << (activation.provisioned[type].include?(serial) ? {serial: serial, class: 'label-success'} : {serial: serial, class: 'label-danger'})
      end
      activation.provisioned[type].each do |serial|
        local_provisioned[type] << (activation.discovered[type].include?(serial) ? {serial: serial, class: 'label-success'} : {serial: serial, class: 'label-danger'})
      end
    end
    activation.discovered = local_discovered
    activation.provisioned = local_provisioned
    pp activation
  end
end
