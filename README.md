Interpreter
===========

A simple interpreter for an arithmetic language, written in Swift.

## Grammar

```
 expression := signed_term sum_op
 sum_op := (+,-) term sum_op
 signed_term := (+,-) term
 term := factor term_op
 term_op := (*,/) factor term_op
 signed_factor := (+/-) factor
 factor := argument factor_op
 factor_op := ^ expr
 expr := number
 ```
 
## Supported expressions
 
 Simple arithmetic operations are supported, where priorities can be forced by parentheses. No real type system yet,
 all results come out as ```Float```s. Simple mathematical functions can be applied
 (```sin, cos, tan, asin, acos, atan, sqrt, ln, log, log2, exp```).
 
## Notes
 
 It is in no way optimized or efficient, and error detector is kept to its absolute minimum so far.
 This project was started solely for educational purposes, which is also why you're welcome to 
 point out improvements or points of interest ! Ping me on twitter [@dtsbourg](https://twitter.com/dtsbourg) :)
 
## References
 
 * http://www.codeproject.com/Articles/345888/How-to-write-a-simple-interpreter-in-JavaScript
 * http://cogitolearning.co.uk/?p=573
 * @romac 
 
