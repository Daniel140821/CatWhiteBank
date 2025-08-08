import SwiftUI
import AVFoundation

// 扫描结果的回调类型
typealias QRCodeScannedResult = (String) -> Void

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var onScanned: QRCodeScannedResult?
    // 添加一个计时器来防止重复扫描同一二维码
    private var lastScannedTime: Date?
    private let scanInterval: TimeInterval = 1.0 // 1秒内不重复扫描同一二维码
    
    // 检查相机权限并配置扫描会话
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCaptureSession()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    // 配置相机捕获会话
    private func setupCaptureSession() {
        // 获取后置摄像头
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back) else {
            print("无法获取相机设备")
            return
        }
        
        do {
            // 创建输入设备
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // 添加输入到会话
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
                // 创建元数据输出
                let captureMetadataOutput = AVCaptureMetadataOutput()
                if captureSession.canAddOutput(captureMetadataOutput) {
                    captureSession.addOutput(captureMetadataOutput)
                    
                    // 设置代理和元数据类型
                    captureMetadataOutput.setMetadataObjectsDelegate(self,
                                                                   queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = [.qr]
                    
                    // 创建预览层
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    videoPreviewLayer?.videoGravity = .resizeAspectFill
                }
            }
        } catch {
            print("相机配置错误: \(error.localizedDescription)")
        }
    }
    
    // 开始扫描
    func startScanning() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    // 停止扫描
    func stopScanning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // 添加预览层
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        videoPreviewLayer?.frame = view.layer.bounds
    }
    
    // 处理扫描到的元数据
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                       didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection) {
        // 检查是否有元数据
        if metadataObjects.isEmpty {
            return
        }
        
        // 获取元数据
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // 检查是否是QR码且有值
        if metadataObj.type == .qr, let value = metadataObj.stringValue {
            // 检查是否在扫描间隔内，防止重复扫描
            let now = Date()
            if let lastTime = lastScannedTime, now.timeIntervalSince(lastTime) < scanInterval {
                return
            }
            
            lastScannedTime = now
            // 调用回调但不停止扫描，允许继续扫描
            onScanned?(value)
        }
    }
}

struct QRScanner: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onScanned: QRCodeScannedResult
    
    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        controller.onScanned = { result in
            onScanned(result)
            // 移除自动关闭扫描器的代码，保持扫描状态
        }
        
        // 检查权限并启动扫描
        controller.checkCameraPermission { granted in
            if !granted {
                DispatchQueue.main.async {
                    isPresented = false
                    // 显示权限被拒绝的提示
                    context.coordinator.showPermissionDeniedAlert()
                }
            } else {
                controller.startScanning()
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: QRScanner
        
        init(_ parent: QRScanner) {
            self.parent = parent
        }
        
        // 显示权限被拒绝的提示
        func showPermissionDeniedAlert() {
            let alert = UIAlertController(
                title: "相机权限被拒绝",
                message: "请在设置中允许应用访问相机以使用QR码扫描功能",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "设置", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            
            // 获取当前的顶层视图控制器并显示弹窗
            if let topVC = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
                topVC.present(alert, animated: true)
            }
        }
    }
}

// 扩展UIViewController以获取顶层视图控制器
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
    
    



import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}
