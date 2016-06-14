task :deploy_to_github_pages do
  if ENV["GITHUB_URL"]
    # Configure Git
    `git config --global user.email "devops@heroku.com"`
    `git config --global user.name "heroku"`
    # Clone from GitHub Pages
    `git clone ${GITHUB_URL} temp --branch gh-pages`
    `mv temp/.git public/.git`
    Dir.chdir('public') do
      # Add all file changes
      `echo votestakes.com > CNAME`
      `git add -A && git commit -m "Update published site"`
      # Push to GitHub Pages
      `git push -f ${GITHUB_URL} gh-pages`
    end
  else
    puts "Review apps are not deployed to GitHub pages"
  end
end
