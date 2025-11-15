import React from "react";
import ReactDOM from "react-dom/client";
import "@mysten/dapp-kit/dist/index.css";
import "@radix-ui/themes/styles.css";
import "./index.css";

import { SuiClientProvider, WalletProvider } from "@mysten/dapp-kit";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Theme } from "@radix-ui/themes";
import App from "./App.tsx";
import { networkConfig } from "./networkConfig.ts";
import { RegisterEnokiWallets } from "./components/RegisterEnokiWallets.tsx";

// Add global error handler
window.addEventListener('error', (event) => {
  console.error('❌ [Global Error]', {
    message: event.message,
    filename: event.filename,
    lineno: event.lineno,
    colno: event.colno,
    error: event.error,
  });
});

window.addEventListener('unhandledrejection', (event) => {
  console.error('❌ [Unhandled Promise Rejection]', {
    reason: event.reason,
    promise: event.promise,
  });
});

// Monitor fetch requests to see OAuth calls
const originalFetch = window.fetch;
window.fetch = async (...args) => {
  const [url, options] = args;
  console.log('🌐 [Fetch Request]', {
    url: typeof url === 'string' ? url : url.toString(),
    method: options?.method || 'GET',
    headers: options?.headers,
  });
  
  try {
    const response = await originalFetch(...args);
    console.log('🌐 [Fetch Response]', {
      url: typeof url === 'string' ? url : url.toString(),
      status: response.status,
      statusText: response.statusText,
      ok: response.ok,
    });
    return response;
  } catch (error) {
    console.error('❌ [Fetch Error]', {
      url: typeof url === 'string' ? url : url.toString(),
      error,
    });
    throw error;
  }
};

const queryClient = new QueryClient();

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <Theme appearance="light">
      <QueryClientProvider client={queryClient}>
        <SuiClientProvider networks={networkConfig} defaultNetwork="testnet">
          {/* Register Enoki zkLogin wallets before WalletProvider */}
          <RegisterEnokiWallets />
          <WalletProvider autoConnect
          slushWallet={{
            name: "Suitter7 dApp",
          }}
          >
            <App />
          </WalletProvider>
        </SuiClientProvider>
      </QueryClientProvider>
    </Theme>
  </React.StrictMode>,
);
