  function loadXml ()
  {
    var httpxml = new XMLHttpRequest () ;
    httpxml.open ('GET','xml/xpath.xml',false) ;
    httpxml.send (null) ;
    var httpxsl = new XMLHttpRequest () ;
    httpxsl.open ('GET','xml/xpath.xsl',false) ;
    httpxsl.send (null) ;
    var xsltp = new XSLTProcessor () ;
    xsltp.importStylesheet (httpxsl.responseXML) ;
    var html =
      xsltp.transformToDocument (httpxml.responseXML) ;
    var code = document.getElementById ('xml') ;
    var node =
      document.importNode (html.childNodes [0] , true) ;
    code.appendChild (node) ;
  }

  var context = null ;

  function setContext (event , node)
  {
    context = node ;
    var code = document.getElementById ('xml') ;
    var divs = code.getElementsByTagName ('*') ;
    for (var i = 0 ; i != divs.length ; ++ i)
    {
      divs [i].className =
        divs [i].className.replace (/ context ?/,'') ;
    }
    context.className += ' context' ;
    event.stopPropagation () ;
    showAxis (document.getElementById ('axes') .getElementsByTagName ('select') [0].value) ;
  }

  function showAxis (axis)
  {
    if (! context) return ;
    var xpath ;
    if ('ancestor' == axis)
    {
      xpath = 'ancestor::*[contains(@class,"xml")]' ;
    }
    else if ('ancestor-or-self' == axis)
    {
      xpath =
        'ancestor-or-self::*[contains(@class,"xml")]' ;
    }
    else if ('attribute' == axis)
    {
      xpath =
        'child::*' +
        '[contains(@class,"xml")]' +
        '[contains(@class,"attr")]' ;
    }
    else if ('child' == axis)
    {
      xpath =
        'child::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('descendant' == axis)
    {
      xpath =
        'descendant::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('descendant-or-self' == axis)
    {
      xpath =
        'descendant-or-self::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('following' == axis)
    {
      xpath =
        'following::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('following-sibling' == axis)
    {
      xpath =
        'following-sibling::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('parent' == axis)
    {
      xpath = 'parent::*[contains(@class,"xml")]' ;
    }
    else if ('preceding' == axis)
    {
      xpath =
        'preceding::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('preceding-sibling' == axis)
    {
      xpath =
        'preceding-sibling::*' +
        '[contains(@class,"xml")]' +
        '[not(contains(@class,"attr"))]' ;
    }
    else if ('self' == axis)
    {
      xpath = 'self::*[contains(@class,"xml")]' ;
    }
    var code = document.getElementById ('xml') ;
    var divs = code.getElementsByTagName ('*') ;
    for (var i = 0 ; i != divs.length ; ++ i)
    {
      divs [i].className =
        divs [i].className.replace (/ hilite ?/,'') ;
    }
    var hilite =
      document.evaluate
      (
        xpath , context , null ,
        XPathResult.UNORDERED_NODE_ITERATOR_TYPE , null
      ) ;
    var node ;
    var nodes = [] ;
    while (node = hilite.iterateNext ())
    {
      nodes [nodes.length] = node ;
    }
    for (var i = 0 ; i != nodes.length ; ++ i)
    {
      nodes [i].className += ' hilite' ;
    }
  }
