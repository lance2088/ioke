IOpt Action = Origin mimic
IOpt Action do(

  ValueActivation = IOpt Action mimic do (
    initialize = method(valueToActivate,
      init
      @valueToActivate = cell(:valueToActivate)
      @argumentsCode = cell(:valueToActivate) argumentsCode
      @documentation = cell(:valueToActivate) documentation)

    call = macro(call resendToValue(@cell(:valueToActivate), receiver))
    
  );ValueActivation

  CellActivation = IOpt Action mimic do (
    initialize = method(cellName,
      init
      @cellName = cellName)

    cell(:documentation) = method(
      @documentation = receiver cell(cellName) documentation)

    arity = method(
      @argumentsCode = receiver cell(cellName) argumentsCode
      @arity)
    
    call = macro(call resendToValue(receiver cell(cellName), receiver))
    
  );CellActivation

  CellAssignment = IOpt Action mimic do (
    initialize = method(cellName,
      init
      @cellName = cellName
      @documentation = "Set #{cellName asText}"
      @argumentsCode = cellName asText)

    call = method(value, receiver cell(cellName) = value)
    
  );CellAssinment

  MessageEvaluation = IOpt Action mimic do (
    initialize = method(messageToEval,
      init
      @documentation = "Evaluate message #{messageToEval code}"
      @messageToEval = messageToEval)

    call = dmacro(
      []
      messageToEval evaluateOn(call ground, receiver),

      [>value]
      messageToEval evaluateOn(call ground with(it: value), receiver))
    
  );MessageEvaluation

  init = method(
    @flags = set()
    @priority = 0
    @receiver = self
  )

  <=> = method("Compare by priority", other, priority <=> other priority)
  
  cell("priority=") = method("Set the option priority. 
    Default priority level is 0.
    Negative values are higher priority for options that
    must be processed before those having priority(0).
    Positive ones are executed just after all priority(0)",
    value,
    @cell(:priority) = value
    self)

  consume = method(argv,
    option = iopt cell("iopt:ion") call(argv first)
    if(option nil? || !flags include?(option flag),
      error!(NoActionForOption, 
        text: "Cannot handle flag %s not in ([%%s,%])" format(
          if(option, option flag, argv first), flags),
        option: if(option, option flag, argv first)))

    remnant = argv rest
    currentKey = nil
    args = list()
    klist = list()
    kmap = dict()
    
    if(option immediate && arity names length > 0, args << option immediate)

    shouldContinue = fn(arg, 
      cond(
        iopt[arg], false, ;; found next flag

        currentKey, true, ;; expecting value for a key arg
        
        !(arity names empty?) && !(arity keywords empty?), 
        (klist length + args length) < (info keywords length + info names length),

        arity names empty? && arity keywords empty?,
        arity krest || arity rest,
        
        arity names empty?,
        arity krest || klist length < arity keywords length,
        
        arity keywords empty?, 
        arity rest || args length < arity names length,
        
        false))

    idx = remnant findIndex(arg,
      cond(
        !shouldContinue(arg), true,
        
        (key = iopt cell("iopt:key") call(arg) && 
          arity krest || arity keywords include?(:(key name))),
        keyword = :(key name)
        if(kmap key?(keyword),
          error!(OptionKeywordAlreadyProvided, 
            text: "Keyword #{keyword} was specified more than once.",
            keyword: keyword),
          kmap[keyword] = key immediate
          if(key immediate, klist << keyword, currentKey = keyword))
        false,

        currentKey, ;; set last keyword if missing value
        klist << currentKey
        kmap[currentKey] = arg
        currentKey = nil,
        
        args << arg
        false))

    Origin with(
      flag: option flag, 
      remnant: remnant[(idx || 0-1)..-1],
      positional: args,
      keywords: kmap)
    
    );consume

  handle = method(optionArgs,
    messageName = optionArgs flag
    let(@cell(messageName), @cell(:call),
      optionArgs result = send(messageName, 
        *(optionArgs positional), *(optionArgs keywords)))
    optionArgs)

  cell("argumentsCode=") = method(code,
    if(code == "..." || code == "", code = nil)
    @cell(:argumentsCode) = code
    i = Origin with(names: [], keywords: [], rest: nil, krest: nil)
    unless(code, @arity = i. return(self))
    dummy = Message fromText("fn(#{code}, nil)")
    dummy = dummy evaluateOn(dummy)
    i names = dummy argumentNames
    i keywords = dummy keywords
    i rest = if(match = #/\\+([^: ,]+)/ match(code), :(match[1]))
    i krest = if(match = #/\\+:([^ ,]+)/ match(code), :(match[1]))
    @arity = i
    self)
  
); IOpt Action

