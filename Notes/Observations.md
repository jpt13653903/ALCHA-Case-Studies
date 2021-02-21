### Couple Observations (DSP chain)

- All clocks are resets are hidden in abstraction.  The parent module must 
  make sure the assign the correct clock and reset signals to whatever name 
  the DSP modules expect.
- The fixed-point type of Stream is defined as full-scale -1, which implies 
  that all assignments will be shifted accordingly.  A width mismatch is 
  therefore handled naturally and automatically by the implicit casting 
  followed by fixed-point assignment.
- The InWidth and OutWidth parameters are specified by the inherited class, 
  not the DSP stream.  This is quite typical of DSP-chains -- the resolution 
  is relatively fixed.  This can easily be changed though -- either a global 
  variable or a constructor parameter.
- All the classes (i.e. modules) are instantiated anonymously, so how does the 
  user get hold of the other class members?  One use case would be a debug 
  stream -- but that can be implemented quite easily, as with `DebugStream`
  in the example.  The DebugStream is assumed to be sufficiently buffered so 
  that it does not need to add back-pressure to the chain.
- The `FFT_2D` class assumes the presence of an external RAM
  interface -- **show how this is done -- the FFT modules should add 
  themselves to the bus by means of a function exposed by the external RAM 
  controller class, which is a global resource**.
- Metadata can be added to the `Stream` structure by means of a 
  `MetaData` base class, implemented as a reference, not an instance.  The 
  this-to-that operator also assigns the metadata, in that case.
- It is easy to see how one could expand the parameter list to add all sorts 
  of stuff...  The modules shown can easily be implemented as library 
  functions, and reused wherever.

