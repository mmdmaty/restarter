from restarter import *


def main():
    old_data = json_reader().get('user_count')
    new_data = get_data().get('user_count')


    if old_data != new_data:
        create_update_json()
        return command_runner("x-ui restart")
    
if __name__ == "__main__":
    main()