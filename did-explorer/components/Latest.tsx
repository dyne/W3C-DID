
import { getData } from "lib/fetcher";
import { Suspense } from "react";
import DidTable from "./DidTable";
import { Title } from "./Typography";

const Latest = async () => {
    const data = await getData('did-extract-all-did-documents');
    const get_uniq_ids = (d: any) => Object.values(d).reduce((r: string[], i: any) => !~r.indexOf(i.id) ? (r.push(i.id), r) : r, []);
    const dids: string[] = get_uniq_ids(data.did_documents).filter(Boolean)
    return (
        <div className="w-full">
            <Title cn={"mb-8"}>Latest DID by Dyne.org</Title>
            <Suspense fallback={<p>Loading DIDs...</p>}>
                <DidTable dids={dids} />
            </Suspense>
        </div>
    )
}

export default Latest;
