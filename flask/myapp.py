#!/bin/python
import re,os, subprocess,scandir
from flask import Flask, render_template, send_file, request
 
app = Flask(__name__)
 
#
#   pipe it to use linux command
#
def cmdline(command):
	process = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)	
	return process.communicate()[0]

def getFileName(testvpxfile):
	currentDir="templates/gensummary/logs"
	for paths,dirs,files in scandir.walk(currentDir):
		
		for f in files:
			if testvpxfile in f:
				return f
			

@app.route('/')
def home():
    return render_template('index.html')


@app.route('/gensummary', methods=['GET','POST'])
def gensummary():

	cmdline("cd templates/gensummary/logs ; rm -f *")
	locationFile = request.form['lsinput'] 

	if locationFile:

		print locationFile
		#download files into templates/gensummary/logs
		cmdline("cd templates/gensummary/logs ; wget " + '"' + locationFile + '"')

		# get filename
		fname = getFileName("test-vpx")
		print "downloaded: " + fname

		#create log summary
		cmdline("cd templates/gensummary/logs ; createlogsummary.py ")

		filename = getFileName("summary-")
		print "Summary file: " + filename

		return render_template('/gensummary/index.html', fname=filename)



@app.route('/sendfile/<path:filename>', methods=['GET'])
def sendfile(filename):
    #send_file(os.path.join('templates/gensummary/logs', filename))
    return send_file(os.path.join('templates/gensummary/logs', filename), mimetype='text/plain')


if __name__ == '__main__':
	#app.run(debug=True)
	app.run()

