import "@fontsource/syne/500.css";
import Link from "next/link";

export const Logo = () => {
  return (
    <div className="flex space-x-2 items-baseline">
      <Link href={"/"}>
        <div className="px-1 text-lg font-semibold text-white rounded bg-cybersecurity">
          <span className="text-crypto">did:</span>explorer
        </div>
      </Link>
      <span className="font-medium font-display">by dyne.org</span>
    </div>
  );
};
