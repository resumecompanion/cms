# encoding: utf-8

class Cms::ImageUploader < ::CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :large do
    process :resize_to_limit => [620, nil]

    def full_filename (for_file = model.image.file)
      filename = File.basename(for_file)
      ext = File.extname(for_file)
      base_name = filename.chomp(ext)
      [base_name, version_name].compact.join('-') + ext
    end
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [170, 170]

    def full_filename (for_file = model.image.file)
      filename = File.basename(for_file)
      ext = File.extname(for_file)
      base_name = filename.chomp(ext)
      [base_name, version_name].compact.join('-') + ext
    end
  end

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

  def rename(new_name)

    if Rails.env.production? || Rails.env.staging?

      original_file = model.image.file

      temp_file = File.open open(original_file.url) rescue nil

      if temp_file.present?
        temp_file_path = File.dirname temp_file
        temp_file_extname = File.extname temp_file

        if temp_file_extname.blank?
          identify_type = File.open(temp_file).gets[0,4]

          if identify_type.include?("PNG")
            temp_file_extname = ".png"
          elsif identify_type[0] == "\xFF"
            temp_file_extname = ".jpg"
          end
        end

        new_path = temp_file_path + "/" + new_name + temp_file_extname

        FileUtils.mv temp_file, new_path

        new_file = File.open new_path

        model.image = new_file
        model.save!
      end

    else

      original_file = model.image.file

      if File.exist?(original_file.path)
        extname = File.extname(original_file.path)

        if extname.blank?
          temp_file = File.open(original_file.path, "r")
          identify_type = temp_file.gets[0,4]

          if identify_type.include?("PNG")
            extname = ".png"
          elsif identify_type[0] == "\xFF"
            extname = ".jpg"
          end
        end

        new_path = File.join(File.dirname(original_file.path), "#{new_name}#{extname}")
        new_file = CarrierWave::SanitizedFile.new original_file.move_to(new_path)
        model.image.cache!(new_file)
        model.save!
      end

    end

    return model
  end
end
