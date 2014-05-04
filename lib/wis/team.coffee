'use strict'

_ = require('lodash')
util = require('../util')
postal = require('postal')

# viewer, player, spy, civil, blank, leave
module.exports = (->
    class Team
        constructor: (@id, @io) ->
            @group = {}
            @users = []

        member: ->@users
        player: ->@group.player
        civil:  ->@group.civil
        spy:    ->@group.spy
        getHit:    ->@group.hit

        length: ->@users.length
        index: (where)->_.findIndex(@users, where)

        beforePlay: ->
            sliced = util.sliceRnd(@users, 1)
            @group.spy = sliced[0]
            @group.civil = sliced[1]
            @group.player = _.clone @users
            @group.hit = []
            @group.leaver = []
            return

        broadcast: (group, event, data)->
            if group == 'all'
                @io.sockets.in(@id).emit event, data
            else
                p.getSocket().emit(event, data) for p in @group[group]
            return

        hit: (player)->
            # _.pull(@group.player, player)
            console.log hithit: player
            @group.hit.push(player)

        getRole: (player)->
            return 'civil' if _.contains(@civil(), player)
            return 'spy' if _.contains(@spy(), player)
            return 'unknown'

        getGameResult: ->
            spy = _.clone @spy()
            hit = @getHit()
            _.pull(spy, h) for h in hit

            winner = ''
            if spy.length == 0
                winner = 'civil'
            else
                if (@player().length - hit.length <=3 )
                    winner = 'spy'

            gameover = winner != ''
            list = []
            if gameover
                self = @
                print = (p)->
                    role = self.getRole(p)
                    line = p.profile.slogan
                    line += role
                    line += (if role == winner then '【赢】' else '【输】')
                    return line
                list = (print(p) for p in self.player())

            return {
                winner: winner
                gameover: winner != ''
                list: list
            }

        add: (player)->
            _.remove(@users, (p)->p.id == player.id) if @users
            @users.push(player)
            player.getSocket().join(@id)
            console.log in: "#{player.id}<<<#{@id}>>>#{player.socketID}"
            @emitMemberChange()

        remove: (player)->
            _.remove(@users, (p)->p.id == player.id)
            player.getSocket().leave(@id)
            console.log out: "#{player.id}<<<#{@id}>>>#{player.socketID}"
            @emitMemberChange()

        batchAdd: (users)->
            @add(p) for p in users

        emitMemberChange: ->
            postal.publish(
                channel : "game"
                topic   : "member.change",
                data    : @
            )

    return Team
)()
