import { useCurrentAccount } from "@mysten/dapp-kit";
import { Container, Flex, Heading, Text } from "@radix-ui/themes";
import { OwnedObjects } from "./OwnedObjects";
import { useEffect } from "react";

export function WalletStatus() {
  const account = useCurrentAccount();

  useEffect(() => {
    console.log('🔍 [WalletStatus] Account state changed:', account);
    if (account) {
      console.log('✅ [WalletStatus] Wallet connected');
      console.log('  - Address:', account.address);
      console.log('  - Label:', account.label);
      console.log('  - Chains:', account.chains);
      console.log('  - Features:', account.features);
      console.log('  - Full account object:', account);
    } else {
      console.log('⚠️ [WalletStatus] No wallet connected');
    }
  }, [account]);

  return (
    <Container my="2">
      <Heading mb="2">Wallet Status</Heading>

      {account ? (
        <Flex direction="column">
          <Text>Wallet connected</Text>
          <Text>Address: {account.address}</Text>
        </Flex>
      ) : (
        <Text>Wallet not connected</Text>
      )}
      <OwnedObjects />
    </Container>
  );
}
