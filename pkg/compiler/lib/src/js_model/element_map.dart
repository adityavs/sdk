// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:kernel/ast.dart' as ir;

import '../common.dart';
import '../constants/values.dart';
import '../common_elements.dart' show JCommonElements, JElementEnvironment;
import '../elements/entities.dart';
import '../elements/jumps.dart';
import '../elements/names.dart';
import '../elements/types.dart';
import '../js/js.dart' as js;
import '../js_backend/namer.dart';
import '../js_emitter/code_emitter_task.dart';
import '../js_model/closure.dart' show JRecordField, KernelScopeInfo;
import '../js_model/elements.dart' show JGeneratorBody;
import '../kernel/element_map.dart';
import '../native/native.dart' as native;
import '../ssa/type_builder.dart';
import '../types/abstract_value_domain.dart';
import '../universe/call_structure.dart';
import '../universe/selector.dart';
import '../world.dart';

/// Interface that translates between Kernel IR nodes and entities used for
/// global type inference and building the SSA graph for members.
abstract class JsToElementMap {
  /// Access to the commonly used elements and types.
  JCommonElements get commonElements;

  /// Access to the [DartTypes] object.
  DartTypes get types;

  /// Returns the [DartType] corresponding to [type].
  DartType getDartType(ir.DartType type);

  /// Returns the [InterfaceType] corresponding to [type].
  InterfaceType getInterfaceType(ir.InterfaceType type);

  /// Returns the [TypeVariableType] corresponding to [type].
  TypeVariableType getTypeVariableType(ir.TypeParameterType type);

  /// Returns the [FunctionType] of the [node].
  FunctionType getFunctionType(ir.FunctionNode node);

  /// Return the [InterfaceType] corresponding to the [cls] with the given
  /// [typeArguments].
  InterfaceType createInterfaceType(
      ir.Class cls, List<ir.DartType> typeArguments);

  /// Returns the [CallStructure] corresponding to the [arguments].
  CallStructure getCallStructure(ir.Arguments arguments);

  /// Returns the [Selector] corresponding to the invocation or getter/setter
  /// access of [node].
  Selector getSelector(ir.Expression node);

  /// Returns the [MemberEntity] corresponding to the member [node].
  MemberEntity getMember(ir.Member node);

  /// Returns the [FunctionEntity] corresponding to the procedure [node].
  FunctionEntity getMethod(ir.Procedure node);

  /// Returns the [ConstructorEntity] corresponding to the generative or factory
  /// constructor [node].
  ConstructorEntity getConstructor(ir.Member node);

  /// Returns the [FieldEntity] corresponding to the field [node].
  FieldEntity getField(ir.Field node);

  /// Returns the [ClassEntity] corresponding to the class [node].
  ClassEntity getClass(ir.Class node);

  /// Returns the [TypedefType] corresponding to raw type of the typedef [node].
  TypedefType getTypedefType(ir.Typedef node);

  /// Returns the super [MemberEntity] for a super invocation, get or set of
  /// [name] from the member [context].
  ///
  /// The IR doesn't always resolve super accesses to the corresponding
  /// [target]. If not, the target is computed using [name] and [setter] from
  /// the enclosing class of [context].
  MemberEntity getSuperMember(
      MemberEntity context, ir.Name name, ir.Member target,
      {bool setter: false});

  /// Returns the `noSuchMethod` [FunctionEntity] call from a
  /// `super.noSuchMethod` invocation within [cls].
  FunctionEntity getSuperNoSuchMethod(ClassEntity cls);

  /// Returns the [Name] corresponding to [name].
  Name getName(ir.Name name);

  /// Computes the [native.NativeBehavior] for a call to the [JS] function.
  native.NativeBehavior getNativeBehaviorForJsCall(ir.StaticInvocation node);

  /// Computes the [native.NativeBehavior] for a call to the [JS_BUILTIN]
  /// function.
  native.NativeBehavior getNativeBehaviorForJsBuiltinCall(
      ir.StaticInvocation node);

  /// Computes the [native.NativeBehavior] for a call to the
  /// [JS_EMBEDDED_GLOBAL] function.
  native.NativeBehavior getNativeBehaviorForJsEmbeddedGlobalCall(
      ir.StaticInvocation node);

