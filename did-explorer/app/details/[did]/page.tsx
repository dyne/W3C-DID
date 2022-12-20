import Copy from "@/ui/Copy";
import JsonBlock from "@/ui/JsonBlock";
import { Title } from "@/ui/Typography";
import { resolve } from "lib/resolver";


export default async function Details({ params }: { params: { did: string } }) {
    const document = await resolve(decodeURIComponent(params.did))

    return (
        <>
            <Title>DID details {document?.didDocument?.id}</Title>
            <div>
                <Copy text={JSON.stringify(document, null, 2)} />
            </div>
            <JsonBlock content={document} />
        </>
    )
}
