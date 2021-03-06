#!/usr/bin/env ruby

class CountAndroidMethods
  def count(path)
    full_folder_path = File.expand_path(path)
    total_count = 0

    # Traverse the folder
    Dir.entries(full_folder_path).each {|file|

      # Attempt to read only jars
      if file.end_with?('jar')
        # Count methods in dex
        count = count_methods_in_jar(full_folder_path, file)

        # Accumulate count
        total_count = total_count + count

        # Print out count
        #puts "#{count}: \"#{file}\""
      end
    }

    # Print out total count
    puts "#{total_count}"
  end

  def count_methods_in_jar(full_folder_path, jar_file_name)
    temp_dex_path = full_folder_path + '/temp.dex'
    jar_path = full_folder_path + '/' + jar_file_name

    # Create a temp dex file
    `${ANDROID_SDK}/build-tools/20.0.0/dx --dex --output="#{temp_dex_path}" "#{jar_path}" > /dev/null 2>&1`

    # Count methods in dex
    count = `cat "#{temp_dex_path}" | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d"'`

    # Delete temp dex file
    File.delete(temp_dex_path)

    # Return int
    count.to_i
  end
end

# Input check
if ARGV.empty? || ARGV.size > 1
  puts 'usage: ./count_android_methods.rb [jar folder path]'
else
  counter = CountAndroidMethods.new
  counter.count(ARGV.first)
end
