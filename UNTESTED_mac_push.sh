echo "Running Git commands..."

repository_path="$(cd "$(dirname "$0")" && pwd)"

read -p "Enter the commit message: " commit_message

cd "$repository_path" && git add .
cd "$repository_path" && git commit -m "$commit_message"
cd "$repository_path" && git push origin main

read -n 1 -s -r -p "Press any key to continue..."
