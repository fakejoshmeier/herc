import requests
import sys
import os

#File open/Usage
if len(sys.argv) > 1:
	with open(sys.argv[1]) as list:
		users = list.readlines()
else:
	print("USAGE: python antler.py [file]")
	exit()

#Token get. zshrc has my stuffs.  Just in case one of you fools has an eidetic memory
data = {'grant_type': 'client_credentials',
'client_id': os.environ["FT42_UID"],
'client_secret': os.environ["FT42_SECRET"]}
e = requests.post('https://api.intra.42.fr/oauth/token', data=data)
if e.status_code != 200:
	print (e.status_code)
	print("What we have here is a failure to communicate.")
	exit()
jason = e.json()
if "access_token" not in jason:
	print("ACCESS DENIED.  BITCH.")
	exit()
args = [
	'access_token=%s' % (jason['access_token']),
	'token_type=bearer',
	'filter[active]=true'
]

#The loop
for uid in users:
	uid = uid.strip()
	status = requests.get("https://api.intra.42.fr/v2/users/" + uid + 
	"/locations?%s" % ("&".join(args)))
	if status.status_code == 200:
		location = status.json()
		if len(location) > 0:
			print("User \"" + uid + "\" can be found at " + location[0]['host'] + ".")
		else:
			print("User \"" + uid + "\" is not currently logged in.")
	elif status.status_code == 404:
		print("User \"" + uid + "\" does not exist.")
	elif status.status_code == 401:
		print("Bad credentials.")