//
//  Constant.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import LBTAComponents

class RIAlert {
    static let OK = "OK"
}

class RIAPI {
    
    static let BASE_URL = "http://www.runit.fr/api/v1/"
    static let AUTH_EMAIL = "kwach.yami@gmail.com"
    static let AUTH_PASSWORD = "123456"
    static let AUTH_TOKEN = "qUCjNxkbpwsz8a-Tby-BFmzKybU1WW5eSL6qzC2z"
    
    static let PROJECT_DOMAIN = "com.runit"
    
    static let HEADER_EMAIL = "X-User-Email"
    static let HEADER_TOKEN = "X-User-Token"
    
    static let ROUTE_LOGIN = "login"
    static let ROUTE_SIGN_UP = "sign_up"
    
    static let ROUTE_EVENTS = "events"
    static let ROUTE_INVITATIONS = "invitations"
    static let ROUTE_POSTS = "posts"
    static let ROUTE_RUNS = "runs"
    static let ROUTE_USERS = "users"
}

class RIAsset {
    /// LOGO
    static let LG_RUNIT = "lg-runit"
    
    static let BACKGROUND = "bg-default"
    
    /// ICON
    static let ADD_PERSON = "i-add-person"
    static let ADD_POST = "i-add-post"
    static let SEARCH = "i-search"
    static let LIKE = "i-thumb-up"
    static let COMMENT = "i-comment"
    static let EDIT = "i-edit"
    static let DELETE = "i-delete"
    static let LOGOUT = "i-power-off"
    static let MENU =  "i-menu"
    
    /// PICTURE
    static let PP_PLACEHOLDER = "pp-placeholder"
    static let PIC_PLACEHOLDER = "pic-placeholder"
}

class RIFormat {
    static let BACKSLASH_N = "\n"
    static let SLASH = "/"
}

class RISize {
    static let POST_IMG_TOP_CONSTANT = 12
    static let POST_IMG_LEFT_CONSTANT = 12
    static let POST_USERNAME_RIGHT_CONSTANT = 12
    static let POST_PADDING_TOP = 12
    static let POST_USERNAME_HEIGHT_CONSTANT = 20
    static let POST_PSEUDONYM_HEIGHT_CONSTANT = 20
    static let POST_IMG_WIDTH_CONSTANT = 50
    
    static let EVENT_IMG_TOP_CONSTANT = 12
    static let EVENT_IMG_LEFT_CONSTANT = 12
    static let EVENT_USERNAME_RIGHT_CONSTANT = 12
    static let EVENT_PADDING_TOP = 12
    static let EVENT_USERNAME_HEIGHT_CONSTANT = 20
    static let EVENT_PSEUDONYM_HEIGHT_CONSTANT = 20
    static let EVENT_IMG_WIDTH_CONSTANT = 50
    
    static let PARAGRAPH_LINE_SPACING = 4
    static let VIEW_PADDING = 4
    
    // Assets
    static let POST_BTN_W_H = 20
    
    // Header
    static let HEADER_LOGO_W_H = 40
    static let HEADER_LOGO_W_H_2 = 35
    
    // Footer
    static let FOOTER_EXTRA_HEIGHT = 14
}

class RIError {
    static let NOT_IMPLEMENTED = "has not been implemented"
    static let UNRESOLVED_ERROR = "Unresolved error"
    static let SOMETHING_WENT_WRONG = "Oups ! Something went wrong. Please try again..."
}

class RICore {
    static let CELL_ID = "cellId"
    static let HEADER_ID = "headerId"
    static let FOOTER_ID = "footerId"
}

class RILabel {
    static let RUNIT = "RunIt"
    static let ADD = "AJOUTER"
    static let TIMELINE = "FIL D'ACTUALITÉ"
    static let POST = "POST"
    static let FOLLOW = "SUIVRE"
    static let JOIN = "REJOINDRE"
    static let EVENTS = "ÉVÈNEMENTS"
    
    static let SHOW_ME_MORE = "Show me more"
}

class RIString {
    static let SENTENCE = "Hello, que pensez-vous d'organiser un Run collectif le samedi 30 Septembre 2017 à 15h tous ensemble ? Rejoignez la team de dev RunIt !"
    
    static let LOREM_IPSUM = "[Lorem ipsum dolor sit amet, nemore detraxit atomorum eu vis, libris consectetuer sed no, sea case dolores eu. Nec cu wisi soleat, vide ullum adipiscing ea qui, unum ignota ex eum. Eos erant conclusionemque te, pri elitr appellantur te. Saperet forensibus reprehendunt mea id, in nec ferri primis cotidieque.]"
    
