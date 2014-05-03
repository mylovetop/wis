'use strict'
_ = require('lodash')

exports.cnNum = (n)->
    a = ['一','二','三','四','五','六','七','八','九','十','十一','十二','十三','十四','十五','十六','十七','十八','十九','廿','廿一','廿二','廿三','廿四']
    a[n-1]

exports.cnTeamname = (n)->
    n = '%s' unless n
    prefix = [
        '戊戌'
        '扬州'
        '竹林'
        '天朝'
        '东北'
        '西南'
        '东南'
        '西北'
        '中原'
        '塞外'
        '关东'
        '天山'
        '华山'
        '正大'
        '江南'
        '平顶山'
        '双龙山'
        '大渡口'
        '沙坪坝'
        '南坪'
        '鱼洞'
        '渝北'
        '春秋'
        '大唐'
        '战国'
        '绝代'
        ]
    postfix = [
        '贤'
        '君子'
        '骄'
        '杰'
        '俊'
        '霸'
        '怪'
        '虎'
        '鹰'
        '少'
        '剑'
        '英'
        '怪'
        '圣'
        '雄'
        '豪'
        '壕'
        ]
    # n = cnNum(n) if _.isNumber(n)
    _.sample(prefix) + n + _.sample(postfix)
