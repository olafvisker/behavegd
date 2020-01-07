class_name Behaviour

enum Status {
    INVALID,
    SUCCESS,
    FAILURE,
    RUNNING,
    ABORT,    
}

var status = Status.INVALID

func initialize(actor, blackboard): pass
func update(actor, blackboard, delta): return Status.INVALID
func terminate(status): pass

func is_running():
    return status == Status.RUNNING

func abort():
    terminate(Status.ABORT)
    status = Status.ABORT

func tick(actor, blackboard, delta): 
    if status != Status.RUNNING: initialize(actor, blackboard)
    status = update(actor, blackboard, delta)
    if status != Status.RUNNING: terminate(status)
    return status