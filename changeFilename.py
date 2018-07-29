import os, subprocess

def renameFile(findStr1, findStr2):
  for root, dirs, files in os.walk(".", topdown=False):
    for f in files:

      path = os.path.join(root,f)
      if f.endswith(findStr1):
         ipTMP = subprocess.Popen(["cat " + path + " | grep -iE 'hosts reserved' | awk '{print $NF}' | cut -d. -f1-4"],stdout=subprocess.PIPE, shell=True)
         IP = ipTMP.communicate()[0]
         IP = IP[:-1]

      if f.endswith(findStr2):
         oldfile = os.path.dirname(path) + "/" + f     
         
         name, ext = os.path.splitext(f)
         newfile = os.path.dirname(path) + "/" + name + "-vsan-"+ IP + ".txt"
         
         if "-vsan-" not in f: 
           try:
             print oldfile + "----->" + newfile
             os.rename(oldfile, newfile)
           except Exception as e:
             print "unable to rename file"
        

renameFile("_c1.log", "-c1.txt")
renameFile("_c2.log", "-c2.txt")

