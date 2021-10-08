require "thor"

module RailsCredentialsGit
  class CLI < Thor
    include Thor::Actions

    package_name "git:credentials"

    source_root(File.expand_path('../../', __dir__))

    desc "install", "Copy binary into project's folder"
    def install
      copy_file "lib/rails-credentials-git/templates/enc", "bin/enc", mode: :preserve

      method = RailsCredentialsGit.decrypt_method.sub("self.", "")
      insert_into_file "bin/enc", "\n#{method}" , after: %{require "openssl"\n}
    end
  end
end
