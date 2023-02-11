Array.prototype.forEach || (Array.prototype.forEach = function(r) {
    var o, t;
    if (null == this) throw new TypeError("this is null or not defined");
    var n = Object(this),
        e = n.length >>> 0;
    if ("function" != typeof r) throw new TypeError(r + " is not a function");
    for (arguments.length > 1 && (o = arguments[1]), t = 0; t < e;) {
        var i;
        t in n && (i = n[t], r.call(o, i, t, n)), t++
    }
});
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".mast-share").forEach(function(e, t) {
        e.querySelector(".mast-check-toggle").id = "mast-check-toggle-" + t, e.querySelector(".mast-check-label").htmlFor = "mast-check-toggle-" + t, e.querySelector(".mast-share-button").addEventListener("click", function(t) {
            var a = new RegExp("^(?:(?:https?|ftp)://)?(?:\\S+(?::\\S*)?@|\\d{1,3}(?:\\.\\d{1,3}){3}|(?:(?:[a-z\\d\\u00a1-\\uffff]+-?)*[a-z\\d\\u00a1-\\uffff]+)(?:\\.(?:[a-z\\d\\u00a1-\\uffff]+-?)*[a-z\\d\\u00a1-\\uffff]+)*(?:\\.[a-z\\u00a1-\\uffff]{2,6}))(?::\\d+)?(?:[^\\s]*)?$", "i"),
                n = e.querySelector('input[name="mast-instance-input"]');
            if (a.test(n.value)) {
                var o = `http://${n.value.replace(/(^\w+:|^)\/\//,"")}/share?text=He encontrado este texto de @akalanka@mastodon.art - ${encodeURIComponent(document.title)} - ${encodeURIComponent(location.href)}`;
                window.open(o, "new", "toolbar=no,location=no,status=yes,resizable=yes,scrollbars=yes,height=600,width=400")
            } else n.classList.add("invalid"), setTimeout(function() {
                n.classList.remove("invalid")
            }, 300)
        }), e.addEventListener("mouseleave", function(t) {
            e.querySelector(".mast-check-toggle").checked = !1
        })
    })
});
