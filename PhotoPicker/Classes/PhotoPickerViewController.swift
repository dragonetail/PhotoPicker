//
//  PhotoPickerViewController.swift
//  PhotoPicker
//
//  Created by wave on 2018/11/12.
//  Copyright © 2018 wave. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

public protocol PhotoPickerViewControllerOutputs {

    var clickVideo: PublishSubject<AVAssetExportSession> { get }
    
    var clickNextStep: PublishSubject<(Scale, [UIImage])> { get }
    
    var clickClose: PublishSubject<[UIImage]> { get }
}

public class PhotoPickerViewController: UIViewController {

    deinit {
        debugPrint("deinit \(self)")
    }
    
    public var outputs: PhotoPickerViewControllerOutputs { return self }
    public var clickVideo = PublishSubject<AVAssetExportSession>()
    public var clickNextStep = PublishSubject<(Scale, [UIImage])>()
    public var clickClose = PublishSubject<[UIImage]>()

    @IBOutlet public weak var closeBtn: UIButton!
    @IBOutlet public weak var nextStepBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var editContainerView: UIView!
    @IBOutlet weak var editContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: UIView!
    
    /// **
//    let editView = EditView.fromNib() as! EditView
//    let actionVC = PhotoPickerActionViewController.fromStoryboard() as! PhotoPickerActionViewController
    let editView: EditView = .fromNibsssss()
    let actionVC = Storyboard.photo.get(class: PhotoPickerActionViewController.self)
    
    /// 最终小圆圈勾选中的
    private let selectedAssetItems = BehaviorRelay<[AssetItem]>(value: [])
    /// 预览情况下, 点击的
    private let currentSelectedAssetItem = PublishSubject<AssetItem>()
    
    public static var fromStoryboard: PhotoPickerViewController {
        let path = Bundle.main.path(forResource: "Frameworks/PhotoPicker", ofType: "framework")
        let bundle = Bundle(path: path!)
        let vcName = String(describing: self)
        let sb = UIStoryboard(name: "PhotoPicker", bundle:bundle)
        let vc = sb.instantiateViewController(withIdentifier: vcName)
        return vc as! PhotoPickerViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureSelectedAssetItems()
        
        configureEditView()
        configureActionVC()
        configureActionVCGesture()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        clickClose.onNext([])
    }
    
    @IBAction func nextStepAction(_ sender: UIButton) {
        let items = selectedAssetItems.value
        let images = ScreenshotTool.getImages(assetItems: items)
        clickNextStep.onNext(images)
    }
}

extension PhotoPickerViewController: PhotoPickerViewControllerOutputs {}

private extension PhotoPickerViewController {
    
    func configureEditView() {
        
        editContainerViewHeight.constant = view.width
        view.layoutIfNeeded()
        
        editView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.width)
        editContainerView.addSubview(editView)
        
        editView.outputs.editedAssetItem
            .bind(to: actionVC.editedAssetItem)
            .disposed(by: rx.disposeBag)
    }
    
    func configureActionVC() {
        
        let originalY: CGFloat = editContainerView.bottom + Runtime.statusBarHeight
        let frame = CGRect(x: 0, y: originalY, width: view.width, height: view.height - originalY)
        add(asChildViewController: actionVC, frame: frame)

        actionVC.outputs.clickVideo
            .bind(to: clickVideo)
            .disposed(by: rx.disposeBag)
    }

    func configureSelectedAssetItems() {
        
        selectedAssetItems
            .subscribe(onNext: { items in
                if items.count == 0 {
                    return
                }
            })
            .disposed(by: rx.disposeBag)

        currentSelectedAssetItem
            .subscribe(onNext: { [unowned self] item in
                guard let _ = item.fullResolutionImage else {
                    return
                }

                if self.selectedAssetItems.value.count >= 1 {
                    self.editView.inputs.assetItems.onNext((item, self.selectedAssetItems.value[0]))
                } else {
                    self.editView.inputs.assetItems.onNext((item, nil))
                }
            })
            .disposed(by: rx.disposeBag)
        
        actionVC.selectedAssetItems
            .bind(to: selectedAssetItems)
            .disposed(by: rx.disposeBag)

        actionVC.currentSelectedAssetItem
            .bind(to: currentSelectedAssetItem)
            .disposed(by: rx.disposeBag)
    }
    
}
