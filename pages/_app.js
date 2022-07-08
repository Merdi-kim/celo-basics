import { CeloProvider, SupportedProviders } from '@celo/react-celo';
import '../styles/globals.css'
import '@celo/react-celo/lib/styles.css';

function MyApp({ Component, pageProps }) {
  return (
    <CeloProvider
      dapp={{
          name: "My awesome dApp",
          description: "My awesome description",
          url: "https://example.com",
      }}
      connectModal={{
        title: <span>Connect your Wallet</span>,
        providersOptions: {
          hideFromDefaults: [
            SupportedProviders.MetaMask,
            SupportedProviders.PrivateKey,
            SupportedProviders.Valora,
          ]
        },
      }}
    >
      <Component {...pageProps} />
    </CeloProvider> 
  )
   
}

export default MyApp
