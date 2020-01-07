class_name Decorators

class Decorator extends Behaviour:
	var child
	func _init(child): self.child = child
	func terminate(status):
	    if child.is_running(): 
	        child.abort()

class Chance extends Decorator:
	var chance
	func _init(chance, child).(child): self.chance = chance
	func update(actor, blackboard, delta): 
		if randi() % 100 < chance: 
			return child.tick(actor, blackboard, delta)
		return Status.FAILURE

class Inverser extends Decorator:
	func _init(child).(child): pass
	func update(actor, blackboard, delta):
		var status = child.tick(actor, blackboard, delta)
		if status == Status.SUCCESS: return Status.FAILURE
		if status == Status.FAILURE: return Status.SUCCESS
		return Status.RUNNING

class Repeater extends Decorator:
	var amount
	var counter
	func _init(amount, child).(child): self.amount = amount
	func initialize(actor, blackboard): counter = 0
	func update(actor, blackboard, delta):
		while(true):
			var status = child.tick(actor, blackboard, delta)
			if status == Status.RUNNING: break
			if status == Status.FAILURE: return Status.FAILURE
			counter += 1
			if counter >= amount: return Status.SUCCESS
		return Status.RUNNING
