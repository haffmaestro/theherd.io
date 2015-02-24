# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog
  process :resize_to_fill => [100, 100]
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def resize_with_crop(img, w, h, options = {})
  #   gravity = options[:gravity] || :center

  #   w_original, h_original = [img[:width].to_f, img[:height].to_f]

  #   op_resize = ''

  #     # check proportions
  #     if w_original * h < h_original * w
  #       op_resize = "#{w.to_i}x"
  #       w_result = w
  #       h_result = (h_original * w / w_original)
  #     else
  #       op_resize = "x#{h.to_i}"
  #       w_result = (w_original * h / h_original)
  #       h_result = h
  #     end

  #     w_offset, h_offset = crop_offsets_by_gravity(gravity, [w_result, h_result], [ w, h])

  #     img.combine_options do |i|
  #       i.resize(op_resize)
  #       i.gravity(gravity)
  #       i.crop "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
  #     end

  #     img
  #   end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
