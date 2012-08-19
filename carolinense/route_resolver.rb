#encoding: utf-8

require 'singleton'
require 'find'

module Definetion; end

class Definetion::Routes
  include Singleton
  attr_accessor :routes

  def initialize
    self.routes = {}
  end

  def route(name, &block)
    add(name, &block)
  end

  def helpers(&block)
    block.call
  end

  def add(name, options={}, &block)
    routes[name.to_sym] = block
  end

  def resolve(name)
    name = name.to_sym

    return nil unless route?(name)

    route_definetion = reverse_lookup(name)
    return nil unless routes.key?(route_definetion)

    routes[route_definetion]
  end

  def call(name, options={})
    method = resolve(name)
    return false if method.nil?

    params = get_params(name)
    lambda { |name, options, &block|
      params = get_params(name).merge(options)

      block.call(params)
    }.call(name, options, &method)
  end

  def reverse_lookup(name)
    routes.keys.each do |route_definetion|
      regex = Regexp.new(route_definetion.to_s.gsub(/:(.+?)(\/|$)/, '(.+?)(/|$)'))

      return route_definetion unless (regex =~ name).nil?
    end

    return nil
  end

  def route?(name)
    routes.keys.each do |route_definetion|
      regex = Regexp.new(route_definetion.to_s.gsub(/:(.+?)(\/|$)/, '(.+?)(/|$)'))

      return true unless (regex =~ name).nil?
    end

    return false
  end

  def get_params(name)
    routes.keys.each do |route_definetion|
      regex = Regexp.new(route_definetion.to_s.gsub(/:(.+?)(\/|$)/, '(.+?)(/|$)'))

      unless (regex =~ name).nil?
        return parameter_splitter(route_definetion, regex, name)
      end
    end
  end

  def parameter_splitter(route_definetion, regex, str)
    params = {}

    param_keys = route_definetion.to_s.match(regex)[1..-1].delete_if{|m| m =~ /\// || m == ''}.map do |m|
      m.gsub(/:/, '')
    end
    str.to_s.match(regex)[1..-1].delete_if{|a| a =~ /(\/$)/ || a == ""}.each_with_index do |param, i|
      params[param_keys[i]] = param
    end

    params
  end


  def load
    routes_path = File.expand_path('./..', __FILE__)+File::SEPARATOR+'routes'
    helpers_path = File.expand_path('./..', __FILE__)+File::SEPARATOR+'helpers'
    raise '' unless File.directory?(routes_path)
    raise '' unless File.directory?(helpers_path)


    Find.find(routes_path) do |entry|
      next if File.directory?(entry) || !(entry =~ /\.rb$/)

      eval(open(entry).read)
    end
    Find.find(helpers_path) do |entry|
      next if File.directory?(entry) || !(entry =~ /\.rb$/)

      eval(open(entry).read)
    end
  end

  def definetions(&block)
    Definetion::Routes.instance.instance_eval(&block)
  end
end

Definetion::Routes.instance.load()
