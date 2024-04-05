//
//  ViewController.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import UIKit
import Starscream
import Alamofire
import SnapKit

class ViewController: UIViewController {
    var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    lazy var contentTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .lightGray
        view.allowsSelection = false
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.register(
            ChatCell.self,
            forCellReuseIdentifier: ChatCell.identifier
        )
        view.contentInset = .zero
        view.scrollIndicatorInsets = .zero
        view.delegate = self
        view.dataSource = self
        return view
    }()
    lazy var connectButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setTitle("연결", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    lazy var inputTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .zero
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.contentInset = .zero
        view.delegate = self
        view.returnKeyType = .send
        view.textContainer.maximumNumberOfLines = 8
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setTitle("전송", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    var client: ChatClient!
    var chatData: [ChatMessage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        drawLayout()
        let cookie = JsonLoader.load(type: NIDCookie.self, fileName: "Cookie")
        client = ChatClient(
            streamerID: "dcd75ef0f2c664e3270de18696ad43bf",
            nidCookie: cookie!
        )
        client.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        self.view.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    func drawLayout() {
        
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        let connectView = UIView()
        connectView.addSubview(connectButton)
        connectButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        containerStackView.addArrangedSubview(connectView)
        containerStackView.addArrangedSubview(contentTableView)
        let sendView = UIView()
        sendView.addSubview(inputTextView)
        sendView.addSubview(sendButton)
        inputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.height.equalTo(32)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        containerStackView.addArrangedSubview(sendView)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        switch sender {
        case connectButton :
            client.connect()
        case sendButton :
            client.sendChat(inputTextView.text)
            inputTextView.text = ""
            view.endEditing(true)
        default:
            break
        }
    }
}

extension ViewController: ChatClientDelegate {
    func client(_ client: ChatClient, receive: [ChatMessage]) {
        print(receive)
    }
    
    func client(_ client: ChatClient, receive: ChatMessage) {
        print(receive)
        chatData.append(receive)
        contentTableView.reloadData()
        DispatchQueue.main.async {
            self.contentTableView.scrollToBottom(animated: false)
        }
    }
}

extension ViewController: UITextViewDelegate {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        var constant = -endFrame.size.height
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let bottomPadding = window.safeAreaInsets.bottom
            constant += bottomPadding
        }
        inputTextView.snp.updateConstraints { make in
            let height = max(inputTextView.contentSize.height, 32)
            make.height.equalTo(height)
        }
        containerStackView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(constant)
        }
        
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        inputTextView.snp.updateConstraints { make in
            make.height.equalTo(32)
        }
        containerStackView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        var constant = -endFrame.size.height
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let bottomPadding = window.safeAreaInsets.bottom
            constant += bottomPadding
        }
        
        inputTextView.snp.updateConstraints { make in
            let height = max(inputTextView.contentSize.height, 32)
            make.height.equalTo(height)
        }
        containerStackView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(constant)
        }
        view.layoutIfNeeded()
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.endEditing(_:)))
        tap.cancelsTouchesInView = true
        return tap
    }
    
    @objc private func endEditing(_ force: Bool) -> Bool {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.numberOfLines > textView.textContainer.maximumNumberOfLines,
            !textView.text.isEmpty {
            textView.text.removeLast()
        }
        inputTextView.snp.updateConstraints { make in
            let height = max(inputTextView.contentSize.height, 32)
            make.height.equalTo(height)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text != "\n" else {
            buttonAction(sender: sendButton)
            return false
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = chatData[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatCell.identifier,
            for: indexPath
        ) as! ChatCell
        cell.model = item
        return cell
    }
}

class ChatCell: UITableViewCell {
    var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .fill
        return view
    }()
    
    var thumbnailImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightText
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    var model: ChatMessage! {
        didSet {
            loadData(model)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func drawLayout() {
        backgroundColor = .clear
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-6)
            $0.height.equalTo(40)
        }
        /*
        let thumbnailView = UIView()
        thumbnailView.backgroundColor = .clear
        thumbnailView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        containerStackView.addArrangedSubview(thumbnailView)*/
        nameLabel.snp.contentHuggingHorizontalPriority = 750
        nameLabel.snp.contentCompressionResistanceHorizontalPriority = 900
        containerStackView.addArrangedSubview(nameLabel)
        containerStackView.addArrangedSubview(messageLabel)
    }
    
    func loadData(_ model: ChatMessage) {
        nameLabel.text = model.profile.nickname
        messageLabel.text = model.msg
    }
}
