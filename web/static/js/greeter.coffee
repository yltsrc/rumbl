Greet =
  greet: -> console.log("Hello!")

Bye =
  greet: -> console.log("Bye!")

module.exports =
  Greet: Greet
  Bye: Bye
