#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
ports = [22, 80]
firewall_rule "open ports #{ports}" do
  port ports
end