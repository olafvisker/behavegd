class_name Blackboard

var _memory = {}

func contains(key): return _memory.has(key)
func store(key, value): _memory[key] = value
func get(key): 
    if contains(key): return _memory[key]
    return false
func forget(key): _memory.erase(key)
func clear(): _memory.clear()
