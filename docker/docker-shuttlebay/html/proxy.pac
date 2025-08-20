function FindProxyForURL(url, host) {
    if (host === "steamdeck.fritz.box" || host === "localhost") {
        return "DIRECT";
    }
    if (dnsDomainIs(host, "warp.vsagcrd.org") || shExpMatch(host, "*.warp.vsagcrd.org")) {
        return "PROXY steamdeck.fritz.box:3128";
    }
    if (dnsDomainIs(host, "vsagcrd.org") || shExpMatch(host, "*.vsagcrd.org")) {
        return "PROXY macbookpro.fritz.box:3128";
    }
return "DIRECT";
}