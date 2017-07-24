require_dependency Rails.root.join('app', 'helpers', 'settings_helper').to_s

module Custom::SettingsHelper

  def feature?(name)
    setting["feature.#{name}"].presence
  end

  def setting
    @all_settings ||= Hash[ Setting.all.map{|s| [s.key, s.value.presence]} ]
  end

end