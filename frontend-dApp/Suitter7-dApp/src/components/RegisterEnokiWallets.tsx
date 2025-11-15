import { useSuiClientContext } from '@mysten/dapp-kit';
import { isEnokiNetwork, registerEnokiWallets } from '@mysten/enoki';
import { useEffect, useRef } from 'react';

/**
 * RegisterEnokiWallets component
 * 
 * This component registers Enoki zkLogin wallets with the wallet provider.
 * It enables users to sign in with social accounts (Google, Facebook, Twitter)
 * without needing a traditional crypto wallet.
 * 
 * When users connect via Enoki, they can interact with the dApp seamlessly
 * without popup confirmations for every transaction.
 */
export function RegisterEnokiWallets() {
  const { client, network } = useSuiClientContext();
  const registeredRef = useRef(false);
  const unregisterRef = useRef<(() => void) | null>(null);

  useEffect(() => {
    console.log('🔍 [RegisterEnokiWallets] useEffect triggered');
    console.log('🔍 [RegisterEnokiWallets] Already registered?', registeredRef.current);
    console.log('🔍 [RegisterEnokiWallets] Current network:', network);
    console.log('🔍 [RegisterEnokiWallets] Client exists:', !!client);
    
    // Only register Enoki wallets on supported networks (testnet/mainnet)
    if (!isEnokiNetwork(network)) {
      console.warn(`⚠️ [RegisterEnokiWallets] Enoki wallets not available on ${network}`);
      return;
    }

    console.log('✅ [RegisterEnokiWallets] Network is supported for Enoki');

    // Get API keys from environment variables
    const enokiApiKey = import.meta.env.VITE_ENOKI_API_KEY;
    const googleClientId = import.meta.env.VITE_GOOGLE_CLIENT_ID;

    console.log('🔍 [RegisterEnokiWallets] Environment variables check:');
    console.log('  - VITE_ENOKI_API_KEY:', enokiApiKey ? `${enokiApiKey.substring(0, 20)}...` : 'NOT SET');
    console.log('  - VITE_GOOGLE_CLIENT_ID:', googleClientId ? `${googleClientId.substring(0, 20)}...` : 'NOT SET');
    console.log('  - Current origin:', window.location.origin);
    console.log('  - Current URL:', window.location.href);

    if (!enokiApiKey) {
      console.error('❌ [RegisterEnokiWallets] VITE_ENOKI_API_KEY is not set in environment variables');
      return;
    }

    if (!googleClientId) {
      console.error('❌ [RegisterEnokiWallets] VITE_GOOGLE_CLIENT_ID is not set in environment variables');
      return;
    }

    try {
      console.log('🔄 [RegisterEnokiWallets] Starting wallet registration...');
      
      const registrationConfig = {
        apiKey: enokiApiKey,
        providers: {
          // Google OAuth configuration
          google: {
            clientId: googleClientId,
          },
        },
        client,
        network,
      };

      console.log('🔍 [RegisterEnokiWallets] Registration config:', {
        apiKeyPrefix: enokiApiKey.substring(0, 20),
        googleClientIdPrefix: googleClientId.substring(0, 20),
        network,
        clientExists: !!client,
      });

      // Register Enoki wallets with configured providers
      const { unregister } = registerEnokiWallets(registrationConfig);
      
      registeredRef.current = true;
      unregisterRef.current = unregister;

      console.log('✅ [RegisterEnokiWallets] Enoki wallets registered successfully!');
      console.log('✅ [RegisterEnokiWallets] Available providers: Google');
      console.log('✅ [RegisterEnokiWallets] Users can now sign in with their Google account');
      console.log('✅ [RegisterEnokiWallets] Redirect URI should be:', `${window.location.origin}/`);

      // Clean up on unmount or when network/client changes
      return () => {
        console.log('🧹 [RegisterEnokiWallets] Cleaning up - unregistering wallets');
        if (unregisterRef.current) {
          unregisterRef.current();
          registeredRef.current = false;
          unregisterRef.current = null;
        }
      };
    } catch (error) {
      console.error('❌ [RegisterEnokiWallets] Failed to register Enoki wallets');
      console.error('❌ [RegisterEnokiWallets] Error details:', error);
      console.error('❌ [RegisterEnokiWallets] Error message:', error instanceof Error ? error.message : 'Unknown error');
      console.error('❌ [RegisterEnokiWallets] Error stack:', error instanceof Error ? error.stack : 'No stack trace');
    }
  }, [client, network]);

  // This component doesn't render anything
  return null;
}
