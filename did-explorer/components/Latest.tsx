
import { getData } from "lib/fetcher";
import { Suspense } from "react";
import DidTable from "./DidTable";
import { Title } from "./Typography";

const Latest = async () => {
    const dids: string[] = await getData('dids');
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
