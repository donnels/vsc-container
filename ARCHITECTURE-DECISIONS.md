# Architecture Decision Record (ADR)

## Forward Proxy vs Reverse Proxy Architecture

### Context
The VSCode Container project needed to provide secure HTTPS access to a containerized VS Code server from external clients (Meta Quest 3 headset) through a Fritz.Box router without modifying router DNS settings.

### Decision
**Implemented: Reverse Proxy Architecture with Self-Signed Frontend**

### Status
**ACCEPTED** - Implemented in production

### Consequences

#### Architecture Comparison

| Aspect | Forward Proxy (Considered) | Reverse Proxy (Current) |
|--------|---------------------------|-------------------------|
| **SSL Termination** | Transparent tunneling | Proxy terminates & re-encrypts |
| **Certificate Management** | Complex browser proxy setup | Simple self-signed for proxy |
| **WebSocket Support** | Browser proxy limitations | Direct reverse proxy support |
| **Let's Encrypt Usage** | Backend only | Backend only |
| **Client Configuration** | Proxy settings required | None (standard HTTPS) |
| **DNS Requirements** | None | None (direct IP access) |

#### Technical Benefits

**SSL/TLS Simplicity**
- ✅ **Self-signed certificate** on proxy eliminates Let's Encrypt rate limit concerns  
- ✅ **No certificate sharing** between containers - VSCode manages its own LE cert
- ✅ **SSL termination and re-encryption** - proxy decrypts and forwards HTTPS to VSCode
- ✅ **Standard reverse proxy pattern** - well-understood and debuggable

**WebSocket Compatibility**
- ✅ **Direct reverse proxy WebSocket support** - no browser proxy complications
- ✅ **No browser proxy configuration** issues with WebSocket upgrades
- ✅ **Standard HTTPS connection** - browser handles WebSockets normally

**Operational Simplicity**
- ✅ **Single certificate warning** on initial connection (user accepts once)
- ✅ **No browser proxy configuration** required - standard HTTPS access
- ✅ **Direct URL access** - `https://steamdeck.fritz.box:8443` works immediately

#### Service Architecture

```
External Access Flow:
Meta Quest 3 → Fritz.Box → HAProxy Reverse Proxy:8443 → VSCode:8443
    ↑                           ↑                           ↑
Standard HTTPS             Self-signed cert           Let's Encrypt cert
(accept cert once)         SSL termination           (backend security)
```

**Service Network Topology:**
- **HAProxy Proxy**: 172.20.0.11:8443 (Forward proxy + LCARS interface)
- **CoreDNS**: 172.20.0.10:53 (Internal service discovery)
- **VS Code Server**: 172.20.0.12:8443 (HTTPS with Let's Encrypt)
- **Certbot**: 172.20.0.13 (Certificate generation tool)

#### Port Configuration

| Service | External Port | Internal Port | Protocol | Purpose |
|---------|--------------|---------------|----------|---------|
| HAProxy Proxy | 8443 | 8443 | HTTPS | Forward proxy (self-signed) |
| LCARS Interface | 8080 | 8080 | HTTP | Status and configuration UI |
| VS Code Server | - | 8443 | HTTPS | Development environment (LE cert) |
| CoreDNS | - | 53 | DNS | Internal service discovery |

#### Implementation Details

**HAProxy Configuration**
- **Frontend**: HTTPS on port 8443 with self-signed certificate
- **Backend**: Transparent HTTPS tunneling using CONNECT method
- **Security**: ACLs for allowed destination ports and networks
- **Monitoring**: Built-in stats and health endpoints

**Certificate Strategy**
- **Proxy**: Self-signed certificate (no rate limits, no DNS requirements)
- **VSCode**: Let's Encrypt certificate via Cloudflare DNS-01 challenge
- **Isolation**: No certificate sharing between containers

**Client Configuration (Meta Quest 3)**
1. Navigate to `http://steamdeck.fritz.box:8080` for LCARS configuration interface
2. Configure browser proxy settings:
   - HTTP Proxy: `steamdeck.fritz.box:8443`
   - HTTPS Proxy: `steamdeck.fritz.box:8443`
   - SSL: Yes (accept self-signed certificate warning)
3. Access VSCode via proxy: `https://code-dev.vsagcrd.org:8443`

### Alternative Considered

**Reverse Proxy with SSL Termination**
- **Rejected**: Complex SSL certificate sharing, WebSocket proxy issues, high Let's Encrypt usage
- **Issues**: Rate limit concerns, nginx SSL upstream configuration complexity, certificate permission problems

### Revision History
- **2025-08-11**: Initial implementation of forward proxy architecture
- **2025-08-11**: Documented decision rationale and technical benefits
