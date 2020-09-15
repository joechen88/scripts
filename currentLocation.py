import os
import socket


def getFileLocation():
    root_dir = os.getcwd()
    print "current directory:: " + root_dir
    file_set = set()     # declare an empty - sorted element
    print socket.gethostname()




#dir: The next directory it found.
#subDirs: A list of sub-directories in the current directory.
#file: A list of files in the current directory.

    file = open("output.txt", "w")

    for dir, subDir, files in os.walk(root_dir):
        #print subDir
        for file_name in files:
            rel_dir = os.path.relpath(dir, root_dir)
            #print "rel_dir::" + rel_dir
            rel_file = os.path.join(rel_dir, file_name)
            tmpRel_file = root_dir + "/" + rel_file
            file_set.add(tmpRel_file)
            file.write(tmpRel_file+"\n")


    file.close()




def getLocalFolder():
    path=str(os.path.dirname(os.path.abspath(__file__))).split('\\')
    return path[len(path)-1]


def main():
    getFileLocation()
    #a = getLocalFolder()
    #print a


if __name__ == "__main__":
    main()
