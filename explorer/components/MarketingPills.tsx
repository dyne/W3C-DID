import { ReactNode } from "react";
import { Title, Text } from "./Typography";

const MarketingPill = ({
  definition,
  children,
}: {
  definition: string;
  children: ReactNode;
}) => {
  return (
    <div className="flex lg:flex-col">
      <Title cn={"text-red-400 pt-4 pb-2"}>{definition}</Title>
      <Text>{children}</Text>
    </div>
  );
};
export default MarketingPill;
