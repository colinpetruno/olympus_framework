# frozen_string_literal: true

declared_release = github.pr_title.include?('release') || github.pr_title.include?('Release')
declared_pre_release = github.pr_title.include?('pre-release') || github.pr_title.include?('Pre-release')
declared_hot_fix = github.branch_for_head.include?('hotfix')

has_app_changes = !git.modified_files.grep(/lib/).empty? || !git.modified_files.grep(/app/).empty? || !git.modified_files.grep(/interactions/).empty?
has_app_changes = has_app_changes || !git.added_files.grep(/lib/).empty? || !git.added_files.grep(/app/).empty? || !git.added_files.grep(/interactions/).empty?
has_spec_changes = !git.modified_files.grep(/spec/).empty? || !git.added_files.grep(/spec/).empty?

 def notify_migration_change
   url     = 'https://hooks.slack.com/services/xoxb-1516716670130-1722593003843-Av8SCai0FChQFhPggfjmiVwl'
   slack_message = "<!here> A migration has been added in #PR #{github.pr_json['html_url']} - Please check if it involves cross project tables"
# 
   uri              = URI.parse(url)
   headers          = { 'Content-Type'    => 'application/json',
       'Accept'          => 'application/json' }
   http             = Net::HTTP.new(uri.host, uri.port)
   http.use_ssl     = true # When using https
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   response         = http.post(uri.path, { text: slack_message }.to_json, headers)
   message("Olympus framework General Slack channel notification status of migration change: #{response.body}")
 end

# Warn when there is a big PR
fail('This pull request is too big 750 a lot- split it into smaller ones') if git.lines_of_code > 750 && !declared_release

# Check branches
fail('Never merged master to other branches via PullRequest!', sticky: true) if github.branch_for_head == 'master' && github.branch_for_base != 'production'
fail('Merge only master or hot-fix to production', sticky: true) if github.branch_for_base == 'production' && !(declared_release || declared_hot_fix)

# Check if tests were added
warn('Code was changed but no tests were added', sticky: false) if has_app_changes && !has_spec_changes

# Check gemfile
gemfile_changed = git.modified_files.include?('Gemfile')
gemfile_lock_changed = git.modified_files.include?('Gemfile.lock')
fail('Gemfile updated - run bundle install', sticky: false) if gemfile_changed && !gemfile_lock_changed

# Warn about todos
todoist.warn_for_todos

# Run rubocop
all_files = (git.modified_files + git.added_files).reject { |path| path.include?('dev/') || path.include?('Dangerfile') }
rubocop.lint files: all_files, force_exclusion: true

# Check if stats library version dumped
stats_lib_changed = !git.modified_files.grep(%r{stats\/[abcdl]}).empty? && !git.added_files.grep(%r{stats\/[abcdl]}).empty?
stats_lib_version_changed = git.modified_files.include?('stats/lib/stats/version.rb')
fail("Updated stats library but version wasn't updated!", sticky: true) if stats_lib_changed && !stats_lib_version_changed

# Simple coverage
if ENV['SIMPLECOV'] == 'json'
  simplecov.report('coverage/coverage.json')
  simplecov.individual_report('coverage/coverage.json', Dir.pwd)
end

# Check migration files
migration_changed = !git.modified_files.grep(%r{db\/migrate\/}).empty?
migration_updated_message = "Migrations have been updated! Remember that old migrations won't be re-run."
warn(migration_updated_message, sticky: true) if migration_changed

# Check migration added
migration_added = !git.added_files.grep(%r{db\/migrate\/}).empty? || migration_changed
notify_migration_change if migration_added

# Check for RubyMine files
idea_files_changed = !git.modified_files.grep(%r{\.idea\/}).empty? || !git.added_files.grep(%r{\.idea\/}).empty?
warn('RubyMine files committed') if idea_files_changed
