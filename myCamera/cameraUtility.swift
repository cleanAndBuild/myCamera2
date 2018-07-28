//
//  cameraUtility.swift
//  myCamera
//
//  Created by matsumoto keiji on 2017/06/28.
//  Copyright © 2017年 matsumoto keiji. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct cameraUtility {
	
	//カメラビューを初期化する
	static func makeCameraView(_ session:AVCaptureSession,_ imageOutput:AVCapturePhotoOutput,_ cameraView:UIView) -> AVCaptureVideoPreviewLayer {
		
		var previewLayer: AVCaptureVideoPreviewLayer? = nil
		
		let device = AVCaptureDevice.default(for: AVMediaType.video)
		
  
		do {
			let input = try AVCaptureDeviceInput(device: device!)
			
			// 入力
			if (session.canAddInput(input)) {
				session.addInput(input)
				
				// 出力
				if (session.canAddOutput(imageOutput)) {
					session.addOutput(imageOutput)
					session.startRunning() // カメラ起動
					
					previewLayer = AVCaptureVideoPreviewLayer(session: session)
					previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect // アスペクトフィット
					previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait // カメラの向き
					
					cameraView.layer.addSublayer(previewLayer!)
					
					// ビューのサイズの調整
					previewLayer?.position = CGPoint(x: cameraView.frame.width / 2, y: cameraView.frame.height / 2)
					previewLayer?.bounds = cameraView.frame
				}
			}
		}
		catch {
			print(error)
		}
		
		return previewLayer!
	}
	
	//画像を合成する
	static func mergeImage(_ source:UIImage,_ overLay:UIImage) -> UIImage {

		UIGraphicsBeginImageContext(source.size)//イメージコンテキストを開始

		let imageRect:CGRect = CGRect(x:0,y:0,width:source.size.width,height:source.size.height) //描画する範囲を設定する
		
		source.draw(in: imageRect)	//カメラ画像を下地として描く
		overLay.draw(in: imageRect)	//カメラ画像の上に合成用の画像を描く
		
		let retImage = UIGraphicsGetImageFromCurrentImageContext()//描画した画像をUIImageに変換する

		
		UIGraphicsEndImageContext()//イメージコンテキストを終了

		return retImage! //完成したUIImageを返す
	}
	
	
	
	
	
	
}

