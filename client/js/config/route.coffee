Router.configure layoutTemplate: 'main'
Router.map ->
  @route 'home',
    path: '/'
    template: 'index'
  return