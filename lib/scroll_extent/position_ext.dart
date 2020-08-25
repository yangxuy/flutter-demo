import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

/// [Scrollable]分析
/// 初始化
/// 1 获取ScrollConfiguration.of(context)
/// 2 设置ScrollConfiguration
/// 3 判断是否有oldPosition
/// 4 创建[createScrollPosition]position
/// 5 attach position

/// [ScrollController]分析
/// [createScrollPosition] 提供创建position的方法
/// [animateTo] [jumpTo] 通过 controller 修改滚动距离,真正实现的是position
/// [attach] [detach] 添加和解绑 _positions 在[Scrollable]初始化和dispose的时候添加和解除

/// [ScrollPosition] 分析
/// 属性
/// [physics] 滚动物理
/// [context] ScrollContext 代表的是Scroll组件 在组件初始化的时候调用[createScrollPosition]传给 position
/// [keepScrollOffset] 是否保持滚动位置 在[ScrollPosition]构建的时候创建
/// [oldPosition] 一般为null
/// [initialPixels]初始化滚动距离
/// 方法
/// [animateTo] [jumpTo] 向外暴露滚动方法
/// [applyNewDimensions] 主要用在初始化的时候 初始话了 [actions]
/// [drag] [hold] 主要用在手势处理的时候
/// [beginActivity] 标记activity
/// ScrollActivityDelegate 的方法
/// [applyUserOffset] [setPixels]  每次滚动update
/// [goIdle] [goBallistic] 修改active

class XScrollPosition extends ScrollPosition implements ScrollActivityDelegate {
  XScrollPosition({
    ScrollPhysics physics,
    ScrollContext context,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    double initialPixels = 0.0,
    String debugLabel,
  }) : super(
          physics: physics,
          context: context,
          keepScrollOffset: keepScrollOffset,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        ) {
    if (pixels == null && initialPixels != null) correctPixels(initialPixels);
    if (activity == null) goIdle();
    assert(activity != null);
  }

  /// 从[hold]暂时保留的先前活动到可能的速度
  double _heldPreviousVelocity = 0.0;

  /// 正则掌管滚动
  @override
  Future<void> animateTo(double to, {Duration duration, Curve curve}) {
    // TODO: implement animateTo
  }
  //
  @override
  void jumpTo(double value) {
    // TODO: implement jumpTo
  }

  ///滚动反向
  @override
  AxisDirection get axisDirection => context.axisDirection;

  ///  Called when the scroll view that is performing this activity changes its metrics.
  ///  当前scrollview [activity] change 的时候 发生 ；初始化的时候 会给[activity] 赋值  这个时候 就会发生
  @override
  void applyNewDimensions() {
    super.applyNewDimensions();
    context.setCanDrag(physics.shouldAcceptUserOffset(this)); // 这里初始化了拖拽事件
  }

  /// 在滚动组件里面拖拽的时候 onStart 返回拖拽对象
  ScrollDragController _currentDrag;

  @override
  Drag drag(DragStartDetails details, dragCancelCallback) {
    final ScrollDragController drag = ScrollDragController(
      delegate: this,
      details: details,
      onDragCanceled: dragCancelCallback,
      carriedVelocity: physics.carriedMomentum(_heldPreviousVelocity),
      motionStartDistanceThreshold: physics.dragStartDistanceMotionThreshold,
    );
    beginActivity(DragScrollActivity(this, drag));
    assert(_currentDrag == null);
    _currentDrag = drag;
    return drag;
  }

  /// 在滚动组件里面拖拽的时候  onDown 具有 cancel 方法 取消drag  作用是 [beginActivity]标记active
  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    final double previousVelocity = activity.velocity;
    final HoldScrollActivity holdActivity = HoldScrollActivity(
      delegate: this,
      onHoldCanceled: holdCancelCallback,
    );
    beginActivity(holdActivity);
    _heldPreviousVelocity = previousVelocity;
    return holdActivity;
  }


  @override
  void jumpToWithoutSettling(double value) {
    // TODO: implement jumpToWithoutSettling
  }

  // Change the current [activity], disposing of the old one
  @override
  void beginActivity(ScrollActivity newActivity) {
    _heldPreviousVelocity = 0.0;
    if (newActivity == null) return;
    assert(newActivity.delegate == this);

    /// 设置当前 active
    super.beginActivity(newActivity);
    _currentDrag?.dispose();
    _currentDrag = null;
    if (!activity.isScrolling) updateUserScrollDirection(ScrollDirection.idle);
  }

  @override
  ScrollDirection get userScrollDirection => _userScrollDirection;
  ScrollDirection _userScrollDirection = ScrollDirection.idle;

  @protected
  @visibleForTesting
  void updateUserScrollDirection(ScrollDirection value) {
    assert(value != null);
    if (userScrollDirection == value) return;
    _userScrollDirection = value;
    didUpdateScrollDirection(value);
  }

  /// 从给定的[ScrollPosition]中获取任何当前适用的状态。
  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    if (other is! ScrollPositionWithSingleContext) {
      goIdle();
      return;
    }
    activity.updateDelegate(this);
    final XScrollPosition typedOther = other as XScrollPosition;
    _userScrollDirection = typedOther._userScrollDirection;
    assert(_currentDrag == null);
    if (typedOther._currentDrag != null) {
      _currentDrag = typedOther._currentDrag;
      _currentDrag.updateDelegate(this);
      typedOther._currentDrag = null;
    }
  }

  /// 适用于用户直接操作滚动条位置时 不是通过controller
  @override
  void applyUserOffset(double delta) {
    updateUserScrollDirection(
        delta > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse);
    setPixels(pixels - physics.applyPhysicsToUserOffset(this, delta));
  }

  /// 终止当前active 启用闲置的
  @override
  void goBallistic(double velocity) {
    // TODO: implement goBallistic
    assert(pixels != null);
    final Simulation simulation =
        physics.createBallisticSimulation(this, velocity);
    if (simulation != null) {
      beginActivity(BallisticScrollActivity(this, simulation, context.vsync));
    } else {
      goIdle();
    }
  }

  /// 终止当前active 启用新的
  @override
  void goIdle() {
    // TODO: implement goIdle
    beginActivity(IdleScrollActivity(this));
  }

  ///  Update the scroll position to the given pixel value.
  @override
  double setPixels(double pixels) {
    return super.setPixels(pixels);
  }
}