  /// Returns the [js.Name] for the `JsGetName` [constant] value.
  js.Name getNameForJsGetName(ConstantValue constant, Namer namer);

  /// Computes the [ConstantValue] for the constant [expression].
  // TODO(johnniwinther): Move to [KernelToElementMapForBuilding]. This is only
  // used in impact builder for symbol constants.
  ConstantValue getConstantValue(ir.Expression expression,
      {bool requireConstant: true, bool implicitNull: false});

  /// Return the [ImportEntity] corresponding to [node].
  ImportEntity getImport(ir.LibraryDependency node);

  /// Returns the definition information for [cls].
  ClassDefinition getClassDefinition(covariant ClassEntity cls);

  /// Returns the static type of [node].
  // TODO(johnniwinther): This should be provided directly from kernel.
  DartType getStaticType(ir.Expression node);

  /// [ElementEnvironment] for library, class and member lookup.
  JElementEnvironment get elementEnvironment;

  /// Returns the list of [DartType]s corresponding to [types].
  List<DartType> getDartTypes(List<ir.DartType> types);

  /// Returns the definition information for [member].
  MemberDefinition getMemberDefinition(covariant MemberEntity member);

  /// Returns the type of `this` in [member], or `null` if member is defined in
  /// a static context.
  InterfaceType getMemberThisType(covariant MemberEntity member);

  /// Returns how [member] has access to type variables of the this type
  /// returned by [getMemberThisType].
  ClassTypeVariableAccess getClassTypeVariableAccessForMember(
      MemberEntity member);

  /// Returns the [LibraryEntity] corresponding to the library [node].
  LibraryEntity getLibrary(ir.Library node);

  /// Returns the [js.Template] for the `JsBuiltin` [constant] value.
  js.Template getJsBuiltinTemplate(
      ConstantValue constant, CodeEmitterTask emitter);

  /// Return the [ConstantValue] the initial value of [field] or `null` if
  /// the initializer is not a constant expression.
  ConstantValue getFieldConstantValue(FieldEntity field);

  /// Returns a [Spannable] for a message pointing to the IR [node] in the
  /// context of [member].
  Spannable getSpannable(MemberEntity member, ir.Node node);

  /// Returns the constructor body entity corresponding to [constructor].
  FunctionEntity getConstructorBody(ir.Constructor node);

  /// Returns the constructor body entity corresponding to [function].
  JGeneratorBody getGeneratorBody(FunctionEntity function);

  /// Make a record to ensure variables that are are declared in one scope and
  /// modified in another get their values updated correctly.
  Map<Local, JRecordField> makeRecordContainer(
      KernelScopeInfo info, MemberEntity member, KernelToLocalsMap localsMap);
}

/// Interface for type inference results for kernel IR nodes.
abstract class KernelToTypeInferenceMap {
  /// Returns the inferred return type of [function].
  AbstractValue getReturnTypeOf(FunctionEntity function);

  /// Returns the inferred receiver type of the dynamic [invocation].
  AbstractValue receiverTypeOfInvocation(
      ir.MethodInvocation invocation, AbstractValueDomain abstractValueDomain);

  /// Returns the inferred receiver type of the dynamic [read].
  AbstractValue receiverTypeOfGet(ir.PropertyGet read);

  /// Returns the inferred receiver type of the direct [read].
  AbstractValue receiverTypeOfDirectGet(ir.DirectPropertyGet read);

  /// Returns the inferred receiver type of the dynamic [write].
  AbstractValue receiverTypeOfSet(
      ir.PropertySet write, AbstractValueDomain abstractValueDomain);

  /// Returns the inferred type of [listLiteral].
  AbstractValue typeOfListLiteral(MemberEntity owner,
      ir.ListLiteral listLiteral, AbstractValueDomain abstractValueDomain);

  /// Returns the inferred type of iterator in [forInStatement].
  AbstractValue typeOfIterator(ir.ForInStatement forInStatement);

  /// Returns the inferred type of `current` in [forInStatement].
  AbstractValue typeOfIteratorCurrent(ir.ForInStatement forInStatement);

  /// Returns the inferred type of `moveNext` in [forInStatement].
  AbstractValue typeOfIteratorMoveNext(ir.ForInStatement forInStatement);

  /// Returns `true` if [forInStatement] is inferred to be a JavaScript
  /// indexable iterator.
  bool isJsIndexableIterator(ir.ForInStatement forInStatement,
      AbstractValueDomain abstractValueDomain);

