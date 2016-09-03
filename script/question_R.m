function A = input(filename)
fileinput = fopen('filename','r')
return fileinput
fclose(fileinput)
end