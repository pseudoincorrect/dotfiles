; /home/mclement/git/helix/runtime/queries/python/injections.scm

(
  (comment) @injection.content
  (#set! injection.language "comment")
)

(string 
  (string_content) @injection.content
    ; this matcher will break the injection at the first {VAL} in python formatted string
    ; (#match? @injection.content "^--sql")
    ; this matcher will break but then match again thus works better
    (#match? @injection.content "^\w*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
    (#set! injection.language "sql"))

(call
  function: (attribute attribute: (identifier) @id (#match? @id "execute|read_sql"))
  arguments: (argument_list
    (string (string_content) @injection.content (#set! injection.language "sql"))))
