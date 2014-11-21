class SubdomainFormatValidator < ActiveModel::EachValidator
  SUBDOMAIN_REGEX = /^[a-z\d]+([-_][a-z\d]+)*$/i

  def validate_each(object, attribute, value)
    unless value =~ SUBDOMAIN_REGEX
      object.errors[attribute] << 
        (options[:message] || "not formatted correctly")
    end
    object.errors
  end
end