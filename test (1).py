import sys
import socket
import requests
import json


def main():
    if len(sys.argv) > 1:
        host_name = sys.argv[1]
        host_ip = socket.gethostbyname(host_name)
    else:
        host_ip = json.loads(requests.get('https://api.ipify.org?format=json').text)['ip']

    response_text = requests.get(f'http://ip-api.com/json/{host_ip}').text
    response_dict = json.loads(response_text)
    res = f'Country: {response_dict["country"]}, Region: {response_dict["regionName"]}, City: {response_dict["city"]}'
    print(res)


if __name__ == '__main__':
    main()