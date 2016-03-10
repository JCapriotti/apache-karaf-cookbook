karaf_config 'list' do
end

# set a bunch of properties
karaf_config 'com.test.propset' do
  action      :property_set
  property    "foo"
  value       "bar"
end

karaf_config 'com.test.propappend' do
  action      :property_set
  property    "foo"
  value       "bar"
end

karaf_config 'com.test.propdelete' do
  action      :property_set
  property    "myprop"
  value       "bar"
end

karaf_config 'com.test.deleteme' do
  action      :property_set
  property    "foo"
  value       "bar"
end

# append to existing
karaf_config 'com.test.propappend' do
  action      :property_append
  property    "foo"
  value       ", appended"
end

# delete property
karaf_config 'com.test.propdelete' do
  action      :property_delete
  property    "myprop"
end

# delete configuration
karaf_config 'com.test.deleteme' do
  action      :delete
end

# test modifying an existing configuration 
karaf_config 'org.apache.karaf.shell' do
  action :property_set
  property    "sshIdleTimeout"
  value       1800001.to_s
end