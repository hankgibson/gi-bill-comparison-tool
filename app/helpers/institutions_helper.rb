module InstitutionsHelper
  LOCALE = {
    11 => 'City', 12 => 'City', 13 => 'City', 
    21 => 'Suburban', 22 => 'Suburban', 23 => 'Suburban',
    31 => 'Town', 32 => 'Town', 33 => 'Town',
    41 => 'Rural', 42 => 'Rural', 43 => 'Rural'
  }

  def to_caps(string)
    string.blank? ? '' : string.split(' ').map{|w| w.capitalize}.join(' ')
  end

  def to_bool(val)
    %w(yes true t 1).include?(val.to_s)
  end

  def is_number?(v)
    return false if v.blank?
    
    !(v.to_s =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/).nil?
  end

  def format_number_or_null(v, what) 
    if is_number?(v)
      what = v == 1 ? what : what.pluralize
      number_with_delimiter(v) + " " + what
    elsif v.blank?
      pluralize(0, what)
    else
      what + " #{v}"
    end
  end

  def format_pct_or_null(v)
    if is_number?(v)
      number_with_precision(v, precision: 2)
    elsif v.blank?
      0
    else
      v
    end
  end

  def to_locale(key)
    l = InstitutionsHelper::LOCALE[key]
    l || 'Locale Unknown'
  end
end
