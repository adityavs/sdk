//
// THIS FILE IS GENERATED. DO NOT EDIT.
//
// Instead modify 'pkg/front_end/messages.yaml' and run
// 'dart pkg/analyzer/tool/messages/generate.dart' to update.

part of 'syntactic_errors.dart';

final fastaAnalyzerErrorCodes = <ErrorCode>[
  null,
  _EQUALITY_CANNOT_BE_EQUALITY_OPERAND,
  _CONTINUE_OUTSIDE_OF_LOOP,
  _EXTERNAL_CLASS,
  _STATIC_CONSTRUCTOR,
  _EXTERNAL_ENUM,
  _PREFIX_AFTER_COMBINATOR,
  _TYPEDEF_IN_CLASS,
  _COVARIANT_AFTER_VAR,
  _INVALID_AWAIT_IN_FOR,
  _IMPORT_DIRECTIVE_AFTER_PART_DIRECTIVE,
  _WITH_BEFORE_EXTENDS,
  _VAR_RETURN_TYPE,
  _TYPE_ARGUMENTS_ON_TYPE_VARIABLE,
  _TOP_LEVEL_OPERATOR,
  _SWITCH_HAS_MULTIPLE_DEFAULT_CASES,
  _SWITCH_HAS_CASE_AFTER_DEFAULT_CASE,
  _STATIC_OPERATOR,
  _STATIC_AFTER_VAR,
  _STATIC_AFTER_FINAL,
  _STATIC_AFTER_CONST,
  _REDIRECTION_IN_NON_FACTORY_CONSTRUCTOR,
  _REDIRECTING_CONSTRUCTOR_WITH_BODY,
  _NATIVE_CLAUSE_SHOULD_BE_ANNOTATION,
  _MULTIPLE_WITH_CLAUSES,
  _MULTIPLE_PART_OF_DIRECTIVES,
  _MULTIPLE_ON_CLAUSES,
  _MULTIPLE_LIBRARY_DIRECTIVES,
  _MULTIPLE_EXTENDS_CLAUSES,
  _MISSING_STATEMENT,
  _MISSING_PREFIX_IN_DEFERRED_IMPORT,
];

const ParserErrorCode _CONTINUE_OUTSIDE_OF_LOOP = const ParserErrorCode(
    'CONTINUE_OUTSIDE_OF_LOOP',
    r"A continue statement can't be used outside of a loop or switch statement.",
    correction: "Try removing the continue statement.");

const ParserErrorCode _COVARIANT_AFTER_VAR = const ParserErrorCode(
    'COVARIANT_AFTER_VAR',
    r"The modifier 'covariant' should be before the modifier 'var'.",
    correction: "Try re-ordering the modifiers.");

const ParserErrorCode _EQUALITY_CANNOT_BE_EQUALITY_OPERAND = const ParserErrorCode(
    'EQUALITY_CANNOT_BE_EQUALITY_OPERAND',
    r"An equality expression can't be an operand of another equality expression.",
    correction: "Try re-writing the expression.");

const ParserErrorCode _EXTERNAL_CLASS = const ParserErrorCode(
    'EXTERNAL_CLASS', r"Classes can't be declared to be 'external'.",
    correction: "Try removing the keyword 'external'.");

const ParserErrorCode _EXTERNAL_ENUM = const ParserErrorCode(
    'EXTERNAL_ENUM', r"Enums can't be declared to be 'external'.",
    correction: "Try removing the keyword 'external'.");

const ParserErrorCode _IMPORT_DIRECTIVE_AFTER_PART_DIRECTIVE =
    const ParserErrorCode('IMPORT_DIRECTIVE_AFTER_PART_DIRECTIVE',
        r"Import directives must preceed part directives.",
        correction:
            "Try moving the import directives before the part directives.");

const ParserErrorCode _INVALID_AWAIT_IN_FOR = const ParserErrorCode(
    'INVALID_AWAIT_IN_FOR',
    r"The keyword 'await' isn't allowed for a normal 'for' statement.",
    correction: "Try removing the keyword, or use a for-each statement.");

const ParserErrorCode _MISSING_PREFIX_IN_DEFERRED_IMPORT =
    const ParserErrorCode('MISSING_PREFIX_IN_DEFERRED_IMPORT',
        r"Deferred imports should have a prefix.",
        correction: "Try adding a prefix to the import.");

const ParserErrorCode _MISSING_STATEMENT =
    const ParserErrorCode('MISSING_STATEMENT', r"Expected a statement.");

const ParserErrorCode _MULTIPLE_EXTENDS_CLAUSES = const ParserErrorCode(
    'MULTIPLE_EXTENDS_CLAUSES',
    r"Each class definition can have at most one extends clause.",
    correction:
        "Try choosing one superclass and define your class to implement (or mix in) the others.");

const ParserErrorCode _MULTIPLE_LIBRARY_DIRECTIVES = const ParserErrorCode(
    'MULTIPLE_LIBRARY_DIRECTIVES',
    r"Only one library directive may be declared in a file.",
    correction: "Try removing all but one of the library directives.");

