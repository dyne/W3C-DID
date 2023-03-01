export interface IconProps {
  source?: React.ReactNode;
}

export default function Icon(props: IconProps) {
  const { source } = props;

  return (
    <div className="flex items-center justify-center w-full h-full">
      {source}
    </div>
  );
}