    /// POST
    static let USER_ID = 1
    static let LASTNAME = "Nguyen"
    static let FIRSTNAME = "Denise"
    static let USERNAME = FIRSTNAME + " " +  LASTNAME
    static let PSEUDONYM = "@nise2"
    static let EMAIL = "denise.nguyen@epitech.eu"
    static let ADDRESS = "24 Rue Pasteur, 94270 Le Kremlin-Bicêtre"
    static let PHONE = "0102030405"
    static let PP = "pp-dnguyen"
    
    static let USER_ID2 = 2
    static let LASTNAME2 = "SAYSANNA"
    static let FIRSTNAME2 = "Jean-Paul"
    static let USERNAME2 = FIRSTNAME2 + " " +  LASTNAME2
    static let PSEUDONYM2 = "@jp"
    static let EMAIL2 = "jp@epitech.eu"
    static let ADDRESS2 = "25 Rue Pasteur, 94270 Le Kremlin-Bicêtre"
    static let PHONE2 = "0202030405"
    static let PP2 = "pp-jp"
    
    static let POST_ID = 1
    static let POST = "Coucou les amis ceci est mon premier post."
    static let COM_ID = 1
    static let COMMENT = "Voici mon premier commentaire."
    
    static let POST_ID2 = 2
    static let POST2 = "Yo deuxième post"
    static let COM_ID2 = 2
    static let COMMENT2 = "2eme commentaire."
    
    
    static let PIC_NAME_POST = "name_pic"
    static let PIC_URL_POST = "/pics/" + PIC_NAME_POST
    static let PIC_NAME_COM = "name_com"
    static let PIC_URL_COM = "/pics/" + PIC_NAME_COM
    
    static let PIC_NAME_POST2 = "name_pic2"
    static let PIC_URL_POST2 = "/pics/" + PIC_NAME_POST2
    static let PIC_NAME_COM2 = "name_com2"
    static let PIC_URL_COM2 = "/pics/" + PIC_NAME_COM2
    
    
    static let DEFAULT_USERNAME = "[username]"
    static let DEFAULT_PSEUDONYM = "[pseudonym]"
    /// EVENT
    static let DEFAULT_EVENT_NAME = "[event name]"
    static let DEFAULT_EVENT_PSEUDONYM = "[@jeanjacques]"
    static let DEFAULT_SENTENCE = "[This is a typical sentence example. And this is a second one.]"
    
    
    static let EVENT_ID = 1
    static let EVENT_NAME = "1er event"
    static let EVENT_DESC = "test description 1"
    // static let EVENT_START =
    // static let EVENT_END =
    static let EVENT_CITY = "Lille"
    static let EVENT_IS_PRIVATE = false
    static let EVENT_DISTANCE = 111
    static let EVENT_USER_ID = 1
    static let EVENT_PIC = "pic-city"
    
    static let EVENT2_ID = 1
    static let EVENT2_NAME = "2e event"
    static let EVENT2_DESC = LOREM_IPSUM
    // static let EVENT2_START =
    // static let EVENT2_END =
    static let EVENT2_CITY = "Lille"
    static let EVENT2_IS_PRIVATE = true
    static let EVENT2_DISTANCE = 222
    static let EVENT2_USER_ID = 2
    static let EVENT_PIC2 = "pic-forest"
}

class RIColors {
    
    //    body: {background: #e9ecf3 }
    //    Block:{ background: #FFF, border-radius: 4px }
    //Button principale: { background: #32c5d2;
    //    color: #FFF;
    //}
    //Button cancel: { background: rgb(243, 106, 90); }
    //Button norma; { background: rgb(51, 122, 183); }
    //link: {color: #32c5d2 }
    //title: {color: #697882 }
    //Menu title: { color: #5b9bd1 }
    static let CYAN = UIColor(r: 50, g: 197, b: 210) // theme color
    static let LIGHTGRAY = UIColor(r: 233, g: 236, b:243) // backgroundcolor
    static let GRAY = UIColor(r: 230, g: 230, b: 230)
    static let GRAY_BLUE = UIColor(r: 232, g: 236, b: 241)
    static let BLUE_SKY = UIColor(r: 126, g: 192, b: 238)
    static let WHITE = UIColor.white
    static let BLACK = UIColor.black
    static let FONT_GRAY = UIColor(r: 130, g: 130, b: 130)
    static let RED = UIColor(r: 208, g: 20, b: 128) // Attention/deletion
    static let GREEN = UIColor(r:23 , g: 181, b: 136)
}

