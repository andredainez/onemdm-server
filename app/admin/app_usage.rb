ActiveAdmin.register_page "App Usage" do

  menu priority: 2, label: "App Usage"
  app_usages = AppUsage.select(:package_name,:device_id,:used_on).
          order("used_on desc").
          group("device_id","package_name","used_on").
          sum("usage_duration_in_seconds")
  app_usage_data = []
  app_usages.each do |key,value|
    app_usage_data << {device_id: key[0],
                       package_name: key[1],
                       used_on: key[2],
                       usage: value} 
  end
  content title: "App Usage" do
    
    panel "Usage Report" do
      table_for app_usage_data do
        column "Used On" do |app_usage|
          app_usage[:used_on]
        end
        column "Device" do |app_usage|
          device_id = app_usage[:device_id]
          link_to device_id,admin_devices_path(device_id)
        end
        column "Package Name" do |app_usage|
          app_usage[:package_name]
        end
        column "Total Usage" do |app_usage|
          #usage_in_minutes = app_usage[:usage]/60
          #(usage_in_minutes > 0) ? usage_in_minutes :"Less than a minute"
          distance_of_time_in_words (app_usage[:usage])
        end
      end
    end    
  end # content
end
