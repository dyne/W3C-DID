"use client";

import { Logo } from "@/ui/Logo";
import "./globals.css";

//

export interface RootLayoutProps {
  children: React.ReactNode;
}

export default function RootLayout(props: RootLayoutProps) {
  const { children } = props;

  return (
    <html lang="en">
      <head>
        <title>did:explorer | dyne.org</title>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width" />
        <meta name="title" content="DID:Explorer by Dyne.org" />
        <meta name="description" content="Explore, search and retrieve Dyne.org Distributed Identifiers, based on W3C standard." />
        <!-- Dublin Core basic info -->
        <meta name="dcterms.Title" content="DID:Explorer by Dyne.org" />
        <meta name="dcterms.Description" content="Explore, search and retrieve Dyne.org Distributed Identifiers, based on W3C standard." />
        <!-- Facebook -->
        <meta property="og:title" content="DID:Explorer by Dyne.org" />
        <meta property="og:locale" content="en" />
        <meta property="og:description" content="Explore, search and retrieve Dyne.org Distributed Identifiers, based on W3C standard." />
        <meta property="og:type" content="webpage" />
        <meta property="og:url" content="https://explorer.did.dyne.org/" />
        <meta property="og:site_name" content="DID:Explorer by Dyne.org" />
        <meta property="og:image" content="https://dyne.org/images/projects/did-explorer.jpg" />
        <!-- Twitter Card -->
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="DID:Explorer by Dyne.org" />
        <meta name="twitter:description" content="Explore, search and retrieve Dyne.org Distributed Identifiers, based on W3C standard." />
        <meta name="twitter:image" content="https://dyne.org/images/projects/did-explorer.jpg" />
        <meta name="twitter:creator" content="@DyneOrg">
      </head>

      <body>
        <nav className="p-4 bg-white shrink-0 z-50 sticky top-0">
          <Logo />
        </nav>
        {children}
      </body>
    </html>
  );
}
