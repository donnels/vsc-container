function FindProxyForURL(url, host) {
    if (host === "steamdeck.fritz.box" || host === "localhost") {
        return "DIRECT";
    }
    if (dnsDomainIs(host, "warp.vsagcrd.org") || shExpMatch(host, "*.warp.vsagcrd.org")) {
        return "PROXY http://localhost:3128";
    }
    if (dnsDomainIs(host, "vsagcrd.org") || shExpMatch(host, "*.vsagcrd.org")) {
        return "PROXY http://macbookpro.fritz.box:3128";
    }
return "DIRECT";
}
