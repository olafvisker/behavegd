class_name Composites

enum Policy { ALL, ONE }


class Composite extends Behaviour:
	var children = []
	func _init(children): self.children = children
	func terminate(status):
		for child in children:
			if child.is_running(): 
				child.abort()

class Sequence extends Composite:
	var index
	func _init(children).(children): pass
	func initialize(actor, blackboard): index = 0
	func update(actor, blackboard, delta):
		while(true):
			var status = children[index].tick(actor, blackboard, delta)
			if status != Status.SUCCESS: return status
			index += 1
			if index == children.size(): return Status.SUCCESS
		#return Status.RUNNING #SPREADS OUT EXECUTING OF CHILDREN OVER MULTIPLE FRAMES
		
class Selector extends Composite:
	var index
	func _init(children).(children): pass
	func initialize(actor, blackboard): index = 0
	func update(actor, blackboard, delta):
		while(true):
			var status = children[index].tick(actor, blackboard, delta)
			if status != Status.FAILURE: return status
			index += 1
			if index == children.size(): return Status.FAILURE
		#return Status.RUNNING #SPREADS OUT EXECUTING OF CHILDREN OVER MULTIPLE FRAMES
			
class Parallel extends Composite:
	var policy = Policy.ALL
	
	func _init(policy, children).(children): self.policy = policy
	func update(actor, blackboard, delta):
		var successes = 0
		var failures = 0
		for i in range(children.size()):
			var status = children[i].tick(actor, blackboard, delta)
			if status == Status.SUCCESS: successes += 1
			if status == Status.FAILURE: failures += 1
			
			if policy == Policy.ALL and failures > 0: return Status.FAILURE
			if policy == Policy.ALL and successes == children.size(): return Status.SUCCESS
			if policy == Policy.ONE and successes > 0: return Status.SUCCESS
			if policy == Policy.ONE and failures == children.size(): return Status.FAILURE
		return Status.RUNNING