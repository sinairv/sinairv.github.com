Write-Host "Deploying updates to GitHub..."

# Build the site
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git
git add .

# Commit changes

$date = Get-Date
$formattedDate = $date.ToString("F")
$msg="rebuilding site $formattedDate"

if($args[0]) {
  $msg = $args[0]
}

Write-Host $msg

git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..