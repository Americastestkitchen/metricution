Metricution.BathroomView = Ember.View.extend
  templateName: 'bathroom'
  classNames: ['bathroom'],
  classNameBindings: ['context.status'],

  didInsertElement: ->
    bathroomCount = $('.bathrooms .bathroom').length
    $('.bathrooms .bathroom').css('height', "#{100/bathroomCount}%")
    @resizeFont()

  resizeFont:(->
    @$().bigtext
      maxfontsize: @$().height()

    divHeight = @$().height()
    pHeights = @$('.name').height() + @$('.status-updated-at').height()
    if pHeights > divHeight
      @$('.status-updated-at').hide()

  ).observes('context.statusUpdatedAtRelative')
