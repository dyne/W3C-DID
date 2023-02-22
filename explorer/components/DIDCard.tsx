import clsx from "clsx";
import { parse } from "did-resolver";
import Link from "next/link";
import DIDString from "./DIDString";

export interface DIDCardProps {
  did: string;
  selected?: boolean;
  onSelect?: (did: string) => void;
}

export default function DIDCard(props: DIDCardProps) {
  const { did, onSelect = () => {}, selected = false } = props;
  const { didUrl } = parse(did)!;

  function handleMouseOver() {
    onSelect(did);
  }

  const className = clsx(
    "rounded-md flex flex-row",
    selected ? "bg-secondary-20" : "bg-gray-10"
  );

  return (
    <div className={className} onMouseOver={handleMouseOver}>
      <div className="w-0 grow overflow-x-hidden">
        <Link href={`/details/${didUrl}`}>
          <div className="py-2 px-3">
            <DIDString did={did} />
          </div>
        </Link>
      </div>
    </div>
  );
}
