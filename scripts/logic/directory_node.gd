extends Reference
class_name DirectoryNode


var directory_name := ""
var links: Array
var contents: Array


func all_files_corrupted() -> bool:
	for f in contents:
		if not f.is_corrupted and f.can_be_corrupted:
			return false
			
	return true


func _to_string() -> String:
	var s = []
	for c in links:
		s.append(c.directory_name)
	return str(directory_name) + " " + str(s) + " " + str(contents)