  /// Returns the inferred index type of [forInStatement].
  AbstractValue inferredIndexType(ir.ForInStatement forInStatement);

  /// Returns the inferred type of [member].
  AbstractValue getInferredTypeOf(MemberEntity member);

  /// Returns the inferred type of the [parameter].
  AbstractValue getInferredTypeOfParameter(Local parameter);

  /// Returns the inferred type of a dynamic [selector] access on the
  /// [receiver].
  AbstractValue selectorTypeOf(Selector selector, AbstractValue receiver);

  /// Returns the returned type annotation in the [nativeBehavior].
  AbstractValue typeFromNativeBehavior(
      native.NativeBehavior nativeBehavior, JClosedWorld closedWorld);
}

/// Map from kernel IR nodes to local entities.
abstract class KernelToLocalsMap {
  /// The member currently being built.
  MemberEntity get currentMember;

  /// Returns the [Local] for [node].
  Local getLocalVariable(ir.VariableDeclaration node);

  Local getLocalTypeVariable(
      ir.TypeParameterType node, JsToElementMap elementMap);

  /// Returns the [ir.FunctionNode] that declared [parameter].
  ir.FunctionNode getFunctionNodeForParameter(Local parameter);

  /// Returns the [DartType] of [local].
  DartType getLocalType(JsToElementMap elementMap, Local local);

  /// Returns the [JumpTarget] for the break statement [node].
  JumpTarget getJumpTargetForBreak(ir.BreakStatement node);

  /// Returns `true` if [node] should generate a `continue` to its [JumpTarget].
  bool generateContinueForBreak(ir.BreakStatement node);

  /// Returns the [JumpTarget] defined by the labelled statement [node] or
  /// `null` if [node] is not a jump target.
  JumpTarget getJumpTargetForLabel(ir.LabeledStatement node);

  /// Returns the [JumpTarget] defined by the switch statement [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForSwitch(ir.SwitchStatement node);

  /// Returns the [JumpTarget] for the continue switch statement [node].
  JumpTarget getJumpTargetForContinueSwitch(ir.ContinueSwitchStatement node);

  /// Returns the [JumpTarget] defined by the switch case [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForSwitchCase(ir.SwitchCase node);

  /// Returns the [JumpTarget] defined the do statement [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForDo(ir.DoStatement node);

  /// Returns the [JumpTarget] defined by the for statement [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForFor(ir.ForStatement node);

  /// Returns the [JumpTarget] defined by the for-in statement [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForForIn(ir.ForInStatement node);

  /// Returns the [JumpTarget] defined by the while statement [node] or `null`
  /// if [node] is not a jump target.
  JumpTarget getJumpTargetForWhile(ir.WhileStatement node);
}

/// Returns the [ir.FunctionNode] that defines [member] or `null` if [member]
/// is not a constructor, method or local function.
ir.FunctionNode getFunctionNode(
    JsToElementMap elementMap, MemberEntity member) {
  MemberDefinition definition = elementMap.getMemberDefinition(member);
  switch (definition.kind) {
    case MemberKind.regular:
      ir.Node node = definition.node;
      if (node is ir.Procedure) {
        return node.function;
      }
      break;
    case MemberKind.constructor:
    case MemberKind.constructorBody:
      ir.Node node = definition.node;
      if (node is ir.Procedure) {
        return node.function;
      } else if (node is ir.Constructor) {
        return node.function;
      }
      break;
    case MemberKind.closureCall:
      ir.Node node = definition.node;
      if (node is ir.FunctionDeclaration) {
        return node.function;
      } else if (node is ir.FunctionExpression) {
        return node.function;
      }
      break;
    default:
  }
  return null;
}

/// Returns the initializer for [field].
///
/// If [field] is an instance field with a null literal initializer `null` is
/// returned, otherwise the initializer of the [ir.Field] is returned.
ir.Node getFieldInitializer(JsToElementMap elementMap, FieldEntity field) {
  MemberDefinition definition = elementMap.getMemberDefinition(field);
  ir.Field node = definition.node;
  if (node.isInstanceMember &&
      !node.isFinal &&
      node.initializer is ir.NullLiteral) {
    return null;
  }
  return node.initializer;
}
