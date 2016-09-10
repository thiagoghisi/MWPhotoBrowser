import AssetsLibrary
import SDWebImage
import UIKit

import MWPhotoBrowser

class MenuViewController: UITableViewController, MWPhotoBrowserDelegate {
    var segmentedControl: UISegmentedControl!
    var selections = [AnyObject]()
    var photos = [AnyObject]()
    var thumbs = [AnyObject]()
    var assets = [AnyObject]()
    var assetLib = ALAssetsLibrary()

    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }

    init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }

        self.title = "MWPhotoBrowser"

        SDImageCache.sharedImageCache().clearDisk()
        SDImageCache.sharedImageCache().clearMemory()

        self.segmentedControl = UISegmentedControl(items: ["Push", "Modal"])
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(self.segmentChange), forControlEvents: .ValueChanged)
        let item = UIBarButtonItem(customView: self.segmentedControl)
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)

        self.loadAssets()
    }

    func segmentChange() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .None
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 9
        let lockQueue = dispatch_queue_create("tableLoadingQueue", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(lockQueue) {
            if Bool(self.assets.count) {
                rows += 1
            }
        }
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        // Configure
        switch indexPath.row {
//            case 0:
//                cell.textLabel!.text! = "Single photo"
//                cell.detailTextLabel!.text! = "with caption, no grid button"

//            case 1:
//                cell.textLabel!.text! = "Multiple photos and video"
//                cell.detailTextLabel!.text! = "with captions"
//
//            case 2:
//                cell.textLabel!.text! = "Multiple photo grid"
//                cell.detailTextLabel!.text! = "showing grid first, nav arrows enabled"
//
//            case 3:
//                cell.textLabel!.text! = "Photo selections"
//                cell.detailTextLabel!.text! = "selection enabled"
//
//            case 4:
//                cell.textLabel!.text! = "Photo selection grid"
//                cell.detailTextLabel!.text! = "selection enabled, start at grid"
//
            case 5:
                cell.textLabel!.text! = "Web photos"
                cell.detailTextLabel!.text! = "photos from web"

            case 6:
                cell.textLabel!.text! = "Web photo grid"
                cell.detailTextLabel!.text! = "showing grid first"

//            case 7:
//                cell.textLabel!.text! = "Single video"
//                cell.detailTextLabel!.text! = "with auto-play"
//
            case 8:
                cell.textLabel!.text! = "Web videos"
                cell.detailTextLabel!.text! = "showing grid first"

//            case 9:
//                cell.textLabel!.text! = "Library photos and videos"
//                cell.detailTextLabel!.text! = "media from device library"

            default:
                break
        }

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Browser
        var photos = [AnyObject]()
        var thumbs = [AnyObject]()
        var photo: MWPhoto?
        var thumb: MWPhoto?
        var displayActionButton = true
        var displaySelectionButtons = false
        var displayNavArrows = false
        var enableGrid = true
        var startOnGrid = false
        var autoPlayOnAppear = false

        switch indexPath.row {
            case 5:
                // Photos
                photos.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3567/3523321514_371d9ac42f_b.jpg")!)!)
                photos.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3567/3523321514_371d9ac42f_b.jpg")!)!)
                photos.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3629/3339128908_7aecabc34b_b.jpg")!)!)
                photos.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3364/3338617424_7ff836d55f_b.jpg")!)!)
                photos.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_b.jpg")!)!)
                photos.append(MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2449/4052876281_6e068ac860_b.jpg")!)!)
                // Thumbs
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3567/3523321514_371d9ac42f_q.jpg")!)!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3629/3339128908_7aecabc34b_q.jpg")!)!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3364/3338617424_7ff836d55f_q.jpg")!)!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_q.jpg")!)!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2449/4052876281_6e068ac860_q.jpg")!)!)

            case 6:
                // Photos & thumbs
                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_b.jpg")!)
                photo!.caption = "Tube"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_b.jpg")!)
                photo!.caption = "Flat White at Elliot's"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm9.static.flickr.com/8379/8530199945_47b386320f_b.jpg")!)
                photo!.caption = "Woburn Abbey"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm9.static.flickr.com/8379/8530199945_47b386320f_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm9.static.flickr.com/8364/8268120482_332d61a89e_b.jpg")!)
                photo!.caption = "Frosty walk"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm9.static.flickr.com/8364/8268120482_332d61a89e_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm8.static.flickr.com/7109/7604416018_f23733881b_b.jpg")!)
                photo!.caption = "Jury's Inn"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm8.static.flickr.com/7109/7604416018_f23733881b_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm7.static.flickr.com/6002/6020924733_b21874f14c_b.jpg")!)
                photo!.caption = "Heavy Rain"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm7.static.flickr.com/6002/6020924733_b21874f14c_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm5.static.flickr.com/4012/4501918517_5facf1a8c4_b.jpg")!)
                photo!.caption = "iPad Application Sketch Template v1"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm5.static.flickr.com/4012/4501918517_5facf1a8c4_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2667/4072710001_f36316ddc7_b.jpg")!)
                photo!.caption = "Grotto of the Madonna"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2667/4072710001_f36316ddc7_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2449/4052876281_6e068ac860_b.jpg")!)
                photo!.caption = "Beautiful Eyes"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm3.static.flickr.com/2449/4052876281_6e068ac860_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3528/4052875665_53e5b4dc61_b.jpg")!)
                photo!.caption = "Cousin Portrait"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3528/4052875665_53e5b4dc61_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3520/3846053408_6ecf775a3e_b.jpg")!)
                photo!.caption = "iPhone Application Sketch Template v1.3"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3520/3846053408_6ecf775a3e_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3624/3559209373_003152b4fd_b.jpg")!)
                photo!.caption = "Door Knocker of Capitanía General"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3624/3559209373_003152b4fd_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3551/3523421738_30455b63e0_b.jpg")!)
                photo!.caption = "Parroquia Sta Maria del Mar"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3551/3523421738_30455b63e0_q.jpg")!))

                photo = MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3224/3523355044_6551552f93_b.jpg")!)
                photo!.caption = "Central Atrium in Casa Batlló"
                photos.append(photo!)
                thumbs.append(MWPhoto(URL: NSURL(string: "https://farm4.static.flickr.com/3224/3523355044_6551552f93_q.jpg")!))

                // Options
                startOnGrid = true

            case 8:
                // Videos
                photo = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/e15/11192696_824079697688618_1761661_n.jpg")!)
                photo!.videoURL = NSURL(string: "https://scontent.cdninstagram.com/hphotos-xpa1/t50.2886-16/11200303_1440130956287424_1714699187_n.mp4")!
                photos.append(photo!)
                thumb = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/s150x150/e15/11192696_824079697688618_1761661_n.jpg")!)
                thumb!.isVideo = true
                thumbs.append(thumb!)

                photo = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11240463_963135443745570_1519872157_n.jpg")!)
                photo!.videoURL = NSURL(string: "https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11237510_945154435524423_2137519922_n.mp4")!
                photos.append(photo!)
                thumb = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11240463_963135443745570_1519872157_n.jpg")!)
                thumb!.isVideo = true
                thumbs.append(thumb!)

                photo = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11313531_1625089227727682_169403963_n.jpg")!)
                photo!.videoURL = NSURL(string: "https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11336249_1783839318509644_116225363_n.mp4")!
                photos.append(photo!)
                thumb = MWPhoto(URL: NSURL(string: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11313531_1625089227727682_169403963_n.jpg")!)
                thumb!.isVideo = true
                thumbs.append(thumb!)

                // Options
                startOnGrid = true

//            case 9:
//                let lockQueue = dispatch_queue_create("libraryLoadingQueue", DISPATCH_QUEUE_SERIAL)
//                dispatch_sync(lockQueue) {
//                    var copy = self.assets
//                    if NSClassFromString("PHAsset") != nil {
//                        // Photos library
//                        var screen = UIScreen.mainScreen()
//                        var scale: CGFloat = screen.scale
//                        // Sizing is very rough... more thought required in a real implementation
//                        var imageSize: CGFloat = max(screen.bounds.size.width, screen.bounds.size.height) * 1.5
//                        var imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale)
//                        var thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale)
//                        for asset: PHAsset in copy {
//                            photos.append(MWPhoto.photoWithAsset(asset, targetSize: imageTargetSize))
//                            thumbs.append(MWPhoto.photoWithAsset(asset, targetSize: thumbTargetSize))
//                        }
//                    } else {
//                        // Assets library
//                        for asset: ALAsset in copy {
//                            var photo = MWPhoto.photoWithURL(asset.defaultRepresentation().url)
//                            photos.append(photo!)
//                            var thumb = MWPhoto.photoWithImage(UIImage(CGImage: asset.thumbnail()))
//                            thumbs.append(thumb)
//                            if asset.valueForProperty(ALAssetPropertyType) == .Video {
//                                photo.videoURL = asset.defaultRepresentation().url
//                                thumb.isVideo = true
//                            }
//                        }
//                    }
//                }



            default:
                break
        }

        self.photos = photos
        self.thumbs = thumbs

        // Create browser
        var browser = MWPhotoBrowser(delegate: self)
        browser.displayActionButton = displayActionButton
        browser.displayNavArrows = displayNavArrows
        browser.displaySelectionButtons = displaySelectionButtons
        browser.alwaysShowControls = displaySelectionButtons
        browser.zoomPhotosToFill = true
        browser.enableGrid = enableGrid
        browser.startOnGrid = startOnGrid
        browser.enableSwipeToDismiss = false
        browser.autoPlayOnAppear = autoPlayOnAppear

        // Reset selections
        if displaySelectionButtons {
            self.selections = [AnyObject]()
            for i in 0 ..< photos.count {
                selections.append(Int(false))
            }
        }

        // Show
        if segmentedControl.selectedSegmentIndex == 0 {
            // Push
            self.navigationController!.pushViewController(browser, animated: true)
        } else {
            // Modal
            var nc = UINavigationController(rootViewController: browser)
            nc.modalTransitionStyle = .CrossDissolve
            self.presentViewController(nc, animated: true, completion: { _ in })
        }

        // Release
        // Deselect
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // Test reloading of data after delay
        let delayInSeconds: Double = 3
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in })
    }

    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }

    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < photos.count {
            return photos[Int(index)] as! MWPhotoProtocol
        }
        return MWPhoto()
    }

    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < thumbs.count {
            return thumbs[Int(index)] as! MWPhotoProtocol
        }
        return MWPhoto()
    }

    func photoBrowser(photoBrowser: MWPhotoBrowser!, didDisplayPhotoAtIndex index: UInt){
         print("Did start viewing photo at index \(UInt(index))")
    }

    func photoBrowser(photoBrowser: MWPhotoBrowser!, isPhotoSelectedAtIndex index: UInt) -> Bool {
        return Bool(selections[Int(index)] as! NSNumber)
    }

    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt, selectedChanged selected: Bool) {
        selections[Int(index)] = Int(selected)
        print("Photo at index \(UInt(index)) selected \(selected ? "YES" : "NO")")
    }

    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        // If we subscribe to this method we must dismiss the view controller ourselves
        print("Did finish modal presentation")
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func loadAssets() {

    }

}