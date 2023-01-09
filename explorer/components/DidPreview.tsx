'use client'
import { VerificationMethod } from "did-resolver";
import { resolve } from "lib/resolver";
import Link from "next/link";
import useSwr from 'swr';
import JsonBlock from "./JsonBlock";


const DidPreview = ({ didUrl = "" }: { didUrl: string }) => {
    const fetcher = (url: string) => resolve(url);
    const { data } = useSwr(didUrl, fetcher)
    const stringAttrs = "id description alsoKnownAs url".split(" ")
    const jsonAttrs = "proof".split(" ")
    const listAttrs = "verificationMethod service".split(" ")

    return (
        <>
            {didUrl &&
                // <Suspense fallback="Loading...">
                <div className="h-full bg-secondary-10 px-4 overflow-hidden w-full relative">
                    <div className="absolute top-0 right-0 text-secondary">
                        <Link href={`/details/${didUrl}`}>
                            VIEW RAW 📄
                        </Link>
                    </div>
                    {data?.didDocument &&
                        <div className="flex flex-col">
                            {stringAttrs.map(a => <>
                                <div className="uppercase font-semibold">{a}</div>
                                {/* @ts-expect-error Type error */}
                                <div className="font-thin">{data.didDocument[a]}</div>
                            </>)}
                            {jsonAttrs.map(a => <>
                                <div className="uppercase font-semibold">{a}</div>
                                {/* @ts-expect-error Type error */}
                                <JsonBlock content={data?.didDocument[a] || {}} />
                            </>)}
                            {listAttrs.map(a => (<>
                                <div className="uppercase font-semibold">{a}</div>
                                <div className="grid-col-2">
                                    {/* @ts-expect-error Type error */}
                                    {data?.didDocument[a]?.map(el => <>
                                        <div className="border text-xs space-1 m-1 p-1">
                                            {Object.keys(el || {}).map((k) => <>
                                                <div>
                                                    <span className="uppercase font-semibold">{k} </span>
                                                    <span className="font-thin">{el[k]}</span>
                                                </div>
                                            </>)}
                                        </div>

                                    </>)}
                                </div>


                            </>))}
                        </div>}
                    {data &&
                        <JsonBlock content={data?.didDocument} />}
                </div>
                // </Suspense>}
            }
        </>
    );

}

export default DidPreview;