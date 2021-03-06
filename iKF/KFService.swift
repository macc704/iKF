//
//  KFService.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

private let kfServiceInstance = KFService();

class KFService: NSObject {
    class func getInstance() -> KFService{
        return kfServiceInstance;
    }
    
    private var host:String?;
    private var baseURL:String?;
    var username:String?
    var password:String?
    
    private var jsonScanner = KFJSONScanner();
    
    //cache
    var currentRegistration:KFRegistration!;
    var currentUser:KFUser!;
    
    private var editTemplate:String?;
    private var readTemplate:String?;
    private var mobileJS:String?;
    
    private override init(){
    }
    
    func initialize(host:String){
        self.host = host;
        self.baseURL = "http://\(host)/kforum/";
        
        //clear cache
        self.currentRegistration = nil;
        self.currentUser = nil;
        self.editTemplate = nil;
        self.readTemplate = nil;
        self.mobileJS = nil;
    }
    
    func getHost() -> String{
        return self.host!;
    }
    
    func getHostURLString() -> String{
        return "http://\(host!)/";
    }
    
    func getAppURL() -> String{
        return self.baseURL!;
    }
    
    func getHostURL() -> NSURL{
        return NSURL(string: getHostURLString())!;
    }
    
    func testConnectionToGoogle() -> Bool{
        return self.test("http://www.google.com/").getStatusCode() == 200;
    }
    
    func testConnectionToTheHost() -> Bool{
        return self.test(self.baseURL!).getStatusCode() == 200;
    }
    
    func test(urlString:String) -> KFHttpResponse{
        let req = KFHttpRequest(urlString: urlString, method: "GET");
        req.nsRequest.timeoutInterval = 12.0;
        let res = KFHttpConnection.connect(req);
        return res;
    }
    
    func getURL(urlString:String) -> String?{
        let req = KFHttpRequest(urlString: urlString, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            return nil;
        }
        return res.getBodyAsString();
    }
    
    func login(userName:String, password:String) -> Bool{
        logout();
        let url = "\(self.baseURL!)rest/account/userLogin";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("userName", value: userName);
        req.addParam("password", value: password);
        self.username = userName;
        self.password = password;
        let res = KFHttpConnection.connect(req);
        return res.getStatusCode() == 200;
    }
    
    private func logout() -> Bool{
        let url = "\(self.baseURL!)rest/account/userLogout";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        return res.getStatusCode() == 200;
    }
    
    func refreshCurrentUser() -> Bool{
        let url = "\(self.baseURL!)rest/account/currentUser";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in currentUser() code=\(res.getStatusCode())");
            return false;
        }
        
