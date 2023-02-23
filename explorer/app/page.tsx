"use client";

import { getData } from "lib/fetcher";
import { useEffect, useState } from "react";
import SearchBar from "@/ui/SearchBar";
import DIDCard from "@/ui/DIDCard";
import DIDPreview from "@/ui/DIDPreview";
import MarketingPills from "@/ui/MarketingPills";
import SearchDIDs from "@/ui/SearchDIDs";

export default function Page() {
  const [dids, setDids] = useState<string[]>([]);
  const [hoveredDid, setHoveredDid] = useState("");

  return (
    <div className="flex justify-center overflow-hidden h-[calc(100vh-60px)] w-screen pt-1">
      <div className="hidden grow shrink-0 basis-1/5 max-w-sm px-4 xl:flex xl:flex-col ">
        <div className="grow h-0 overflow-y-auto">
          <MarketingPills />
        </div>
      </div>

      <div className="shrink-0 px-4 flex flex-col space-y-6 max-w-fit">
        <SearchDIDs setDIDs={setDids} />
        <div className="grow h-0 overflow-y-auto space-y-2 max-w-fit">
          {dids.map((did) => (
            <div
              key={did}
              className="text-xs sm:text-base md:text-xs lg:text-base"
            >
              <DIDCard
                did={did}
                onSelect={setHoveredDid}
                selected={did == hoveredDid}
              />
            </div>
          ))}
        </div>
      </div>

      <div className="hidden grow shrink-0 basis-2/5 px-4 pb-4 md:flex md:flex-col max-w-7xl">
        <div className="grow h-0 overflow-y-auto bg-secondary-10 rounded-md flex flex-row items-stretch">
          <div className="grow w-0 overflow-x-auto flex">
            {hoveredDid && <DIDPreview did={hoveredDid} />}
            {!hoveredDid && (
              <div className="self-stretch grow flex items-center justify-center">
                <p className="text-secondary-60">
                  Hover a DID to preview its details!
                </p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

//

export const metadata = {
  title: "Explore the dyne DID method with did:explorer",
  description:
    "Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
  openGraph: {
    url: "https://explorer.did.dyne.org/",
    locale: "en-US",
    type: "website",
    title: "Explore the dyne DID method with did:explorer",
    siteName: "Explore the dyne DID method with did:explorer",
    description:
      "Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
    images: [{ url: "https://explorer.did.dyne.org/did-social-card.png" }],
  },
  twitter: {
    creator: "@DyneOrg",
    site: "@site",
    title: "Explore the dyne DID method with did:explorer",
    description:
      "Discover the power of the dyne DID method with did:explorer. Explore, verify, and manage your decentralized identities with ease.",
    card: "summary_large_image",
    images: ["https://explorer.did.dyne.org/did-social-card.png"],
  },
};
