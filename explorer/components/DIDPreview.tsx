"use client";
import { parse, VerificationMethod } from "did-resolver";
import { resolve } from "lib/resolver";
import Link from "next/link";
import useSwr from "swr";
import JsonBlock from "./JSONBlock";
import Button from "./Button";

export interface DIDPreviewProps {
  did: string;
}

export default function DIDPreview(props: DIDPreviewProps) {
  const { did } = props;
  const { didUrl } = parse(did)!;
  const fetcher = (url: string) => resolve(url);
  const { data } = useSwr(didUrl, fetcher);
  const stringAttrs = "id description alsoKnownAs url".split(" ");
  const jsonAttrs = "proof".split(" ");
  const listAttrs = "verificationMethod service".split(" ");

  return (
    <>
      {didUrl && (
        <div className="rounded-md p-4">
          <div className="pb-4">
            <Link href={`/details/${didUrl}`}>
              <Button>VIEW RAW 📄</Button>
            </Link>
          </div>
          {data?.didDocument && (
            <div className="flex flex-col">
              {stringAttrs.map((a) => (
                <>
                  <div className="uppercase font-semibold">{a}</div>
                  {/* @ts-expect-error Type error */}
                  <div className="font-thin">{data.didDocument[a]}</div>
                </>
              ))}
              {jsonAttrs.map((a) => (
                <>
                  <div className="uppercase font-semibold">{a}</div>
                  {/* @ts-expect-error Type error */}
                  <JsonBlock content={data?.didDocument[a] || {}} />
                </>
              ))}
              {listAttrs.map((a) => (
                <>
                  <div className="uppercase font-semibold">{a}</div>
                  <div className="grid-col-2">
                    {/* @ts-expect-error Type error */}
                    {data?.didDocument[a]?.map((el) => (
                      <>
                        <div className="border text-xs space-1 m-1 p-1">
                          {Object.keys(el || {}).map((k) => (
                            <>
                              <div>
                                <span className="uppercase font-semibold">
                                  {k}{" "}
                                </span>
                                <span className="font-thin">{el[k]}</span>
                              </div>
                            </>
                          ))}
                        </div>
                      </>
                    ))}
                  </div>
                </>
              ))}
            </div>
          )}
          {data && <JsonBlock content={data?.didDocument} />}
        </div>
      )}
    </>
  );
}