        let json = res.getBodyAsJSON();
        let user = jsonScanner.scanUser(json);
        self.currentUser = user;
        return true;
    }
    
    func registerCommunity(registrationCode:String) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/register/" + registrationCode;
        let req = KFHttpRequest(urlString: url, method: "POST");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in registerCommunity() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func getRegistrations() -> [KFRegistration]{
        let url = "\(self.baseURL!)rest/account/registrations";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getRegistrations() code=\(res.getStatusCode())");
            return [];
        }
        return jsonScanner.scanRegistrations(res.getBodyAsJSON()).array;
    }
    
    func enterCommunity(registration:KFRegistration) -> Bool{
        let url = "\(self.baseURL!)rest/account/selectSection/\(registration.guid)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in enterCommunity() code=\(res.getStatusCode())");
            return false;
        }
        self.currentRegistration = registration;
        return true;
    }
    
    func refreshViews(){
        self.currentRegistration.community.views = getViews(self.currentRegistration.community.guid);
    }
    
    private func getViews(communityId:String) -> KFModelArray<KFView>{
        //        let url = "\(self.baseURL!)rest/content/getSectionViews/\(communityId)";
        let url = "\(self.baseURL!)rest/mobile/getViewsOrdered/\(communityId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getViews() code=\(res.getStatusCode())");
            return KFModelArray<KFView>();
        }
        return jsonScanner.scanViews(res.getBodyAsJSON());
    }
    
    func refreshMembers(){
        self.currentRegistration.community.members = getMembers(self.currentRegistration.community.guid);
    }
    
    private func getMembers(communityId:String) -> KFModelArray<KFUser>{
        let url = "\(self.baseURL!)rest/mobile/getMembers/\(communityId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getViews() code=\(res.getStatusCode())");
            return KFModelArray<KFUser>();
        }
        return jsonScanner.scanUsers(res.getBodyAsJSON());
    }
    
    func getAllPosts() -> KFModelArray<KFPost>{
        let url = "\(self.baseURL!)rest/mobile/getPostsOrdered/\(currentRegistration.community.guid)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getPostsOrdered() code=\(res.getStatusCode())");
            return KFModelArray<KFPost>();
        }

        return jsonScanner.scanPosts(res.getBodyAsJSON());
    }
    
    func getPost(postId:String) -> KFPost?{
        let url = "\(self.baseURL!)rest/mobile/getPost/\(postId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getPost() code=\(res.getStatusCode())");
            return nil;
        }
        let json = res.getBodyAsJSON();
        let post = jsonScanner.scanPost(json["body"]);
        //builds-on parsing ommited now
        return post;
    }
    
    func getPostRefs(viewId:String) -> [String: KFReference]{
        let url = "\(self.baseURL!)rest/mobile/getView/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getPosts() code=\(res.getStatusCode())");
            return [:];
        }
        let json = res.getBodyAsJSON();
        let dic = jsonScanner.scanView(json).dic;
        return dic;
    }
    
    func getPostRef(postRefId:String) -> KFReference?{
        let url = "\(self.baseURL!)rest/mobile/getPostRef/\(postRefId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getPosts() code=\(res.getStatusCode())");
            return nil;
        }
        let json = res.getBodyAsJSON();
        let ref = jsonScanner.scanPostRef(json["body"]);
        
        for each in json["buildsons"].asArray! {
            let fromId = each["from"].asString!;
            let toId = each["to"].asString!; //parent
            if(fromId == ref.post!.guid){ //be supposed to
                ref.post!.buildsOn = getPost(toId);
            }
        }
        return ref;
    }
    
    func updatePostAuthors(post:KFPost) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/updatePostAuthors/\(post.guid)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParams("authorIds", values: post.authors.keys.array);
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in updatePostRef() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func updatePostRef(viewId:String, postRef:KFReference) -> Bool{
        postRef.location.x = max(5, postRef.location.x);//avoid minus
        postRef.location.y = max(5, postRef.location.y);//avoid minus
        postRef.location.x = min(3995, postRef.location.x);//avoid over range
        postRef.location.y = min(2995, postRef.location.y);//avoid over range
        if(postRef.isShowInPlace() && postRef.width < 50){
            postRef.width = 50;
        }
        if(postRef.isShowInPlace() && postRef.height < 50){
            postRef.height = 50;
        }
        let url = "\(self.baseURL!)rest/mobile/updatePostRef/\(viewId)/\(postRef.guid)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(postRef.location.x)));
        req.addParam("y", value: String(Int(postRef.location.y)));
        //println(postRef.width);
        //println(postRef.height);
        req.addParam("width", value: String(Int(postRef.width)));
        req.addParam("height", value: String(Int(postRef.height)));
        req.addParam("rotation", value: "\(Double(postRef.rotation))");
        req.addParam("display", value: String(Int(postRef.displayFlags)));
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in updatePostRef() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func deletePostRef(viewId:String, postRef:KFReference) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/deletePostRef/\(viewId)/\(postRef.guid)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in deletePostRef() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func getNoteAsHTML(post:KFPost) -> String{
        let url = "\(self.baseURL!)rest/mobile/getNoteAsHTMLwJS/\(post.guid)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getNoteAsHTML() code=\(res.getStatusCode())");
            return "";
        }
        return req.getBodyAsString();
    }
    
    func readPost(post:KFPost) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/readPost/\(post.guid)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in readPost() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func createView(title:String, viewIdToLink:String?, location:CGPoint?, isPrivate:Bool) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createView/";
        let req = KFHttpRequest(urlString: url, method: "POST");
        if(viewIdToLink != nil){
            req.addParam("viewIdToLink", value: viewIdToLink!);
            req.addParam("x", value: String(Int(location!.x)));
            req.addParam("y", value: String(Int(location!.y)));
            req.addParam("isPrivate", value: "\(isPrivate)");
        }
        req.addParam("title", value: title);
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in createView() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func createNote(viewId:String, buildsOn:KFReference? = nil, location:CGPoint, title:String = "NewNote", body:String = "") -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createNote/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(location.x)));
        req.addParam("y", value: String(Int(location.y)));
        req.addParam("title", value: title);
        req.addParam("body", value: body);
        if(buildsOn != nil){
            req.addParam("buildsOnNoteId", value: buildsOn!.guid);
        }
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in createNote() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func createViewLink(fromViewId:String, toViewId:String, location:CGPoint) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createViewLink/\(fromViewId)/\(toViewId)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(location.x)));
        req.addParam("y", value: String(Int(location.y)));
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in createViewLink() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func createPostLink(fromViewId:String, toPostId:String, location:CGPoint) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createPostLink/\(fromViewId)/\(toPostId)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(location.x)));
        req.addParam("y", value: String(Int(location.y)));
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in createPostLink() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func updateNote(note:KFNote)->Bool{
        let url = "\(self.baseURL!)rest/mobile/updateNote/\(note.guid)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("title", value: note.title);
        req.addParam("body", value: note.content);
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in updateNote() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func getScaffolds(viewId:String) -> [KFScaffold]{
        let url = "\(self.baseURL!)rest/mobile/getScaffolds/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getScaffolds() code=\(res.getStatusCode())");
            return [];
        }
        return jsonScanner.scanScaffolds(res.getBodyAsJSON()).array;
    }
    
    func getNextViewVersionAsync(viewId:String, currentVersion:Int) -> Int{
        let url = "\(self.baseURL!)rest/mobile/getNextViewVersionAsync/\(viewId)/\(String(currentVersion))";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getNextViewVersionAsync() code=\(res.getStatusCode())");
            return -1;
        }
        return res.getBodyAsString().toInt()!;
    }
    
    func createPicture(image:UIImage, viewId:String, location:CGPoint) -> Bool{
        let imageData = UIImagePNGRepresentation(image);
        let filenameBase = iKFUtil.generateRandomString(8);
        let filename = "\(filenameBase!).png";
        
        let jsonobj = self.sendAttachment(imageData, mime: "image/png", filename: filename);
        if(jsonobj == nil){
            return false;
        }
        
        let w = Int(image.size.width);
        let h = Int(image.size.height);
        let attachmentURL = jsonobj!["url"].asString!;
        var svg = NSMutableString();
        svg.appendFormat("<svg width=\"%d\" height=\"%d\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">", w, h);
        svg.appendFormat("<g id=\"group\">");
        svg.appendFormat("<title>Layer 1</title>");
        svg.appendFormat("<image xlink:href=\"/%@\" id=\"svg_5\" x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" />", attachmentURL, w, h);
        svg.appendFormat("</g></svg>");
        
        let drawingResult = self.createDrawing(viewId, svg: svg, location: location);
        
        return drawingResult;
    }
    
    private func sendAttachment(data:NSData, mime:String, filename:String) -> JSON?{
        // generate url
        let url = "\(self.baseURL!)rest/file/easyUpload/" + currentRegistration.community.guid;
        
        // generate form boundary
        let key = iKFUtil.generateRandomString(16);
        let formBoundary = "----FormBoundary\(key!)";
        let path = "C\\fakepath\\\(filename)";
        
        // generate post body
        let postbody = NSMutableData();
        postbody.appendData(stringData(String(format:"--%@\n", formBoundary)));
        postbody.appendData(stringData(String(format:"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\n", filename)));
        postbody.appendData(stringData(String(format:"Content-Type: %@\n\n", mime)));
        postbody.appendData(data);
        postbody.appendData(stringData(String(format:"\n")));
        postbody.appendData(stringData(String(format:"--%@\n", formBoundary)));
        postbody.appendData(stringData(String(format:"Content-Disposition: form-data; name=\"name\"\n")));
        postbody.appendData(stringData(String(format:"\n")));
        postbody.appendData(stringData(String(format:"%@", path)));
        postbody.appendData(stringData(String(format:"\n")));
        postbody.appendData(stringData(String(format:"--%@--\n", formBoundary)));
        
        // generate req
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.nsRequest.setValue(String(format:"multipart/form-data; boundary=%@", formBoundary), forHTTPHeaderField: "Content-Type");
        req.nsRequest.setValue(String(postbody.length), forHTTPHeaderField: "Content-Length");
        req.nsRequest.HTTPBody = postbody;
        
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in sendAttachment() code=\(res.getStatusCode())");
            return nil;
        }
        
        return res.getBodyAsJSON();
    }
    
    private func stringData(text:String) -> NSData{
        return text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!;
    }
    
    private func createDrawing(viewId:String, svg:String, location:CGPoint) -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createDrawing/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(location.x)));
        req.addParam("y", value: String(Int(location.y)));
        req.addParam("svg", value: svg);
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in createDrawing() code=\(res.getStatusCode())");
            return false;
        }
        return true;
    }
    
    func handleError(msg:String){
        //KFAppUtils.debug("KFService: Error: \(msg)");
        KFAppUtils.showAlert("KFService Error: \(msg)", msg: "Please check connection.");
    }
    
    
}
