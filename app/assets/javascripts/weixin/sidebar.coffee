# class @Sidebar
#
#   constructor: ->
#     @sidebar = $(".sidebar")
#     @sidebarMask = $(".popup-mask")
#     @status = 'closed'
#
#   start: ->
#     bindOpen(@)
#
#   bindOpen = (sidebar) ->
#     if $('.sidebar-toggle').length != 0
#       $('.sidebar-toggle').tap ->
#         sidebar.open()
#       $('.page').swipeRight ->
#         sidebar.open()
#         return false
#
#   bindClose = (sidebar) ->
#     if $('.sidebar-toggle').length != 0
#       sidebar.sidebarMask.tap ->
#         sidebar.close()
#       sidebar.sidebarMask.swipeLeft ->
#         sidebar.close()
#
#   unbindOpen = (sidebar) ->
#     if $('.sidebar-toggle').length != 0
#       $('.sidebar-toggle').unbind('tap')
#       $('.page').unbind('swipeRight')
#
#   unbindClose = (sidebar) ->
#     if $('.sidebar-toggle').length != 0
#       sidebar.sidebarMask.unbind('tap')
#       sidebar.sidebarMask.unbind('swipeLeft')
#
#   open: ->
#     @sidebarMask.addClass("popup-mask__open")
#     @sidebar.addClass("sidebar__open")
#     @status = 'opened'
#     unbindOpen(@)
#     bindClose(@)
#
#   close: ->
#     @sidebarMask.removeClass("popup-mask__open")
#     @sidebar.removeClass("sidebar__open")
#     @status = 'closed'
#     unbindClose(@)
#     bindOpen(@)
