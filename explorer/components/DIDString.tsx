import { parse } from "did-resolver";

export interface DIDStringProps {
  did: string;
  wrap?: boolean;
}

export default function DIDString(props: DIDStringProps) {
  const { did, wrap = false } = props;
  const { method, id: fullId } = parse(did)!;
  const [submethod, id] = fullId.split(":");

  const colon = <span className="text-gray-400">:</span>;

  return (
    <p className="text-black">
      <span>did</span>
      {colon}
      <span className="text-orange-600">{method}</span>
      {colon}
      <span className="text-secondary-80">{submethod}</span>
      {colon}
      {wrap && <br />}
      <span>{id}</span>
    </p>
  );
}
