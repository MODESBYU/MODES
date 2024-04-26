echo "Running Git commands..."

repository_path="$(cd "$(dirname "$0")" && pwd)"

cd "$repository_path" && git pull origin main

echo "Successfully pulled the updated version"

read -n 1 -s -r -p "Press any key to continue..."
