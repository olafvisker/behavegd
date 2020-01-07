# behavegd
A behaviour tree implementation for Godot in GDScript. Behaviour trees control the flow and execution of finite states and allow for complex behaviours to be created using simple modular building blocks. For more information on behaviour trees check out [this link](https://github.com/libgdx/gdx-ai/wiki/Behavior-Trees).


# example
**Behaviours**
```python
class_name ExampleBehaviours

static func Wander(radius, wait):
	return  Composites.Sequence.new([
            AgentFindWanderPoint.new(radius, "l:move"),
            AgentMove.new("l:move"),
            AgentWait.new(wait)
			    ])
```

**Nodes**
```python
extends Behaviour
class_name AgentFindWanderPoint

var _radius
var _location
var _key
var _valid

func _init(radius, key): 
	_radius = radius
	_key = key
	
func initialize(actor, blackboard): 
	_location = Vector3(rand_range(-_radius, _radius), 0, rand_range(-_radius, _radius))
	_valid = actor.is_walkable_location(_location)
	
func update(actor, blackboard, delta): 
	if not _valid: return Status.FAILURE
	blackboard.store(_key, _location)
	return Status.SUCCESS
```

```python
extends Behaviour
class_name AgentMove

var target 

var _key
var _start
var _distance

func _init(key): _key = key

func initialize(actor, blackboard):
	target = blackboard.get(_key)
	_start = actor.translation
	_distance = _start.distance_squared_to(target)

func update(actor, blackboard, delta):
	if not target: return Status.FAILURE
	if _start.distance_squared_to(pos) >= _distance: return Status.SUCCESS
	actor.move(target)
	return Status.RUNNING
```

```python
extends Behaviour
class_name UnitWait

var _counter = 0
var _time = 0

func _init(time): time = _time

func initialize(actor, blackboard): 
	counter = 0

func update(actor, blackboard, delta):
	if _counter >= _time: return Status.SUCCESS
	_counter += delta
	return Status.RUNNING
```

**Agent**
```python
extends Node
class_name Agent

var behave = BehaviourTree.new(self)

func _ready():
  behave.set_behaviour(ExampleBehaviours.Wander(10, 1))
```

**Extra**
```python
static func MoveToActiveObject(object_key, location_key):
	return Composites.Parallel.new(	Composites.Policy.ALL, [
										Decorators.Inverser(AgentObjectInvalid.new(object_key)),
										AgentMove.new(location_key)
									])
									
static func CutTrees():
	return 	Composites.Sequence.new([
				AgentFindObject.new("trees", "o:tree", "l:tree"),
				MoveToActiveObject("o:tree", "l:tree"),
				AgentDestroy.new("o:tree")
			])
```

**enjoy!**
