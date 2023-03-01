import { Title, Text } from "./Typography";

export interface MarketingPillProps {
  title: string;
  children: React.ReactNode;
}

export default function MarketingPill(props: MarketingPillProps) {
  const { title, children } = props;

  return (
    <div className="flex flex-col">
      <Title className="text-red-400">{title}</Title>
      <Text>{children}</Text>
    </div>
  );
}
