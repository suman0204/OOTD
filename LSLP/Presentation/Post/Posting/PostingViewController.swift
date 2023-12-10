//
//  PostingViewController.swift
//  LSLP
//
//  Created by 홍수만 on 2023/12/02.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

class PostingViewController: BaseViewController {
    
    //PHPicker
    // Identifier와 PHPickerResult로 만든 Dictionary (이미지 데이터를 저장하기 위해 만들어 줌)
    private var selections = [String : PHPickerResult]()
    // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장해줄 겁니다.
    // selections은 딕셔너리이기 때문에 순서가 없습니다. 그래서 따로 식별자를 담을 배열 생성
    private var selectedAssetIdentifiers = [String]()
    
    let disposeBag = DisposeBag()
    let viewModel = PostingViewModel()
    
    let imageContainer = {
        let view = UIView()
        return view
    }()
    
    let imagePickerButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .top
        config.imagePadding = 10
        config.title = "사진 추가하기"
        config.titleAlignment = .center
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        
        return button
    }()
    
    let selectedImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .blue
        return view
    }()
    
    let contentTextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        return textView
    }()
    
    let postingButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.title = "등록하기"
        let button = UIButton(configuration: config)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = PostingViewModel.Input(content: contentTextView.rx.text.orEmpty, postingButtonClicked: postingButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.postResponse
            .subscribe(with: self) { owner, response in
                print("Post Response", response)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .subscribe(with: self) { owner, errorMessage in
                print("Post Error", errorMessage)
            }
            .disposed(by: disposeBag)
        
        imagePickerButton.rx.tap
            .subscribe(with: self) { owner, tap in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [imagePickerButton, selectedImageView].forEach {
            imageContainer.addSubview($0)
        }
        
        [imageContainer, contentTextView, postingButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
        
        imagePickerButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.top.leading.equalToSuperview()
            
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imagePickerButton.snp.bottom).offset(20)
            make.height.equalTo(150)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        postingButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension PostingViewController: PHPickerViewControllerDelegate {
    
//    private func presentPicker() {
//        var config = PHPickerConfiguration()
//        config.filter = PHPickerFilter.any(of: [.images, .livePhotos])
//        config.selectionLimit = 3
//        config.selection = .ordered
//        config.preferredAssetRepresentationMode = .current
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        
//        self.present(picker, animated: true)
//    }
//    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        let itemProvider = results.first?.itemProvider
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                DispatchQueue.main.async {
//                    self.selectedImageView.image = image as? UIImage
//                }
//            }
//        }
//    }
    
    
    //image picker 호출
    private func presentPicker() {
        // 이미지의 Identifier를 사용하기 위해서는 초기화를 shared로 해줘야 합니다.
        var config = PHPickerConfiguration(photoLibrary: .shared())
        // 라이브러리에서 보여줄 Assets을 필터를 한다. (기본값: 이미지, 비디오, 라이브포토)
        config.filter = PHPickerFilter.any(of: [.images])
        // 다중 선택 갯수 설정 (0 = 무제한)
        config.selectionLimit = 3
        // 선택 동작을 나타냄 (default: 기본 틱 모양, ordered: 선택한 순서대로 숫자로 표현, people: 뭔지 모르겠게요)
        config.selection = .ordered
        // 잘은 모르겠지만, current로 설정하면 트랜스 코딩을 방지한다고 하네요!?
        config.preferredAssetRepresentationMode = .current
        // 이 동작이 있어야 PHPicker를 실행 시, 선택했던 이미지를 기억해 표시할 수 있다. (델리게이트 코드 참고)
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        // 만들어준 Configuration를 사용해 PHPicker 컨트롤러 객체 생성
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    //image picker 종료시
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker가 선택이 완료되면 화면 내리기
        picker.dismiss(animated: true)
        
//        imageLoadingActivityIndicator.startAnimating()
        
        // Picker의 작업이 끝난 후, 새로 만들어질 selections을 담을 변수를 생성
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            // ⭐️ 여기는 WWDC에서 3분 부분을 참고하세요. (Picker의 사진의 저장 방식)
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        
        // selections에 새로 만들어진 newSelection을 넣어줍시다.
        selections = newSelections
        // Picker에서 선택한 이미지의 Identifier들을 저장 (assetIdentifier은 옵셔널 값이라서 compactMap 받음)
        // 위의 PHPickerConfiguration에서 사용하기 위해서 입니다.
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
//            imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            let imageView = [selectedImageView]

            imageView.forEach {
                $0.image = nil
            }
        } else {
//            self.selectedAssetIdentifiers.removeAll()
//            let imageView = [firstImageView, secondImageView, thirdImageView]
//            imageView.forEach {
//                $0.image = nil
//            }

            displayImage()
            print(selectedAssetIdentifiers)
            
//            imageLoadingActivityIndicator.stopAnimating()
        }
    }
    
    private func addImage(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.cornerCurve = .circular

        imageView.image = image
      
                
        imageView.snp.makeConstraints {
            $0.size.equalTo(80)
        }
        
//        imageStackView.addArrangedSubview(imageView)

    }
    
    private func displayImage() {
        
        let dispatchGroup = DispatchGroup()
        // identifier와 이미지로 dictionary를 만듬 (selectedAssetIdentifiers의 순서에 따라 이미지를 받을 예정입니다.)
        var imagesDict = [String: UIImage]()
        print("displayImage")
        print(selections)
        
//        // 1. 기존 이미지를 가져와 딕셔너리에 추가
//        for identifier in selectedAssetIdentifiers {
//            let image = loadImageForDocument(fileName: "\(identifier)_image.jpg")
////            if let image = loadImageForDocument(fileName: "\(identifier)_image.jpg") {
//                imagesDict[identifier] = image
////            }
//        }
        
        for (identifier, result) in selections {
            
            dispatchGroup.enter()
                        
            let itemProvider = result.itemProvider
            // 만약 itemProvider에서 UIImage로 로드가 가능하다면?
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                // 로드 핸들러를 통해 UIImage를 처리해 줍시다. (비동기적으로 동작)
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    guard let image = image as? UIImage else { return }
                    
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self = self else { return }
            
            let imageView = [selectedImageView]
            
            // 먼저 스택뷰의 서브뷰들을 모두 제거함
            imageView.forEach {
                $0.image = nil
            }
            
            print("displayImage")
            print(selectedAssetIdentifiers)
            for (index, identifier) in self.selectedAssetIdentifiers.enumerated() {
                guard let image = imagesDict[identifier] else { return }
                imageView[index].image = image
                
                guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                
                self.viewModel.imageData
                    .onNext([data])
            }
            
    
        }
    }
    
    
}
