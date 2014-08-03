//
//  KFService.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-07-23.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

private let instance = KFService();

class KFService: NSObject {
    class func getInstance() -> KFService{
        return instance;
    }
    
    private var host:String?;
    private var baseURL:String?;
    
    private var jsonScanner:iKFJSONScanner?;
    
    //cache
    private var currentRegistration:KFRegistration?;
    private var views = [String: KFView]();
    private var editTemplate:String?;
    private var readTemplate:String?;
    private var mobileJS:String?;
    private var currentUser:KFUser?;
    
    private init(){
    }
    
    func initialize(host:String){
        self.host = host;
        self.baseURL = "http://\(host)/kforum/";
        
        self.jsonScanner = iKFJSONScanner();
        
        //clear cache
        self.currentRegistration = nil;
        self.views = [String: KFView]();
        self.editTemplate = nil;
        self.readTemplate = nil;
        self.mobileJS = nil;
        self.currentUser = nil;
    }
    
    func getHost() -> String{
        return self.host!;
    }
    
    func getHostURL() -> String{
        return "http://\(host)/";
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
    
    func getMobileJS() -> String{
        if(mobileJS == nil){
            mobileJS = getURL("https://dl.dropboxusercontent.com/u/11409191/ikf/kfmobile.js");
        }
        return mobileJS!;
    }
    
    func getEditTemplate() -> String{
        if(editTemplate == nil){
            editTemplate = getURL("http://dl.dropboxusercontent.com/u/11409191/ikf/edit.html");
        }
        return editTemplate!;
    }
    
    func getReadTemplate() -> String{
        if(readTemplate == nil){
            readTemplate = getURL("http://dl.dropboxusercontent.com/u/11409191/ikf/read.html");
        }
        return readTemplate!;
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
        let url = "\(self.baseURL!)rest/account/userLogin";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("userName", value: userName);
        req.addParam("password", value: password);
        let res = KFHttpConnection.connect(req);
        return res.getStatusCode() == 200;
    }
    
    func getCurrentUser() -> KFUser{
        if(currentUser == nil){
            refreshCurrentUser();
        }
        return self.currentUser!;
    }
    
    func refreshCurrentUser() -> Bool{
        let url = "\(self.baseURL!)rest/account/currentUser";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in currentUser() code=\(res.getStatusCode())");
            return false;
        }
        
        let json: AnyObject = res.getBodyAsJSON();
        let each = json as NSDictionary;
        let model = KFUser();
        model.guid = each["guid"] as String;
        model.firstName = each["firstName"] as String;
        model.lastName = each["lastName"] as String;
        
        self.currentUser = model;
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
        return jsonScanner!.scanRegistrations(res.getBodyAsJSON()) as  [KFRegistration];
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
    
    func getViews(communityId:String) -> [KFView]{
        let url = "\(self.baseURL!)rest/content/getSectionViews/\(communityId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getViews() code=\(res.getStatusCode())");
            return [];
        }
        return jsonScanner!.scanViews(res.getBodyAsJSON()) as  [KFView];
    }
    
    func getPosts(viewId:String) -> [String: KFReference]{
        let url = "\(self.baseURL!)rest/content/getView/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "GET");
        let res = KFHttpConnection.connect(req);
        if(res.getStatusCode() != 200){
            handleError("in getPosts() code=\(res.getStatusCode())");
            return [:];
        }
        let json: AnyObject = res.getBodyAsJSON();
        //println(res.getBodyAsJSON())
        return jsonScanner!.scanPosts(res.getBodyAsJSON()) as [String: KFReference];
    }
    
    func updatePostRef(viewId:String, postRef:KFReference) -> Bool{
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
    
    func createNote(viewId:String, buildsOn:KFReference? = nil, location:CGPoint, title:String = "NewNote", body:String = "") -> Bool{
        let url = "\(self.baseURL!)rest/mobile/createNote/\(viewId)";
        let req = KFHttpRequest(urlString: url, method: "POST");
        req.addParam("x", value: String(Int(location.x)));
        req.addParam("y", value: String(Int(location.y)));
        req.addParam("title", value: title);
        req.addParam("body", value: body);
        if(buildsOn){
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
        return jsonScanner!.scanScaffolds(res.getBodyAsJSON()) as [KFScaffold];
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
        let filenameBase = jsonScanner?.generateRandomString(8);
        let filename = "\(filenameBase!).png";
        
        let jsonobj:AnyObject? = self.sendAttachment(imageData, mime: "image/png", filename: filename);
        if(!jsonobj){
            return false;
        }
        
        let w = Int(image.size.width);
        let h = Int(image.size.height);
        let attachmentURL = ((jsonobj! as NSDictionary)["url"]) as String;
        var svg = NSMutableString();
        svg.appendFormat("<svg width=\"%d\" height=\"%d\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">", w, h);
        svg.appendFormat("<g id=\"group\">");
        svg.appendFormat("<title>Layer 1</title>");
        svg.appendFormat("<image xlink:href=\"/%@\" id=\"svg_5\" x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" />", attachmentURL, w, h);
        svg.appendFormat("</g></svg>");
        
        let drawingResult = self.createDrawing(viewId, svg: svg, location: location);
        
        return drawingResult;
    }
    
    private func sendAttachment(data:NSData, mime:String, filename:String) -> AnyObject!{
        // generate url
        let url = "\(self.baseURL!)rest/file/easyUpload/" + currentRegistration!.communityId;
        
        // generate form boundary
        let key = jsonScanner?.generateRandomString(16);
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
        KFAppUtils.debug("KFService: Error: \(msg)");
    }
    
    
}

// JSON on Swift requires painful code, so I decided to stay this part on Obj-C
//    let json: AnyObject = res.getBodyAsJSON();
//    var models = [KFRegistration]();
//    for each in (json as Array<NSDictionary>) {
//    var model = KFRegistration();
//    model.guid = each["guid"] as String;
//    model.communityId = each["sectionId"] as String;
//    model.communityName = each["sectionTitle"] as String;
//    model.roleName = (each["roleInfo"] as NSDictionary)["name"] as String;
//    models.append(model);
//    }
//    return models;
