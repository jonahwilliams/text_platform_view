//
//  FLNativeView.swift
//  Runner
//
//  Created by Jonah Williams on 11/14/23.
//
import Foundation

import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FlutterBlinkingCursor: UIView {
  private var _started: Bool = false;

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  //common func to init our view
  private func setupView() {
    backgroundColor = .blue
  }

  override func layoutSubviews() {
    if (!_started) {
      let key = "opacity"
      let animation = CABasicAnimation(keyPath: key)
      animation.fromValue = 1.0
      animation.toValue = 0.0
      animation.duration = 0.5
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
      animation.autoreverses = true
      animation.repeatCount = Float.greatestFiniteMagnitude
      layer.add(animation, forKey: key)
      _started = true;
    }
  }
}


class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = FlutterBlinkingCursor()
        super.init()
    }

    func view() -> UIView {
        return _view
    }
}
