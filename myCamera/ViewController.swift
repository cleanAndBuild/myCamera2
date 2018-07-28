//
//  ViewController.swift
//  myCamera
//
//  Created by Yako Kobayashi on 2018/07/28.
//  Copyright © 2018年 yako Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    @IBOutlet var cameraView: UIView!
    @IBOutlet var shutterButton: UIButton!
    
    var mySession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    
    
    //初期化
    override func viewDidLoad() {
        super.viewDidLoad()
        //AVCaptureSessionとAVCapturePhotoOutputを作る
        mySession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        //カメラビューを作る
        let previewLayer:AVCaptureVideoPreviewLayer? = cameraUtility.makeCameraView(mySession,stillImageOutput!,cameraView)
        
        //撮影する画像のサイズを設定する
        mySession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        if(previewLayer != nil) {
            self.view.addSubview(shutterButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //シャッターボタン
    @IBAction func tapShutter(_ sender: Any) {
        // 押した瞬間に必要な設定を行う
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto    //フラッシュ
        
        // シャッターを切る
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    // デリゲート。カメラで撮影が完了した後呼ばれる。JPEG形式でフォトライブラリに保存。
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        //JPEG形式で画像データを取得
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            //UImageに変換
            if let photoData = photoData {
                let image = UIImage(data: photoData)
                if let image = image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                
            }
        }
    }
}

