import requests
import argparse

# Replace with your Todoist API token
API_TOKEN = '858b9c600d7aea4cac6d1f7e474506846665056b'
# Replace with the ID of the project you want to add a task to
PROJECT_ID = '2345819116'

def main() -> None:
    parser = argparse.ArgumentParser(description='Add todoist to shared inbox')
    parser.add_argument('-c', '--content', type=str, required=True, help='The content to add to the inbox')
    parser.add_argument('-p', '--project', type=str, default=PROJECT_ID, help='The project id to add to')
    parser.add_argument('-a', '--auth', type=str, default=API_TOKEN, help='Bearer token to utilize')

    args = parser.parse_args()

    endpoint = "https://api.todoist.com/rest/v2/tasks"

    # Set the API endpoint and headers
    headers = {
        "Authorization": f"Bearer {args.auth}",
        "Content-Type": "application/json"
    }

    # Prepare the data for the new task
    data = {
        "content": args.content,
        "project_id": args.project
    }

    response = requests.post(endpoint, headers=headers, json=data)
 
    # Check if the request was successful
    if response.status_code == 200:
        print("Task added successfully:", response.json())
    else:
        print(f"Failed to add task: {response.status_code} - {response.text}")


if __name__ == '__main__':
    main()
