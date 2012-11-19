(function($) {
    "use strict";
    var ClassifierSandbox = function(element, options)
    {
        var elem = $(element);
        var canvas;
        var maxDepth = 1;
        
        // These are variables which can be overridden upon instantiation
        var defaults = {
            debug: false,
            width: 1000,
            height: 1000,
            sidebarWidth: 0.2
        };
        
        var settings = $.extend({}, defaults, options);
        
        // These are variables which can not be overridden by the user
        var globals = {
            canvasid: "csbox-canvas"
        };
        
        $.extend(settings, globals);
        
        var init = function() {
            loadPage();
        };
        
        var loadPage = function() {
            // add canvas element to the element tied to the jQuery plugin
            var canvas = $("<canvas>").attr("id", settings.canvasid);
            
            // make canvas dimensions the size of the page
            canvas.attr("width", settings.width);
            canvas.attr("height", settings.height);
            canvas.attr("style", "border: 4px black solid;");

            elem.prepend(canvas);
            
            canvas = new fabric.Canvas(settings.canvasid);
            
            loadDesign(canvas);
        };
        
        var loadDesign = function(canvas) {
            var sidebarHeightPix = settings.height;
            var sidebarWidthPix = settings.width * settings.sidebarWidth;
            var sidebarX = sidebarWidthPix / 2;
            var sidebarY = sidebarHeightPix / 2;
            var sidebar = new fabric.Rect({
                left: sidebarX,
                top: sidebarY,
                width: sidebarWidthPix,
                height: sidebarHeightPix,
                selectable: false,
                fill: 'rgb(200, 200, 200)'
            });
            canvas.add(sidebar);
            
            var classHeightPix = settings.height;
            var classWidthPix = settings.width * (1.0 - settings.sidebarWidth);
            var classX = (settings.width * settings.sidebarWidth) + (classWidthPix / 2);
            var classY = classHeightPix / 2;
            var classSpace = new fabric.Rect({
                left: classX,
                top: classY,
                width: classWidthPix,
                height: classHeightPix,
                selectable: false,
                fill: 'rgb(170, 170, 170)'
            });
            canvas.add(classSpace);
            
            var Neume = fabric.util.createClass(fabric.Object, fabric.Observable, {
                initialize: function(src, options) {
                    this.callSuper('initialize,', options);
                    this.image = new Image();
                    this.image.src = src,
                    this.image.onload = (function() {
                        this.imgWidth = this.image.width;
                        this.imgHeight = this.image.height;
                        this.loaded = true;
                        this.setCoords();
                        this.fire('image:loaded');
                    }).bind(this);
                },
                _render: function(ctx) {
                    if (this.loaded) {
                        ctx.fillStyle = '#eee';
                        ctx.fillRect(
                            -this.width / 2,
                            -this.height / 2,
                            this.width,
                            this.height);
                    }
                }
            });
        };
        
        init();
    };
    
    $.fn.csbox = function(options)
    {
        return this.each(function()
        {
            var element = $(this);

            // Return early if this element already has a plugin instance
            if (element.data('csbox'))
            {
                return;
            }

            // pass options to plugin constructor
            var csbox = new ClassifierSandbox(this, options);

            // Store plugin object in this element's data
            element.data('csbox', csbox);
        });
    };
})(jQuery);
