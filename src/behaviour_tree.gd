class_name BehaviourTree

var actor = null
var behaviour = null
var blackboard = Blackboard.new()

func _init(actor): 
	self.actor = actor

func set_behaviour(behaviour):
    self.behaviour = behaviour

func update(delta):
	if behaviour == null: return
	behaviour.tick(actor, blackboard, delta)