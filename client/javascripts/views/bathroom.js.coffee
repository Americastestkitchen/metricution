Metricution.BathroomView = Ember.View.extend
  templateName: 'bathroom'
  classNames: ['bathroom'],
  classNameBindings: ['context.status'],

  didInsertElement: ->
    bathroomCount = $('.bathrooms .bathroom').length
    $('.bathrooms .bathroom').css('height', "#{100/bathroomCount}%")
    @resizeFont()

  resizeFont:(->
    divHeight = @$().height()
    pHeights  = @$('.name').height() + @$('.status-updated-at').height()
    @$().bigtext(maxfontsize: divHeight)
    @$('.status-updated-at').hide() if pHeights > divHeight
  ).observes('context.statusUpdatedAtRelative')
