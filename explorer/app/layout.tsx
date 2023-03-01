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
