# NeteaseCloudMusicAPI

## NeteaseCloudMusicAPI for Swift(网易云音乐API Swift)

## Inspired by：
* https://github.com/Binaryify/NeteaseCloudMusicApi

## Support:
* iOS 10+
* macOS 10.12+

## Installation:
* Swift Package Manager

## Demo: 
* https://github.com/linshaolong5240/QinSwiftUI

## Usage:
```Swift
//Callback
NCM.request(action: NCMPlaylistDetailAction(id: id)) { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}

//Combine iOS13+ macOS10.12+
NCM.requestPublisher(action: NCMPlaylistDetailAction(id: id)).sink(receiveCompletion: { completion in
    if case .failure(let error) = completion {
        print(error)
    }
}, receiveValue: { response in
    print(response)
}).store(in: &cancells)

//async await iOS13+ macOS11+ Xcode13.2.1+
Task {
    let result = await NCM.requestAsync(action: NCMPlaylistDetailAction(id: id))
    print(result)
}

//RxSwift 6.0.0+
NCM.requestObserver(action: NCMPlaylistDetailAction(id: id)).subscribe { response in
    print(response)
} onFailure: { error in
    print(error)
} onDisposed: {

}.disposed(by: disposeBag)
```
## Action:
* NCMAlbumDetailAction
* NCMAlbumSubAction
* NCMAlbumSublistAction
* NCMArtistAlbumsAction
* NCMArtistHotSongsAction
* NCMArtistIntroductionAction
* NCMArtistMVAction
* NCMArtistSubAction
* NCMArtistSublistAction
* NCMCloudSongAddAction
* NCMCloudUploadAction
* NCMCloudUploadCheckAction
* NCMCloudUploadInfoAction
* NCMCloudUploadTokenAction
* NCMCommentAction
* NCMCommentLikeAction
* NCMCommentSongAction
* NCMLoginActio
* NCMLoginRefreshAction
* NCMLogoutAction
* NCMMVDetailAction
* NCMMVURLActio
* NCMPlaylistCategoriesAction
* NCMPlaylistCategoryListAction
* NCMPlaylistCreateAction
* NCMPlaylistDeleteAction
* NCMPlaylistDetailAction
* NCMPlaylistOrderUpdateAction
* NCMPlaylistSubscribeAction
* NCMPlaylistTracksAction
* NCMRecommendPlaylistAction
* NCMRecommendSongAction
* NCMSearchAction
* NCMSongDetailAction
* NCMSongLikeAction
* NCMSongLikeListAction
* NCMSongLyricAction
* NCMSongOrderUpdateAction
* NCMSongURLAction
* NCMUserCloudAction
* NCMUserPlaylistAction
