import Latest from '@/ui/Latest'
import './globals.css'

export const metadata = {
      title:"Explore the dyne DID method with did:explorer",
      description:"Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
      openGraph:{
        url: "https://explorer.did.dyne.org/",
	locale: "en-US", 
	type: "website",
        title: "Explore the dyne DID method with did:explorer",
        siteName: "Explore the dyne DID method with did:explorer",
        description: "Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
        images: [
          { url: 'https://explorer.did.dyne.org/did-social-card.png' },
        ],
      },
      twitter:{
        creator: '@DyneOrg',
        site: '@site',
        title: "Explore the dyne DID method with did:explorer",
        description: "Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
        card: 'summary_large_image',
        images: [ 'https://explorer.did.dyne.org/did-social-card.png' ],
      }
}

export default function Home() {
    return (
        <>
            <Latest />
        </>
    )
}
