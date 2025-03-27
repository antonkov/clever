import Imports.AllImports

-- start_def problem_details
/--
function_signature: "def separate_paren_groups(paren_string: str) -> List[str]"
docstring: |
    Input to this function is a string containing multiple groups of nested parentheses. Your goal is to
    separate those group into separate strings and return the list of those.
    Separate groups are balanced (each open brace is properly closed) and not nested within each other
    Ignore any spaces in the input string.
test_cases:
  - input: "( ) (( )) (( )( ))"
    expected_output:
      - "()"
      - "(())"
      - "(()())"
-/
-- end_def problem_details

-- start_def problem_spec
def problem_spec
-- function signature
(impl: String → List String)
-- inputs
(paren_string: String) :=
-- spec
let paren_string_filtered := (paren_string.toList.filter (fun c => c == '(' ∨  c == ')')).asString;
let forward_spec (result_list: List String) :=
-- every substring of the input string
-- that is a balanced paren group is in
-- the result list
∀ i j, j < paren_string_filtered.length → i ≤ j →
let substr_ij := (paren_string_filtered.take (j + 1)).drop i;
string_is_paren_balanced substr_ij →
count_paren_groups substr_ij = 1 →
substr_ij ∈ result_list;
let backward_spec (result_list: List String) :=
-- every string in the result list is a
-- balanced paren group and is a substring
-- of the input string i.e. there is no
-- extra substring in the result list
-- that is not from the input string
∀ str, str ∈ result_list →
paren_string_filtered.containsSubstr str = true ∧
string_is_paren_balanced str ∧
count_paren_groups str = 1;
let spec (result_list: List String) :=
forward_spec result_list ∧ backward_spec result_list;
-- program terminates
∃ result, impl paren_string = result →
-- return value satisfies spec
spec result
-- end_def problem_spec

-- start_def implementation_signature
def implementation (paren_string: String) : List String :=
-- end_def implementation_signature
-- start_def implementation
-- remove space or any other characters that are not '(' or ')'
let filtered := paren_string.toList.filter (fun c => c == '(' ∨  c == ')');
-- auxiliary recursive function:
let rec aux (cs : List Char) (cur : List Char) (balance : Int) (acc : List String) : List String :=
  match cs with
  | []      => acc.reverse  -- when finished, return accumulated groups in original order
  | c::rest =>
    let new_cur    := cur ++ [c]
    let new_balance:= if c = '(' then
                      balance + 1
                      else
                      balance - 1
    if new_balance = 0 then
      let group := new_cur.asString
      aux rest [] 0 (group :: acc)
    else
      aux rest new_cur new_balance acc;
aux filtered [] 0 []
-- end_def implementation

-- Uncomment the following test cases after implementing the function
-- start_def test_cases
#test implementation "( ) (( )) (( )( ))" = ["()", "(())", "(()())"]
-- end_def test_cases

-- start_def correctness_definition
theorem correctness
(paren_string: String)
: problem_spec implementation paren_string :=
-- end_def correctness_definition
-- start_def correctness_proof
by
unfold problem_spec
let result := implementation paren_string
use result
simp [result]
sorry
-- end_def correctness_proof
