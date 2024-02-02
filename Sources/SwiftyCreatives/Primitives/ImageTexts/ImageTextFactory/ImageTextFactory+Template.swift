//
//  TextFactory+Template.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/20.
//

public extension ImageTextFactory {
    enum Template {
        public static let numbers = "0123456789"
        public static let numerics = "0123456789:.-"
        public static let symbols = ",./_<>?;:]+*}@[`{!#$%&'()-=^~¥|–"
        public static let alphabets = "abcdefghijkmlnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        public static let hiragana = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
        public static let katakana = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン"
        public static let katakanaHalf = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝ"
        
        public static let all = numerics+symbols+alphabets+hiragana+katakana+katakanaHalf
    }
}
