
# Flow Diagrams for native app chatnels widget integration

## Initialization Diagram
pass orgDomain and sessionToken to initialize Chatnels embed and pre-load all the files.
```mermaid
sequenceDiagram
    NativeApp->>Chatnels widget: pass orgDomain, sessionToken
    Chatnels widget-)NativeApp: onReady()
```

## Change view Diagram
pass a new viewData config to change the current Chatnels embed view to chat or bot flowchart
```mermaid
sequenceDiagram
    NativeApp->>Chatnels widget: pass viewData
```

## Request New Session Diagram
How to request a new Chatnels token
```mermaid
sequenceDiagram
    Chatnels widget->>Native App:onRequestionSession()
    Native App->>App Backend: call API to request a new Chatnels session token
    App Backend-)Native App: return new Chatnels session token
    Native App-)Chatnels widget: return new Chatnels session token
```

