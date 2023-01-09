'use client';
import clsx from 'clsx';
import { parse } from 'did-resolver';
import Link from "next/link";
import { useState } from 'react';
import DidPreview from './DidPreview';

const DyneId = ({ i }: { i: string | undefined }) => {
    if (!i) return <></>
    const [submethod, id] = i.split(":");

    return (<>
        <span className="font-semibold text-orange-600">{submethod}:</span>
        <span>{id}</span>
    </>)

}

const DidTable = ({ dids }: { dids: string[] }) => {
    const [selected, setSelected] = useState<string>();

    return (
        <div className='flex mt-4'>
            <div className="flex flex-col space-y-3 text-sm w-full">
                {
                    dids.map((d) => {
                        const did = parse(d);
                        return (
                            <div key={did?.didUrl} className={clsx({ "bg-secondary-10": selected === did?.didUrl })}>
                                <Link href={`/details/${did?.didUrl}`}>
                                    <div className="flex items-center" onMouseOver={() => setSelected(did?.didUrl)} >
                                        {/* onMouseLeave={() => setSelected(undefined)}> */}
                                        <span>did:</span>
                                        <span className="text-secondary-80">{did?.method}:</span>
                                        <DyneId i={did?.id} />
                                    </div>
                                </Link>
                            </div>
                        )
                    })
                }
            </div>
            {selected &&
                <DidPreview didUrl={selected || ''} />}
        </div>
    )
}

export default DidTable