appcast_path = 'docs/Support/appcast.xml'

def get_new_version():
    with open('new_version', 'r') as f:
        return f.read()

def get_last_item_indexes():
    with open(appcast_path, 'r') as f:
        lines = f.readlines()
        start_index = 0
        for line in lines:
            if '<item>' in line:
                start_index = lines.index(line)
        end_index = 0
        for line in lines:
            if '</item>' in line:
                end_index = lines.index(line)
                return lines, start_index, end_index

def get_last_item():
    lines, start_index, end_index = get_last_item_indexes()
    return "".join(lines[start_index:end_index+1])

def remove_last_item_of_appcast():
    lines, start_index, end_index = get_last_item_indexes()
    lines = lines[:start_index] + lines[end_index+1:]
    with open(appcast_path, 'w') as f:
        f.writelines(lines)
    

if __name__ == '__main__':
    new_version = get_new_version()
    last_item = get_last_item()
    if new_version in last_item:
        print('new_version is in last_item')
        if 'beta' in last_item:
            print('last_item is a beta item')
            remove_last_item_of_appcast()
            print("removed last_item from appcast.xml")
        else:
            print('last_item is not a beta item. keeping it.')