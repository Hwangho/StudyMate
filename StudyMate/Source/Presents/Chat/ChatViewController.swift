//
//  ChatViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import UIKit

import SnapKit
import SocketIO

final class ChatViewController: BaseViewController {
    
    /// UI
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    
    /// Properties
    var coordinator: ChatCoordinator?
    
    private var datasource: DataSource!
    
    var chats: [Chat] = []
    
    
    /// Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = Color.BaseColor.green
    }
    
    override func setData() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage), name: NSNotification.Name("getMessage"), object: nil)
        
        /// 소켓통신
        SocketIOManager.shared.establishConnection()
    }
    
    @objc
    func getMessage(notification: NSNotification) {
        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String
        
        let chatData = Chat(id: id, chat: chat, createdAt: createdAt, from: from, to: to)
        
        chats.append(chatData)
    }
    
    func workup() {
        
        // @@ 1 단계 @@
        // 채팅 화면 만들기
        
        // 채팅 입력 후 데이터 받아온 다음 chats 배열에 넣어주기
        
        // chats 배열의 createAt sorted하여 채팅방 tableView에 뿌려주기
        
        
        // @@ 2 단계 @@
        //realm 추가하여 채팅방별, 채팅 내용 리스트 저장
        
        // 처음 진입 시 realm의 마지막 chat date 받아오기
        
        // 받아온 last date를 통해 LastChatData 받아와서 realm에 저장
        
        // realm에 데이터가 저장이 다 되었으면 해당 realm 데이터 tableView에 뿌려주기
        
        // soket통신 시작!
    }
    
}


extension ChatViewController {
 
    /// Section, Item
    enum Section: Hashable {
        
    }
    
    enum Item: Hashable {
        
    }
    
    
    /// typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias MyCellRegister = UICollectionView.CellRegistration<MyChatCollectionViewCell, Chat>
    
    typealias OtherCellRegister = UICollectionView.CellRegistration<OtherChatCollectionViewCell, Chat>
    
    typealias HeaderRegister = UICollectionView.SupplementaryRegistration<ChatHeaderCollectionView>
    
    
    /// Datasource
    func setDatasource() {
//        
//        let myCell = MyCellRegister { cell, indexPath, itemIdentifier in
//            <#code#>
//        }
//        
//        let otherCell = OtherCellRegister { cell, indexPath, itemIdentifier in
//            <#code#>
//        }
//        
//        let header = HeaderRegister(elementKind: "hedaer") { supplementaryView, elementKind, indexPath in
//            supplementaryView.configure(type: .first)
//        }
//        
//        datasource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            <#code#>
//        })
    }
    
    
    func flowLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.init { sectionIndex, enviroment in
            
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: itemsize)
            
            let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            
            let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: "header", alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
}


class MyChatCollectionViewCell: BaseCollectionViewCell {
    
    let bubleView = UIView()
    
    let label = LineHeightLabel()
    
    override func setupAttributes() {
        super.setupAttributes()
        
        label.setupFont(type: .Body3_R14)
    }
    
    func configure() {
        
    }
}

class OtherChatCollectionViewCell: BaseCollectionViewCell {
    
}

class ChatHeaderCollectionView: BaseCollectionHeaderFooterView {
    
    enum HeaderType {
        case first
        case date
    }
    
    func configure(type: HeaderType) {
        switch type {
        case .first:
            print("first Chat")
            
        case .date:
            print("Chat Date")
        }
    }
}




class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    // 서버와 메시지를 주고 받기 위한 클래스
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        
        manager = SocketManager(socketURL: URL(string: APIKeys.shared.server.baseURL)! , config: [
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket // api
        
        //연결
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", "myUID")
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        // 이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            let data = dataArray[0] as! NSDictionary
            
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            print("checK ==>", chat, from, createdAt)
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [
                "id": id,
                "chat": chat,
                "createdAt": createdAt,
                "from": from,
                "to": to
            ])
        }
        
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}



// MARK: - Chat
struct Chat: Codable {
    let id: String  // 채팅방
    let chat: String
    let createdAt: String   // 채팅 시간
    let from, to: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chat, createdAt, from, to
    }
}