const ParserErrorCode _MULTIPLE_ON_CLAUSES = const ParserErrorCode(
    'MULTIPLE_ON_CLAUSES',
    r"Each mixin definition can have at most one on clause.",
    correction: "Try combining all of the on clauses into a single clause.");

const ParserErrorCode _MULTIPLE_PART_OF_DIRECTIVES = const ParserErrorCode(
    'MULTIPLE_PART_OF_DIRECTIVES',
    r"Only one part-of directive may be declared in a file.",
    correction: "Try removing all but one of the part-of directives.");

const ParserErrorCode _MULTIPLE_WITH_CLAUSES = const ParserErrorCode(
    'MULTIPLE_WITH_CLAUSES',
    r"Each class definition can have at most one with clause.",
    correction: "Try combining all of the with clauses into a single clause.");

const ParserErrorCode _NATIVE_CLAUSE_SHOULD_BE_ANNOTATION = const ParserErrorCode(
    'NATIVE_CLAUSE_SHOULD_BE_ANNOTATION',
    r"Native clause in this form is deprecated.",
    correction:
        "Try removing this native clause and adding @native() or @native('native-name') before the declaration.");

const ParserErrorCode _PREFIX_AFTER_COMBINATOR = const ParserErrorCode(
    'PREFIX_AFTER_COMBINATOR',
    r"The prefix ('as' clause) should come before any show/hide combinators.",
    correction: "Try moving the prefix before the combinators.");

const ParserErrorCode _REDIRECTING_CONSTRUCTOR_WITH_BODY = const ParserErrorCode(
    'REDIRECTING_CONSTRUCTOR_WITH_BODY',
    r"Redirecting constructors can't have a body.",
    correction:
        "Try removing the body, or not making this a redirecting constructor.");

const ParserErrorCode _REDIRECTION_IN_NON_FACTORY_CONSTRUCTOR =
    const ParserErrorCode('REDIRECTION_IN_NON_FACTORY_CONSTRUCTOR',
        r"Only factory constructor can specify '=' redirection.",
        correction:
            "Try making this a factory constructor, or remove the redirection.");

const ParserErrorCode _STATIC_AFTER_CONST = const ParserErrorCode(
    'STATIC_AFTER_CONST',
    r"The modifier 'static' should be before the modifier 'const'.",
    correction: "Try re-ordering the modifiers.");

const ParserErrorCode _STATIC_AFTER_FINAL = const ParserErrorCode(
    'STATIC_AFTER_FINAL',
    r"The modifier 'static' should be before the modifier 'final'.",
    correction: "Try re-ordering the modifiers.");

const ParserErrorCode _STATIC_AFTER_VAR = const ParserErrorCode(
    'STATIC_AFTER_VAR',
    r"The modifier 'static' should be before the modifier 'var'.",
    correction: "Try re-ordering the modifiers.");

const ParserErrorCode _STATIC_CONSTRUCTOR = const ParserErrorCode(
    'STATIC_CONSTRUCTOR', r"Constructors can't be static.",
    correction: "Try removing the keyword 'static'.");

const ParserErrorCode _STATIC_OPERATOR = const ParserErrorCode(
    'STATIC_OPERATOR', r"Operators can't be static.",
    correction: "Try removing the keyword 'static'.");

const ParserErrorCode _SWITCH_HAS_CASE_AFTER_DEFAULT_CASE =
    const ParserErrorCode('SWITCH_HAS_CASE_AFTER_DEFAULT_CASE',
        r"The default case should be the last case in a switch statement.",
        correction:
            "Try moving the default case after the other case clauses.");

const ParserErrorCode _SWITCH_HAS_MULTIPLE_DEFAULT_CASES =
    const ParserErrorCode('SWITCH_HAS_MULTIPLE_DEFAULT_CASES',
        r"The 'default' case can only be declared once.",
        correction: "Try removing all but one default case.");

const ParserErrorCode _TOP_LEVEL_OPERATOR = const ParserErrorCode(
    'TOP_LEVEL_OPERATOR', r"Operators must be declared within a class.",
    correction:
        "Try removing the operator, moving it to a class, or converting it to be a function.");

const ParserErrorCode _TYPEDEF_IN_CLASS = const ParserErrorCode(
    'TYPEDEF_IN_CLASS', r"Typedefs can't be declared inside classes.",
    correction: "Try moving the typedef to the top-level.");

const ParserErrorCode _TYPE_ARGUMENTS_ON_TYPE_VARIABLE = const ParserErrorCode(
    'TYPE_ARGUMENTS_ON_TYPE_VARIABLE',
    r"Can't use type arguments with type variable '#name'.",
    correction: "Try removing the type arguments.");

const ParserErrorCode _VAR_RETURN_TYPE = const ParserErrorCode(
    'VAR_RETURN_TYPE', r"The return type can't be 'var'.",
    correction:
        "Try removing the keyword 'var', or replacing it with the name of the return type.");

const ParserErrorCode _WITH_BEFORE_EXTENDS = const ParserErrorCode(
    'WITH_BEFORE_EXTENDS',
    r"The extends clause must be before the with clause.",
    correction: "Try moving the extends clause before the with clause.");
