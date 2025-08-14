function FindProxyForURL(url, host) {
    // Forward proxy configuration for SteamDeck development environment
    
    // Routes for internal LCARS services - use forward proxy
    if (dnsDomainIs(host, ".vsagcrd.org")) {
        return "PROXY steamdeck.fritz.box:8443";
    }
    
    // All other traffic - direct connection
    return "DIRECT";
}
