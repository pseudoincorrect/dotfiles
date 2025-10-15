; SQL language injection for Go strings
; Matches variables with "sql" or "SQL" in their names

; Short var declaration: foo_sql := `SELECT ...`
((short_var_declaration
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Short var declaration: foo_sql := "SELECT ..."
((short_var_declaration
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (interpreted_string_literal
      (interpreted_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Var declaration: var foo_sql = `SELECT ...`
((var_spec
  name: (identifier) @_var
  value: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Var declaration: var foo_sql = "SELECT ..."
((var_spec
  name: (identifier) @_var
  value: (expression_list
    (interpreted_string_literal
      (interpreted_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Assignment: fooSQL = `SELECT ...`
((assignment_statement
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Assignment: fooSQL = "SELECT ..."
((assignment_statement
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (interpreted_string_literal
      (interpreted_string_literal_content) @injection.content)))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Short var declaration with function call: querySQL := fmt.Sprintf(`SELECT ...`, args)
((short_var_declaration
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (raw_string_literal
          (raw_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Short var declaration with function call: querySQL := fmt.Sprintf("SELECT ...", args)
((short_var_declaration
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (interpreted_string_literal
          (interpreted_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Var declaration with function call: var querySQL = fmt.Sprintf(`SELECT ...`, args)
((var_spec
  name: (identifier) @_var
  value: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (raw_string_literal
          (raw_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Var declaration with function call: var querySQL = fmt.Sprintf("SELECT ...", args)
((var_spec
  name: (identifier) @_var
  value: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (interpreted_string_literal
          (interpreted_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Assignment with function call: querySQL = fmt.Sprintf(`SELECT ...`, args)
((assignment_statement
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (raw_string_literal
          (raw_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))

; Assignment with function call: querySQL = fmt.Sprintf("SELECT ...", args)
((assignment_statement
  left: (expression_list (identifier) @_var)
  right: (expression_list
    (call_expression
      arguments: (argument_list
        .
        (interpreted_string_literal
          (interpreted_string_literal_content) @injection.content)))))
 (#lua-match? @_var "[Ss][Qq][Ll]")
 (#set! injection.language "sql"))
