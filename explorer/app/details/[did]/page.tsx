import JSONBlock from "@/ui/JSONBlock";
import { Title } from "@/ui/Typography";
import { resolve } from "lib/resolver";
import DIDString from "@/ui/DIDString";
import StickyContainer from "@/ui/StickyContainer";
import CopyButton from "@/ui/CopyButton";
import IconButton from "@/ui/IconButton";
import ArrowLeft from "@/ui/icons/ArrowLeft";
import Link from "next/link";

//

export default async function Page({ params }: { params: { did: string } }) {
  const document = await resolve(decodeURIComponent(params.did));

  return (
    <>
      <StickyContainer>
        <div className="flex space-x-4 align-top">
          <Link href="/">
            <IconButton icon={<ArrowLeft />} />
          </Link>

          <div className="flex flex-col overflow-hidden space-y-2">
            <Title>
              <DIDString did={document?.didDocument?.id!} wrap />
            </Title>
            <Title className="text-gray-500">DID details</Title>
          </div>
        </div>
      </StickyContainer>

      <div className="overflow-auto p-4">
        <JSONBlock content={document} />
      </div>

      <div className="sticky bottom-0 flex justify-end p-4">
        <CopyButton text={JSON.stringify(document, null, 2)} />
      </div>
    </>
  );
}
