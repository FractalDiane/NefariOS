extends Reference
class_name DirectoryNode


var directory_name = ""
var links: Array
var contents: Array


func _to_string() -> String:
	var s = []
	for c in links:
		s.append(c.directory_name)
	return str(directory_name) + " " + str(s) + " " + str(contents)
